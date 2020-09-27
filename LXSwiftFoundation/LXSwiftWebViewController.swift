//
//  LXWebViewController.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/4/23.
//  Copyright © 2020 李响. All rights reserved.
//

//WkWebView Loading web page encapsulation

import UIKit
import WebKit
import LXFitManager

public struct LXSwiftMethodT {
   public var method: String
   public var handel: (Any) -> ()
}

// MARK: - Solving circular references
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
    
    // MARK: -  Customize the root view -- recommended when the entire page is a WebView or image
    override open func loadView() {
        let config = WKWebViewConfiguration()
        //是否支持javaScript
        config.preferences.javaScriptEnabled = true
        config.allowsAirPlayForMediaPlayback = true

        webView = WKWebView(frame: .zero, configuration: config)
        webView.allowsBackForwardNavigationGestures = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }else {
            webView.translatesAutoresizingMaskIntoConstraints = false
        }
        view = webView
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
       
        setUI()
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
    
   /// load webview
   ///
   /// - Parameters:
   ///   - string: url
    open func load(with string: String) {
        if let url = URL(string: string){
            webView.load(URLRequest(url: url))
        }
    }
    
    /// load HTML
    ///
    /// - Parameters:
    ///   - string: HTML
    open func loadHTML(with string: String) {
        if string.count == 0 { return }
        webView.loadHTMLString(string, baseURL: Bundle.main.resourceURL)
    }
    
    /// load HTMLFile
    ///
    /// - Parameters:
    ///   - string:  file name
    ///   - type:  file type
    open func loadHTMLFile(with string: String,_ type: String) {
        if string.count == 0 { return }
        let url = Bundle.main.url(forResource: string, withExtension: type)!
        webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
    }
    
    /// load webView h5
    ///
    /// - Parameters:
    ///   - javaScriptString:  call back string
    ///   - completionHandler:  call back method
    open func noticeWebviewShareResult(_ javaScriptString: String, completionHandler: ((Any?, Error?) -> Void)? = nil) {
        webView.evaluateJavaScript(javaScriptString, completionHandler: completionHandler)
    }
    
    /// add js call back
    ///
    /// - Parameters:
    ///   - method:  name
    ///   - handel:  call back
    @available(iOS 8.0, *)
    open func jsMethod(_ method: String, _ handel: @escaping (Any) -> ()) {
        for methodT in methodTs {
            assert(methodT.method == method, "不能重复添加相同名称")
        }
        self.methodTs.append(LXSwiftMethodT(method: method, handel: handel))
        self.webView.configuration.userContentController.add(LXSwiftWeakScriptMessageDelegate(self), name: method)
    }
    
    ///Snap Shot
    ///
    /// - Parameters:
    ///   - rect:  size
    ///   - handel:  call back
    @available(iOS 11.0, *)
    open func takeSnapShot(_ rect: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), _ handel: @escaping (UIImage) -> ()) {
        let config = WKSnapshotConfiguration()
        config.rect = rect
        webView.takeSnapshot(with: config) { (image, error) in
            guard let image = image else{return}
            handel(image)
        }
    }
    
    /// remove cookie  HTTPCookie
    ///
    /// - Parameters:
    ///   - string:  string
    ///   - handel:  call back
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
    
    ///remove
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

// MARK: -  UI
extension LXSwiftWebViewController {

    fileprivate func setUI() {
        spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        webView.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: webView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: webView.centerYAnchor).isActive = true
        spinner.widthAnchor.constraint(equalToConstant: LXFit.fitFloat(60)).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: LXFit.fitFloat(60)).isActive = true
        
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        webView.addSubview(progressView)
        
        progressView.centerXAnchor.constraint(equalTo: webView.centerXAnchor).isActive = true
        progressView.widthAnchor.constraint(equalTo: webView.widthAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: LXFit.fitFloat(2)).isActive = true
        
    }
    
    ///observer
    fileprivate func addObserver() {
        ///Add observer -- monitors the value of the estimated progress property in real time
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)

    }
    
    ///Get the value of loading progress in real time
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress){
            progressView.progress = Float(webView.estimatedProgress)
        }else if  keyPath == #keyPath(WKWebView.title) {
            guard let t = webView.title else { return }
            self.loadWebViewTitle?(t)
        }else if  keyPath == #keyPath(WKWebView.url) {
            guard let u = webView.url else { return }
            self.loadWebViewUrl?(u)
        }
    }
    
    ///Executing JS code -- also known as injecting JavaScript
    fileprivate func handleJS(){
        webView.evaluateJavaScript("document.body.offsetHeight") { (res, error) in
            guard let h = res as? Int else { return }
            self.loadWebViewContentH?(Float(h))
        }
    }
}

// MARK: - WKNavigationDelegate Some hook functions from request to response
extension LXSwiftWebViewController: WKNavigationDelegate{
    
    ///Decide whether to load the website in the current WebView (for example, when the load contains a dynamic URL) - mainly based on the first-class information of the request
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
    
    ///Called when data is requested from the web server (web page begins to load)
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        spinner.startAnimating()
    }
    ///After receiving the response from the server, decide whether to load the website in the current WebView mainly based on the response header information
    open func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    ///Called when starting to receive data from the web server
    open func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) { }
    //Called when data is received from the web server (page loading complete)
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(#function)
        spinner.stopAnimating()
        spinner.removeFromSuperview()
        progressView.removeFromSuperview()

        //Inject JS code
        handleJS()
    }
    ///Called when a web page fails to load
    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(#function)
        spinner.stopAnimating()
        spinner.removeFromSuperview()
        progressView.removeFromSuperview()
    }
}

// MARK: - WKUIDelegate It is mainly used to convert the three pop-up boxes of the website into IOS native pop-up boxes
extension LXSwiftWebViewController: WKUIDelegate{
    
    //Closure: functions used as arguments
    //Non escape closure - default: the peripheral function is released after execution
    //Escape closure -@escaping : after the peripheral function is executed, its reference is still held by other objects and will not be released
    //Runaway closures are risky for memory management -- use cautiously unless you know it
    //[JS] alert() warning box
    open func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            completionHandler()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // [js]confirm()
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
    
    // [js]prompt()
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

