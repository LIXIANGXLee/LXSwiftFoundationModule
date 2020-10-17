//
//  Test1ViewController.swift
//  LXSwiftFoundationModule
//
//  Created by XL on 2020/10/17.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import LXSwiftFoundation

class Test1ViewController: LXSwiftWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        self.webView.frame = CGRect(x: 0, y: 0, width: LXSwiftApp.screenW, height: LXSwiftApp.screenH)
        
        self.load(with: "http://www.baidu.com")
  
        
    }


}
