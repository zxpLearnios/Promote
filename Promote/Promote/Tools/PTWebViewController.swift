//
//  PTWebViewController.swift
//  Promote
//
//  Created by Bavaria on 2018/4/19.
//

import UIKit
import WebKit



class PTWebViewController: UIViewController {

    let webView = WKWebView()
    
    private var defaultPreference: WKPreferences = {
        let preference = WKPreferences()
        preference.javaScriptCanOpenWindowsAutomatically = true
        preference.minimumFontSize = 20
        return preference
    }()
    
    convenience init(with urlStr: String) {
        self.init()
    }
    
    /**
     * 配置config，用于js与原生交互
     */
    convenience init(with config: WKWebViewConfiguration, preference: WKPreferences) {
        self.init()
        var configuration = config
        configuration.userContentController = WKUserContentController()
        // 传入代理与要执行的方法
//        configuration.userContentController.add(self, name: "")
        configuration.preferences = preference
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubviews()
    }

    private func setSubviews() {
        addSubview(webView)
        webView.frame = view.bounds
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "<", style: .plain, target: self, action: #selector(didClickLeftNavigationItem))
        
        var cookieDic = [String: String]()
        var cookieValue = ""
        let cookieStore = HTTPCookieStorage.shared
        
        if let cookies = cookieStore.cookies {
            for cookie in cookies {
                cookieDic[cookie.name] = cookie.value
            }
            
            debugPrint("webview---cookies： \(cookies.debugDescription)")
        }
        
        let urlStr = "blog.csdn.net/u010105969/article/details/53942862" // https://
        let url = URL.init(string: urlStr)!
        var request = URLRequest.init(url: url)
        request.addValue(cookieValue, forHTTPHeaderField: "Cookie")
        
        webView.load(request)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @objc private func didClickLeftNavigationItem() {
        navigationController?.popViewController(animated: true)
    }

}


extension PTWebViewController: WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
   
    
    // MARK： WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    // 拦截t
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        decisionHandler(.allow)
    }
    
    // 获取请求结果
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        // 由 URLResponse -> HTTPURLResponse，为了获取cookies
        
        
        
        return
        let response = navigationResponse.response as! HTTPURLResponse
        let headers = response.allHeaderFields
        let requestUrl = response.url!
        
        HTTPCookie.cookies(withResponseHeaderFields: headers as! [String : String], for: requestUrl)
        
        decisionHandler(.allow)
    }
    
    
    // MARK： WKUIDelegate
    
    
    // MARK： WKScriptMessageHandler
    /**
     * 处理js调用oc方法
     */
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
}
