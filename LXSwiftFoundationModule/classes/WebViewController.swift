//
//  Test1ViewController.swift
//  LXSwiftFoundationModule
//
//  Created by XL on 2020/10/17.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import LXSwiftFoundation

class WebViewController: SwiftWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH_TO_WIDTH, height: SCREEN_HEIGHT_TO_HEIGHT)
        
        self.load(urlString: "http://www.baidu.com")
  
        self.onURLUpdate = { a in
            SwiftLog.log(a)
        }
        
        self.onTitleUpdate = { a in
            SwiftLog.log(a)
        }
        
        self.onContentHeightChange = { a in
            SwiftLog.log(a)
        }
        
        let imgView = UIImageView(frame: CGRect(x: 100, y: 100, width: 260, height: 500))
        imgView.contentMode = .scaleAspectFit
        view.addSubview(imgView)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
            
            self.webView.lx.snapShotContentScroll { (image) in
                imgView.image = image

            }
        }
    }

    deinit {
        SwiftLog.log("-=-=-=-=-=-=")
    }

}
