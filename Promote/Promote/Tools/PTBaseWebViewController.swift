//
//  PTWebViewController.swift
//  Promote
//
//  Created by Bavaria on 2018/4/19.
//  web控制器

import UIKit
import WebKit



class PTBaseWebViewController: UIViewController {

    private let webView = WKWebView()
    private let activity = UIActivity()
    private let indicator = UIActivityIndicatorView()
    private let errLabl = PTBaseLabel()
    
    fileprivate var webCookies = [String]()
    
//    private var errLab: PTBaseLabel = {
//        let lab = UILabel()
//        lab.text = "加载失败，点击屏幕重试"
////        let tap = UITapGestureRecognizer.init(target: self, action: <#T##Selector?#>)
////        lab.addGestureRecognizer(tap)
//        return lab
//    }()
    
    var cookiesDidChange: ((WKWebView) -> Void)?
    
    private var processPool: WKProcessPool = {
       return WKProcessPool()
    }()
    
    // MARK： 默认网页配置
    private static var defaultPreference: WKPreferences = {
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
    convenience init(with config: WKWebViewConfiguration, preference: WKPreferences = defaultPreference ) {
        self.init()
        
        let configuration = config
        // 传入代理与要执行的方法
        configuration.preferences = preference
        HTTPCookieStorage.shared.cookieAcceptPolicy = .always
        configuration.processPool = processPool
        configuration.userContentController = getUserContentControllerWithCookies()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubviews()
    }

    private func setSubviews() {
        addSubview(webView)
        addSubview(indicator)
        
        webView.frame = view.bounds
        //        webView.uiDelegate = self
        webView.navigationDelegate = self
        // 手势华东返回、前进
        webView.allowsBackForwardNavigationGestures = true
        
        indicator.color = .gray
        indicator.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        indicator.center = view.center
        
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "back", style: .plain, target: self, action: #selector(didClickLeftNavigationItem))
        
        var cookieDic = [String: String]()
        var cookieValue = ""
        let cookieStore = HTTPCookieStorage.shared
        
        if let cookies = cookieStore.cookies {
            for cookie in cookies {
                cookieDic[cookie.name] = cookie.value
            }
            
            debugPrint("webview---cookies： \(cookies.debugDescription)")
        }
        
        let urlStr = "https://blog.csdn.net/u010105969/article/details/53942862" // https://
        let url = URL.init(string: urlStr)!
        var request = URLRequest.init(url: url)
//        request.addValue(cookieValue, forHTTPHeaderField: "Cookie")
        
        webView.load(request)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // -----------  private UI func  --------------- //
    @objc private func didClickLeftNavigationItem() {
        navigationController?.popViewController(animated: true)
    }

    private func showIndicator() {
        indicator.startAnimating()
    }
    
    private func hideIndicator() {
        indicator.stopAnimating()
    }
    
    
    // ----------------  webview private --------------- //
    private func getUserContentControllerWithCookies() -> WKUserContentController {
        // js 配置
        let userContentController = webView.configuration.userContentController
        
        if let cookies = HTTPCookieStorage.shared.cookies {
            let now = Date()
            var cookieString = "var cookieNames = document.cookie.split('; ').map(function(cookie) { return cookie.split('=')[0] } );\n"
            
            for cookie in cookies {
                if let expiresDate = cookie.expiresDate, now.compare(expiresDate) == .orderedDescending {
                    // 删除过期的cookies
                    HTTPCookieStorage.shared.deleteCookie(cookie)
                    continue
                }
                // js 代码
                cookieString += "if (cookieNames.indexOf('\(cookie.name)') == -1) { document.cookie='\(cookie.name)=\(cookie.value);domain=\(cookie.domain);path=\(cookie.path);'; };\n"
                webCookies.append(cookie.name)
            }
            
//            let javaScriptSource = "alert(\"WKUserScript注入js\");"
//            // forMainFrameOnly:NO(全局窗口)，yes（只限主窗口）
//            let userScript = WKUserScript.init(source: javaScriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
//            userContentController.addUserScript(userScript)
            
            // 注入js，在update(webView:）里执行js
            userContentController.addUserScript(WKUserScript(source: cookieString, injectionTime: .atDocumentStart, forMainFrameOnly: false))
        }
        
        return userContentController
        
    }
    
    fileprivate func update(webView: WKWebView) {
        webView.evaluateJavaScript("document.cookie;") { [weak self] (result, error) in
            guard let `self` = self,
                let documentCookie = result as? String else {
                    return
            }
            
            let cookieValues = documentCookie.components(separatedBy: "; ")
            
            for value in cookieValues {
                let comps = value.components(separatedBy: "=")
                if comps.count < 2 { continue }
                
                let localCookie = HTTPCookieStorage.shared.cookies?.filter { $0.name == comps[0] }.first
                
                if let localCookie = localCookie {
                    if !comps[1].isEmpty && localCookie.value != comps[1] {
                        // cookie value is different
                        if self.webCookies.contains(localCookie.name) {
                            webView.evaluateJavaScript("document.cookie='\(localCookie.name)=\(localCookie.value);domain=\(localCookie.domain);path=\(localCookie.path);'", completionHandler: nil)
                        } else {
                            // set cookie
                            var properties: [HTTPCookiePropertyKey: Any] = [
                                .name: localCookie.name,
                                .value: comps[1],
                                .domain: localCookie.domain,
                                .path: "/"
                            ]
                            
                            if let expireDate = localCookie.expiresDate {
                                properties[.expires] = expireDate
                            }
                            
                            if let cookie = HTTPCookie(properties: properties) {
                                HTTPCookieStorage.shared.setCookie(cookie)
                                //
                                self.cookiesDidChange?(webView)
                            }
                        }
                    }
                } else {  // 本地无相应的cookie
                    if let rootDomain = webView.url?.host, !comps[0].isEmpty && !comps[1].isEmpty {
                        let properties: [HTTPCookiePropertyKey: Any] = [
                            .name: comps[0],
                            .value: comps[1],
                            .domain: rootDomain,
                            .path: "/",
                            ]
                        
                        if let cookie = HTTPCookie(properties: properties) {
                            // set cookie
                            HTTPCookieStorage.shared.setCookie(cookie)
                            
                            //
                            self.cookiesDidChange?(webView)
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func update(cookies: [HTTPCookie]?) {
        cookies?.forEach {
            HTTPCookieStorage.shared.setCookie($0)
            webCookies.append($0.name)
        }
        
        //
        self.cookiesDidChange?(webView)
    }
    
    
}


extension PTBaseWebViewController: WKNavigationDelegate, WKScriptMessageHandler { // WKUIDelegate
   
    
    // MARK： WKNavigationDelegate
    // MARK: 在请求发起时拦截
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        
        if let url = navigationAction.request.url {
            
            let urlStr = url.absoluteString
            
            if url.isFileURL {
                
            } else {
                if urlStr.hasPrefix("http://") || urlStr.hasPrefix("https://") {
                    
                } else {
                    
                }
            }
            decisionHandler(.allow)
        } else {
            decisionHandler(.cancel)
        }
        
    }
    
    // MARK： 开始执行请求
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        showIndicator()
    }
    
    // MARK： 开始接收网页内容
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        // webview执行更新cookies的js代码
        update(webView: webView)
    }
    
    // MARK： 网页导航加载完毕
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        hideIndicator()
    }
    
    // MARK： 网页导航加载失败
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideIndicator()
    }
    
   
    
    // 获取请求结果
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        // 由 URLResponse -> HTTPURLResponse，为了获取cookies
        if let response = navigationResponse.response as? HTTPURLResponse {
            
            // 处理特殊code
            if response.statusCode == 404 {
                debugPrint("资源找不到！")
            }
            
            if let headers = response.allHeaderFields as? [String: String], let requestUrl = response.url {
                
                // 更新cookies
                update(cookies: HTTPCookie.cookies(withResponseHeaderFields: headers, for: requestUrl))
            }
            
            decisionHandler(.allow)
        } else {
            decisionHandler(.cancel)
        }
        
        
        
    }
    
   
    
    // 加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        hideIndicator()
        
    }
    
    // MARK： 跳转到其他的服务器\权限认证
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        
        
        if challenge.previousFailureCount >= 0 {
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust { // 被信任的
                
                // 获取证书
                if let credent = challenge.proposedCredential {
                    completionHandler(.performDefaultHandling, credent)
                } else {
                    let credent =  URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
                    completionHandler(.performDefaultHandling, credent)
                }
                
            } else {
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
        
    }
    
    // MARK： 重定向 ，一般不管
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
        hideIndicator()
    }
    
    // MARK： 进程终止，一般不用
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        
        hideIndicator()
    }
    
    // MARK： WKUIDelegate
    
    
    // MARK： WKScriptMessageHandler
    /**
     * 处理js调用oc方法
     */
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
}