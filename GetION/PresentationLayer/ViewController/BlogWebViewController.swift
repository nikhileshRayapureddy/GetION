//
//  BlogWebViewController.swift
//  GetION
//
//  Created by NIKHILESH on 14/11/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit
import WebKit

class BlogWebViewController: BaseViewController {
    var detailBO = BlogBO()
    
    var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let configuration = WKWebViewConfiguration()

        webView = WKWebView(frame: self.view.bounds, configuration: configuration)
        webView.navigationDelegate = self
        self.designNavigationBarWithBackAnd(strTitle: detailBO.title)
        webView.loadHTMLString(detailBO.textplain, baseURL: nil)
        print("detailBO.textplain : \(detailBO.textplain)")
        self.view.addSubview(webView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension BlogWebViewController: WKNavigationDelegate
{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Webview Start")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Webview Error")
    }
}
