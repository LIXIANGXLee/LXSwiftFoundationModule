//
//  LXWebViewController.swift
//  LXFoundationManager
//
//  Created by Mac on 2020/4/23.
//  Copyright © 2020 李响. All rights reserved.
//

//WkWebView 加载网页封装

import UIKit
import WebKit
import LXFitManager

public struct LXSwiftMethodT {
   public var method: String
   public var handel: (Any) -> ()
}

// MARK: - 解决循环引用问题
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
    fileprivate(set) var webView: WKWebView!
    
    fileprivate var spinner: UIActivityIndicatorView!
    fileprivate var progressView: UIProgressView!
    fileprivate var methodTs = [LXSwiftMethodT]()
    
    // MARK: -  自定义根视图--当整个页面是webview或图片时推荐这么做
    override open func loadView() {
        let config = WKWebViewConfiguration()
        //是否支持javaScript
        config.preferences.javaScriptEnabled = true
        config.allowsAirPlayForMediaPlayback = true

        webView = WKWebView(frame: .zero, configuration: config)
        webView.allowsBackForwardNavigationGestures = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
        //适配iOS 11
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }else {
            webView.translatesAutoresizingMaskIntoConstraints = false
        }
        view = webView
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
       
        //设置UI
        setUI()
        
       //设置观察者
        addObserver()
        
    }
    
    deinit {
        
        if webView == nil { return }
        
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.title))
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.url))
        for methodT in methodTs {
            webView.configuration.userContentController.removeScriptMessageHandler(forName: methodT.method)
        }
    }
}

extension LXSwiftWebViewController {
    
   /// 加载web
   ///
   /// - Parameters:
   ///   - string: url 地址
    open func load(with string: String) {
        if let url = URL(string: string){
            webView.load(URLRequest(url: url))
        }
    }
    
    /// 加载HTML
    ///
    /// - Parameters:
    ///   - string: HTML标签
    open func loadHTML(with string: String) {
        if string.count == 0 { return }
        webView.loadHTMLString(string, baseURL: Bundle.main.resourceURL)
    }
    
    /// 加载HTMLFile
    ///
    /// - Parameters:
    ///   - string:  文件名
    ///   - type:  文件类型
    open func loadHTMLFile(with string: String,_ type: String) {
        if string.count == 0 { return }
        let url = Bundle.main.url(forResource: string, withExtension: type)!
        //allowingReadAccessTo-html文件里面要用到的图片，css，js文件，通常都是放在一个文件夹里面拖进来
        //deletingLastPathComponent返回父url
        webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
    }
    
    /// 通知webView结果（调用h5）
    ///
    /// - Parameters:
    ///   - javaScriptString:  传给h5 的字符串
    ///   - completionHandler:  回调函数
    open func noticeWebviewShareResult(_ javaScriptString: String, completionHandler: ((Any?, Error?) -> Void)? = nil) {
        webView.evaluateJavaScript(javaScriptString, completionHandler: completionHandler)
    }
    
    ///添加js回调
    ///
    /// - Parameters:
    ///   - method:  函数名
    ///   - handel:  回调函数
    @available(iOS 8.0, *)
    open func jsMethod(_ method: String, _ handel: @escaping (Any) -> ()) {
        for methodT in methodTs {
            assert(methodT.method == method, "不能重复添加相同名称")
        }
        self.methodTs.append(LXSwiftMethodT(method: method, handel: handel))
        self.webView.configuration.userContentController.add(LXSwiftWeakScriptMessageDelegate(self), name: method)
    }
    
    ///获取截图
    ///
    /// - Parameters:
    ///   - rect:  截屏尺寸
    ///   - handel:  回调函数
    @available(iOS 11.0, *)
    open func takeSnapShot(_ rect: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), _ handel: @escaping (UIImage) -> ()) {
        let config = WKSnapshotConfiguration()
        config.rect = rect
        webView.takeSnapshot(with: config) { (image, error) in
            guard let image = image else{return}
            handel(image)
        }
    }
    
    ///删除cookie 并且返回剩余的 HTTPCookie
    ///
    /// - Parameters:
    ///   - string:  字符串
    ///   - handel:  回调函数
    @available(iOS 11.0, *)
    open func handleCookie(_ string: String,handle: @escaping ([HTTPCookie]) -> ()) {
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
    
    ///删除缓存数据
     public func clearBrowserCache(handle: ((String) -> ())?) {
         let dataSouce = WKWebsiteDataStore.default()
          dataSouce.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
             for record in records {
                 WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record]) {
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

// MARK: -  初始化UI界面
extension LXSwiftWebViewController {

    fileprivate func setUI() {
        //配置加载小菊花
        spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        webView.addSubview(spinner)
        
        //布局 约束
        spinner.centerXAnchor.constraint(equalTo: webView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: webView.centerYAnchor).isActive = true
        spinner.widthAnchor.constraint(equalToConstant: LXFit.fitFloat(60)).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: LXFit.fitFloat(60)).isActive = true
        
        
        //进度条
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        webView.addSubview(progressView)
        
        progressView.centerXAnchor.constraint(equalTo: webView.centerXAnchor).isActive = true
        progressView.widthAnchor.constraint(equalTo: webView.widthAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: LXFit.fitFloat(2)).isActive = true
        
    }
    
    ///添加观察者
    fileprivate func addObserver() {
        //添加观察者--实时监测加载进度(estimatedProgress)属性的值
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)

    }
    
    ///实时获取加载进度的值
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress){
            //可以把实时变化的值赋给progress view的progress属性，做一个加载进度条的功能
            progressView.progress = Float(webView.estimatedProgress)
        }else if  keyPath == #keyPath(WKWebView.title) {
            guard let t = webView.title else { return }
            self.loadWebViewTitle?(t)
        }else if  keyPath == #keyPath(WKWebView.url) {
            guard let u = webView.url else { return }
            self.loadWebViewUrl?(u)
        }
    }
    
    ///执行js代码--也叫Injecting JavaScript
    fileprivate func handleJS(){
        webView.evaluateJavaScript("document.body.offsetHeight") { (res, error) in
            guard let h = res as? Int else { return }
            self.loadWebViewContentH?(Float(h))
        }
    }
}

// MARK: - WKNavigationDelegate 从请求到响应的一些钩子函数
extension LXSwiftWebViewController: WKNavigationDelegate{
    //1.决定要不要在当前webview中加载网站（比如load里面是动态url时）--主要根据请求头等信息
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //        比如所有google的页面都会在外部浏览器打开，其余的在本app的webView中打开
        //        if let url = navigationAction.request.url{
        //            if url.host == "www.google.com"{
        //                UIApplication.shared.open(url)
        //                decisionHandler(.cancel)
        //                return
        //            }
        //        }
        decisionHandler(.allow)
    }
    //2.向Web服务器请求数据时调用(网页开始加载)
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        spinner.startAnimating()
    }
    //3.在收到服务器的响应后，决定要不要在当前webview中加载网站--主要根据响应头等信息
    open func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        //        比如可以根据statusCode决定是否加载
        //        if let httpResponse = navigationResponse.response as? HTTPURLResponse,
        //            httpResponse.statusCode == 200{
        //            decisionHandler(.allow)
        //        }else{
        //            decisionHandler(.cancel)
        //        }
        decisionHandler(.allow)
    }
    //4.开始从Web服务器接收数据时调用
    open func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) { }
    //5.从Web服务器接收完数据时调用(网页加载完成)
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(#function)
        spinner.stopAnimating()
        spinner.removeFromSuperview()
        progressView.removeFromSuperview()

        //注入js代码
        handleJS()
    }
    //网页加载失败时调用
    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(#function)
        spinner.stopAnimating()
        spinner.removeFromSuperview()
        progressView.removeFromSuperview()
    }
}

// MARK: - WKUIDelegate 主要用来把网站的三种弹出框转化为iOS原生的弹出框
extension LXSwiftWebViewController: WKUIDelegate{
    //闭包：被用作为参数的函数
    //非逃逸闭包-默认：外围函数执行完毕后被释放
    //逃逸闭包-@escaping：外围函数执行完毕后，他的引用仍旧被其他对象持有，不会被释放
    //逃逸闭包对内存管理有风险--谨慎使用除非明确知道
    // [js]alert()警告框
    open func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            completionHandler()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // [js]confirm()确认框
    open func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
            completionHandler(false)
        }))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            completionHandler(true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // [js]prompt()输入框
    open func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = defaultText
        }
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            completionHandler(alert.textFields?.last?.text)
        }))
        present(alert, animated: true, completion: nil)
    }
}

