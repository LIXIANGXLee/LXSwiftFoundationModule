//
//  TestViewController.swift
//  LXSwiftFoundationModule
//
//  Created by XL on 2020/10/9.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import LXSwiftFoundation
import SnapKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
         let imgview = UIImageView()
//             imgview.contentMode = .scaleAspectFit
         imgview.backgroundColor = UIColor.blue
         imgview.isUserInteractionEnabled = true
         view.addSubview(imgview)
        
         imgview.snp.makeConstraints { (maker) in
             maker.left.equalTo(100)
             maker.top.equalTo(100)
             maker.width.equalTo(100)
             maker.height.equalTo(100)

         }
        
        imgview.lx.setGradientLayer(with: [UIColor.orange,UIColor.red],size: CGSize(width: 100, height: 100))
        

          LXSwiftRouter.regist(with: "http://hahaa你hh ") { (result) -> Any? in
              
              print("======\(result)")
              
              
              return self
              
          }
    }
    
    deinit {
        print("=TestViewController=deinit===")
    }
    
     
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        LXSwiftRouter.open(with: "http://hahaa你hh", paras: ["aa":"323232"]) { (result) in
            print("-=--=-=\(result)")
        }
    }
    
    
}
