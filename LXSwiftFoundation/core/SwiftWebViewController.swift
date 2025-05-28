//
//  SwiftWebViewController.swift
//  XLSwiftFoundation
//
//  Created by Mac on 2020/4/23.
//  Copyright © 2020 李响. All rights reserved.
//

/// WkWebView Loading web page encapsulation

import UIKit
import WebKit

///表示具有名称和回调的JavaScript方法处理程序
public struct SwiftJSCallHandler {
    public var methodName: String
    public var handler: (Any) -> Void
}

// MARK: - Weak Script Message Delegate

/// 弱引用包装器，防止WKScriptMessageHandler的保留周期
open class SwiftWeakScriptMessageDelegate: NSObject, WKScriptMessageHandler {
    private weak var delegate: WKScriptMessageHandler?
    
    init(delegate: WKScriptMessageHandler) {
        self.delegate = delegate
        super.init()
    }
    
    open func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage) {
        delegate?.userContentController(userContentController, didReceive: message)
    }
}

// MARK: - Web View Controller

/// 一个功能齐全的WKWebView控制器，具有进度跟踪、JavaScript交互和常见的web任务
@objc(LXObjcWebViewController)
@objcMembers open class SwiftWebViewController: UIViewController {
    // MARK: - Public Properties
  
    public typealias HeightHandler = (Float) -> Void
    public typealias TitleHandler = (String) -> Void
    public typealias URLHandler = (URL?) -> Void
    
    open var onContentHeightChange: HeightHandler?
    open var onTitleUpdate: TitleHandler?
    open var onURLUpdate: URLHandler?
    
    private var jsHandlers = [SwiftJSCallHandler]()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var progressBar: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .bar)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.tintColor = .systemBlue
        return progress
    }()

    // MARK: - 自定义根视图——当整个页面是WebView或图像时建议使用
    public private(set) lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.allowsAirPlayForMediaPlayback = true
        
        // 支持h5内嵌播放视频模式
        config.allowsInlineMediaPlayback = true
        
        // 是否自动播放（默认是自动播放）
        if #available(iOS 10.0, *) {
            config.mediaTypesRequiringUserActionForPlayback = []
        } else {
            config.requiresUserActionForMediaPlayback = false
        }
        
        // 是否支持javaScript
        if #available(iOS 14.0, *) {
            config.defaultWebpagePreferences.allowsContentJavaScript = true
        } else {
            config.preferences.javaScriptEnabled = true
        }
 
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.allowsBackForwardNavigationGestures = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        // 约束布局限制
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            webView.translatesAutoresizingMaskIntoConstraints = false
        }
        return webView
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        setupLoadingIndicators()
        addObserver()
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.title))
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.url))
        
        let controller = webView.configuration.userContentController
        jsHandlers.forEach { controller.removeScriptMessageHandler(forName: $0.methodName) }
        jsHandlers.removeAll()

    }
}

extension SwiftWebViewController {

    ///从URL字符串加载内容
    open func load(urlString: String,
                  cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
                  timeout: TimeInterval = 60.0) {
        guard let url = URL(string: urlString) else {
            handleInvalidURL(urlString)
            return
        }
        webView.load(URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeout))
    }
    /// 直接加载HTML内容
    open func loadHTMLString(_ string: String, baseURL: URL? = Bundle.main.resourceURL) {
        guard !string.isEmpty else {
            return
        }
        webView.loadHTMLString(string, baseURL: baseURL)
    }
    
    /// 加载HTML文件
   open func loadHTMLFile(with string: String,_ type: String) {
       guard !string.isEmpty,
             let url = Bundle.main.url(forResource: string, withExtension: type) else {
           return
       }
        webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
    }
    
    /// 注册JavaScript处理程序
    open func addJSHandler(for methodName: String, handler: @escaping (Any) -> Void) {
        guard !jsHandlers.contains(where: { $0.methodName == methodName }) else {
            assertionFailure("Duplicate JavaScript handler name: \(methodName)")
            return
        }
        
        let handler = SwiftJSCallHandler(methodName: methodName, handler: handler)
        jsHandlers.append(handler)
        webView.configuration.userContentController.add(
            SwiftWeakScriptMessageDelegate(delegate: self),
            name: methodName
        )
    }
    
    /// 加载网页视图h5
    open func evaluateJavaScript(with javaScriptString: String, completionHandler: ((Any?, Error?) -> Void)? = nil) {
        webView.evaluateJavaScript(javaScriptString, completionHandler: completionHandler)
    }
    
    
    /// 快照
    @available(iOS 11.0, *)
    open func snapShot(with rect: CGRect = CGRect(x: 0, y: 0, width: SCREEN_WIDTH_TO_WIDTH, height: SCREEN_HEIGHT_TO_HEIGHT), handel: @escaping (UIImage) -> ()) {
        let config = WKSnapshotConfiguration()
        config.rect = rect
        webView.takeSnapshot(with: config) { (image, error) in
            guard let image = image else{
                return
            }
            handel(image)
        }
    }
    
    /// 删除cookie HTTPCookie
    @available(iOS 11.0, *)
    open func handleCookie(_ string: String, handle: @escaping ([HTTPCookie]) -> ()) {
        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies {
            cookies in
            var results = [HTTPCookie]()
            cookies.forEach { [weak self] cookie in
                if cookie.name == string {
                    self?.webView.configuration.websiteDataStore.httpCookieStore.delete(cookie)
                } else {
                    results.append(cookie)
                }
            }
            handle(results)
        }
    }
    
    /// 清楚缓存
    public func clearBrowserCache(handle: ((String) -> ())?) {
        let dataSouce = WKWebsiteDataStore.default()
        dataSouce.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record]) { handle?("清除成功\(record)") }
            }
        }
    }
}

// MARK: - WKScriptMessageHandler
extension SwiftWebViewController: WKScriptMessageHandler {
    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        jsHandlers.forEach { method in
            if method.methodName == message.name {
                method.handler(message.body)
            }
        }
    }
}

// MARK: -  UI部分
extension SwiftWebViewController {
    
    func setupWebView() {
        view.addSubview(webView)
        webView.frame = view.bounds
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func setupLoadingIndicators() {
        
        webView.addSubview(activityIndicator)
        webView.addSubview(progressBar)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor),
//
//          progressBar.topAnchor.constraint(equalTo: webView.safeAreaLayoutGuide.topAnchor),
            progressBar.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: webView.trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: SCALE_IP6_WIDTH_TO_WIDTH(2))
        ])
    }
    
    ///observer
    private func addObserver() {
        /// 添加观察者--实时监视“估计进度”属性的值
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)
    }
    
    /// 实时获取加载进度的值
    override open func observeValue(forKeyPath keyPath: String?,of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            progressBar.progress = Float(webView.estimatedProgress)
        } else if keyPath == #keyPath(WKWebView.title) {
            self.onTitleUpdate?(webView.title ?? "")
        } else if keyPath == #keyPath(WKWebView.url) {
            self.onURLUpdate?(webView.url)
        }
    }
    
    /// 执行JS代码——也称为注入JavaScript
    private func updateContentHeight() {
        webView.evaluateJavaScript("document.body.offsetHeight") { (res, error) in
            guard let height = res as? Int else {
                return
            }
            self.onContentHeightChange?(Float(height))
        }
    }
    
    func handleInvalidURL(_ urlString: String) {
        let error = NSError(
            domain: "WebViewController",
            code: 400,
            userInfo: [NSLocalizedDescriptionKey: "Invalid URL: \(urlString)"]
        )
        handleLoadingError(error)
    }
    
    func handleLoadingError(_ error: Error) {
        let alert = UIAlertController(
            title: "Load Failed",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - WKNavigationDelegate Some hook functions from request to response
extension SwiftWebViewController: WKNavigationDelegate {
    
    ///决定是否在当前文件夹中加载网站，WebView（例如，当加载包含动态URL时），主要基于一级信息的请求
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        //        For example, all Google pages will be opened in an external browser, and the rest will be opened in the WebView of this app
        //        if let url = navigationAction.request.url{
        //            if url.host == "www.google.com"{
        //                LXApplicationShared.open(url)
        //                decisionHandler(.cancel)
        //                return
        //            }
        //        }
        decisionHandler(.allow)
    }
    
    /// 从web服务器请求数据时调用（网页开始加载）
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    /// 收到服务器响应后，主要根据响应头信息决定是否在当前WebView中加载网站
    open func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    /// 开始从web服务器接收数据时调用
    open func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) { }
    
    /// 从web服务器接收数据时调用（页面加载完成）
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SwiftLog.log(#function)
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        progressBar.removeFromSuperview()
        
        //Inject JS code
        updateContentHeight()
    }
    /// 当网页加载失败时调用
    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        SwiftLog.log(#function)
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        progressBar.removeFromSuperview()
    }
    
}

// MARK: - WKUIDelegate It is mainly used to convert the
//         three pop-up boxes of the website into IOS native pop-up boxes
extension SwiftWebViewController: WKUIDelegate {
    
    /// 闭包：用作参数的函数，非转义关闭-默认：执行后释放外围功能，Escape closure-@escaping:执行外围功能后，其引用仍由其他对象保留，
    /// 不会被释放，失控的闭包对于内存管理是有风险的——除非您知道，否则请谨慎使用
    /// [JS]警报（）警告框
    open func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.lx.addAction(with: "确定", style: .default) { (_) in
            completionHandler()
        }
        present(alert, animated: true, completion: nil)
    }
    
    // [js]confirm()
    open func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.lx.addAction(with: "取消", style: .cancel) { (_) in
            completionHandler(false)
        }
        alert.lx.addAction(with: "确定", style: .default) { (_) in
            completionHandler(true)
        }
        present(alert, animated: true, completion: nil)
    }
    
    // [js]prompt()
    open func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = defaultText
        }
        alert.lx.addAction(with: "确定", style: .default) { (_) in
            completionHandler(alert.textFields?.last?.text)
        }
        present(alert, animated: true, completion: nil)
    }
}
