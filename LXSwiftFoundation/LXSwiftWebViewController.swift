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

public struct LXSwiftMethod {
    public var method: String
    public var handel: (Any) -> ()
}

// MARK: - Solving circular references
/// 解决强引用问题
open class LXSwiftWeakScriptMessageDelegate:NSObject, WKScriptMessageHandler {
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
open class LXSwiftWebViewController: UIViewController {
    
    open var loadWebViewContentH: ((Float) -> ())?
    open var loadWebViewTitle: ((String) -> ())?
    open var loadWebViewUrl: ((URL) -> ())?
    
    fileprivate var spinner: UIActivityIndicatorView!
    fileprivate var progressView: UIProgressView!
    fileprivate var methodTs = [LXSwiftMethod]()
    
    // MARK: - Customize the root view -- recommended when the entire page is a WebView or image
    public fileprivate(set) lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        //是否支持javaScript
        config.preferences.javaScriptEnabled = true
        config.allowsAirPlayForMediaPlayback = true
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.allowsBackForwardNavigationGestures = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }else {
            webView.translatesAutoresizingMaskIntoConstraints = false
        }
        return webView
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(self.webView)
        setUI()
        addObserver()
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.title))
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.url))
        for methodT in methodTs {
            let vc =  webView.configuration.userContentController
            vc.removeScriptMessageHandler(forName: methodT.method)
        }
    }
}

extension LXSwiftWebViewController {
    
    /// load webview 的网络连接
    open func load(with string: String) {
        if let url = URL(string: string){
            webView.load(URLRequest(url: url))
        }
    }
    
    /// load HTML
    open func loadHTML(with string: String) {
        if string.count == 0 { return }
        webView.loadHTMLString(string, baseURL: Bundle.main.resourceURL)
    }
    
    /// load HTMLFile
    open func loadHTMLFile(with string: String,_ type: String) {
        if string.count == 0 { return }
        let url = Bundle.main.url(forResource: string, withExtension: type)!
        webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
    }
    
    /// load webView h5
    open func noticeWebviewShareResult(with javaScriptString: String, completionHandler: ((Any?, Error?) -> Void)? = nil) {
        webView.evaluateJavaScript(javaScriptString, completionHandler: completionHandler)
    }
    
    /// add js call back
    @available(iOS 8.0, *)
    open func jsMethod(with method: String, handel: @escaping (Any) -> ()) {
        for methodT in methodTs {
            assert(methodT.method == method, "不能重复添加相同名称")
        }
        self.methodTs.append(LXSwiftMethod(method: method, handel: handel))
        let vc = webView.configuration.userContentController
        vc.add(LXSwiftWeakScriptMessageDelegate(self), name: method)
    }
    
    /// Snap Shot 截图
    @available(iOS 11.0, *)
    open func takeSnapShot(with rect: CGRect = CGRect(x: 0, y: 0, width: LXSwiftApp.screenW, height: LXSwiftApp.screenH), handel: @escaping (UIImage) -> ()) {
        let config = WKSnapshotConfiguration()
        config.rect = rect
        webView.takeSnapshot(with: config) { (image, error) in
            guard let image = image else{return}
            handel(image)
        }
    }
    
    /// 删除cookie HTTPCookie
    @available(iOS 11.0, *)
    open func handleCookie(_ string: String, handle: @escaping ([HTTPCookie]) -> ()) {
        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies {
            cookies in
            var results = [HTTPCookie]()
            for cookie in cookies{
                if cookie.name == string{
                    self.webView.configuration.websiteDataStore.httpCookieStore.delete(cookie)
                }else{
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
            for record in records {
                let ds = WKWebsiteDataStore.default()
                ds.removeData(ofTypes: record.dataTypes, for: [record]) {
                    handle?("清除成功\(record)")
                }
            }
        }
    }
}

// MARK: - WKScriptMessageHandler
extension LXSwiftWebViewController: WKScriptMessageHandler {
    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        for methodT in methodTs {
            if methodT.method == message.name {
                methodT.handel(message.body)
            }
        }
    }
}

// MARK: -  UI部分
extension LXSwiftWebViewController {
    
    fileprivate func setUI() {
        spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        webView.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: webView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: webView.centerYAnchor).isActive = true
        spinner.widthAnchor.constraint(equalToConstant:scale_ip6_width(60)).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: scale_ip6_width(60)).isActive = true
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        webView.addSubview(progressView)
        
        progressView.centerXAnchor.constraint(equalTo: webView.centerXAnchor).isActive = true
        progressView.widthAnchor.constraint(equalTo: webView.widthAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: scale_ip6_width(2)).isActive = true
        
    }
    
    ///observer
    fileprivate func addObserver() {
        /// 添加观察者--实时监视“估计进度”属性的值
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)
        
    }
    
    /// 实时获取加载进度的值
    override open func observeValue(forKeyPath keyPath: String?,of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress){
            progressView.progress = Float(webView.estimatedProgress)
        }else if keyPath == #keyPath(WKWebView.title) {
            guard let t = webView.title else { return }
            self.loadWebViewTitle?(t)
        }else if keyPath == #keyPath(WKWebView.url) {
            guard let u = webView.url else { return }
            self.loadWebViewUrl?(u)
        }
    }
    
    /// 执行JS代码——也称为注入JavaScript
    fileprivate func handleJS(){
        webView.evaluateJavaScript("document.body.offsetHeight") { (res, error) in
            guard let h = res as? Int else { return }
            self.loadWebViewContentH?(Float(h))
        }
    }
}

// MARK: - WKNavigationDelegate Some hook functions from request to response
extension LXSwiftWebViewController: WKNavigationDelegate{
    
    ///决定是否在当前文件夹中加载网站，WebView（例如，当加载包含动态URL时），主要基于一级信息的请求
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        //        For example, all Google pages will be opened in an external browser, and the rest will be opened in the WebView of this app
        //        if let url = navigationAction.request.url{
        //            if url.host == "www.google.com"{
        //                UIApplication.shared.open(url)
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
extension LXSwiftWebViewController: WKUIDelegate{
    
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

