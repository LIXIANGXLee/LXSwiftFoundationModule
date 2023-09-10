//
//  LXWebViewController.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/4/23.
//  Copyright © 2020 李响. All rights reserved.
//

/// WkWebView Loading web page encapsulation

import UIKit
import WebKit

public struct SwiftMethod {
    public var method: String
    public var handel: (Any) -> ()
}

// MARK: - Solving circular references
/// 解决强引用问题
open class SwiftWeakScriptMessageDelegate: NSObject, WKScriptMessageHandler {
    fileprivate weak var delegate: WKScriptMessageHandler?
    init(_ delegate: WKScriptMessageHandler) {
        self.delegate = delegate
        super.init()
    }
    
    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.delegate?.userContentController(userContentController, didReceive: message)
    }
}

/// MARK: - WKWebView
@objc(LXObjcWebViewController)
@objcMembers open class SwiftWebViewController: UIViewController {
    
    open var loadWebViewContentHeight: ((Float) -> ())?
    open var loadWebViewTitle: ((String) -> ())?
    open var loadWebViewUrl: ((URL) -> ())?
    
    private var spinner: UIActivityIndicatorView!
    private var progressView: UIProgressView!
    private var methods = [SwiftMethod]()
    
    // MARK: - Customize the root view -- recommended when the entire page is a WebView or image
    public private(set) lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.allowsAirPlayForMediaPlayback = true
        
        // 支持h5内嵌播放视频模式
        config.allowsInlineMediaPlayback = true
        
        // 是否支持javaScript
        if #available(iOS 14.0, *) {
            config.defaultWebpagePreferences.allowsContentJavaScript = true
        } else {
            config.preferences.javaScriptEnabled = true
        }
        
        // 是否自动播放（默认是自动播放）
        if #available(iOS 10.0, *) {
            config.mediaTypesRequiringUserActionForPlayback = []
        } else {
            config.requiresUserActionForMediaPlayback = false
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
        view.addSubview(webView)
        setUI()
        addObserver()
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.title))
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.url))
        methods.forEach { method in
            let vc = webView.configuration.userContentController
            vc.removeScriptMessageHandler(forName: method.method)
        }
    }
}

extension SwiftWebViewController {
    
    /// load webview 的网络连接
    open func load(with string: String, cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy, timeoutInterval: TimeInterval = 60.0) {
        
        guard let url = URL(string: string) else {
            return
        }
        webView.load(URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval))
       
    }
    
    /// load HTML
   open func loadHTML(with string: String, baseURL: URL? = Bundle.main.resourceURL) {
        if string.count == 0 {
            return
        }
        webView.loadHTMLString(string, baseURL: baseURL)
    }
    
    /// load HTMLFile
   open func loadHTMLFile(with string: String,_ type: String) {
        if string.count == 0 {
            return
        }
        let url = Bundle.main.url(forResource: string, withExtension: type)!
        webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
    }
    
    /// load webView h5
    open func evaluateJavaScript(with javaScriptString: String, completionHandler: ((Any?, Error?) -> Void)? = nil) {
        webView.evaluateJavaScript(javaScriptString, completionHandler: completionHandler)
    }
    
    /// add js call back
    @available(iOS 8.0, *)
    open func jsMethod(with method: String, handel: @escaping (Any) -> ()) {
        for m in methods {
            assert(m.method == method, "不能重复添加相同名称")
        }
        self.methods.append(SwiftMethod(method: method, handel: handel))
        let vc = webView.configuration.userContentController
        vc.add(SwiftWeakScriptMessageDelegate(self), name: method)
    }
    
    /// Snap Shot 截图
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
        methods.forEach { method in
            if method.method == message.name {
                method.handel(message.body)
            }
        }
    }
}

// MARK: -  UI部分
extension SwiftWebViewController {
    
    private func setUI() {
        spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        webView.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: webView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: webView.centerYAnchor).isActive = true
        spinner.widthAnchor.constraint(equalToConstant:SCALE_IP6_WIDTH_TO_WIDTH(60)).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: SCALE_IP6_WIDTH_TO_WIDTH(60)).isActive = true
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        webView.addSubview(progressView)
        
        progressView.centerXAnchor.constraint(equalTo: webView.centerXAnchor).isActive = true
        progressView.widthAnchor.constraint(equalTo: webView.widthAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: SCALE_IP6_WIDTH_TO_WIDTH(2)).isActive = true
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
            progressView.progress = Float(webView.estimatedProgress)
        } else if keyPath == #keyPath(WKWebView.title) {
            guard let t = webView.title else {
                return
            }
            self.loadWebViewTitle?(t)
        } else if keyPath == #keyPath(WKWebView.url) {
            guard let u = webView.url else {
                return
            }
            self.loadWebViewUrl?(u)
        }
    }
    
    /// 执行JS代码——也称为注入JavaScript
    private func handleJS() {
        webView.evaluateJavaScript("document.body.offsetHeight") { (res, error) in
            guard let height = res as? Int else {
                return
            }
            self.loadWebViewContentHeight?(Float(height))
        }
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
        spinner.startAnimating()
    }
    
    /// 收到服务器响应后，主要根据响应头信息决定是否在当前WebView中加载网站
    open func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    /// 开始从web服务器接收数据时调用
    open func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) { }
    
    /// 从web服务器接收数据时调用（页面加载完成）
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(#function)
        spinner.stopAnimating()
        spinner.removeFromSuperview()
        progressView.removeFromSuperview()
        
        //Inject JS code
        handleJS()
    }
    /// 当网页加载失败时调用
    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(#function)
        spinner.stopAnimating()
        spinner.removeFromSuperview()
        progressView.removeFromSuperview()
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

