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

        
        print("-=-========\(UIApplication.lx.visibleNavRootViewController)")
        
        self.webView.frame = CGRect(x: 0, y: 0, width: LXSwiftApp.screenW, height: LXSwiftApp.screenH)
        
        self.load(with: "http://www.baidu.com")
  
        let imgView = UIImageView(frame: CGRect(x: 100, y: 100, width: 260, height: 500))
        imgView.contentMode = .scaleAspectFit
        view.addSubview(imgView)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
            
            self.webView.lx.snapShotContentScroll { (image) in
                imgView.image = image

            }
            
//            imgView.image = self.webView.lx.snapShotImage
           
//
//            UIImage(named: "0gO3")?.lx.async_imageWithCircle(complete: { (image) in
//                 imgView.image = image
//            })
//
        }
    }


    deinit {
        print("-=-=-=-=-=-=")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.present(Test1ViewController(), animated: true, completion: nil)

    }
}
