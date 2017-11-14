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
    
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designNavigationBarWithBackAnd(strTitle: detailBO.title)
        webView.loadHTMLString(detailBO.textplain, baseURL: nil)
        print("detailBO.textplain : \(detailBO.textplain)")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
