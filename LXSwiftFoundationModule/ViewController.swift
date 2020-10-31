//
//  ViewController.swift
//  LXSwiftFoundationModule
//
//  Created by XL on 2020/9/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import LXSwiftFoundation



class ViewController: UIViewController {
    var  objc : LXObjcThreadActive! = nil
    
    var i = 0

     override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        

         let imgView = UIImageView(frame: CGRect(x: 10, y: 200, width: 300, height: 300))
         self.view.addSubview(imgView)
        
         
        let str1 = "1.3.3.1"
        let str2 = "1.3.3"

//        let  temp = LXSwiftUtil.lx.versionCompare(str1, str2)
        let  temp = str1.lx.versionCompare(str2)

        print("-=-=-=-==-=-==\(temp)")
        let image = UIImage(named: "截屏2020-10-01 下午5.13.28")
        
        
        image!.lx.async_imageWithCircle { (img) in
            imgView.image = img
        }
        
        
        
      }
    
    

 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let index = 3
        
        switch index {
        case ~>=1:
            print("====>1")
            
        case ~<11:
            print("====>1")
        default:
            break
        }
        

        let vc = TestViewController()
        self.present(vc, animated: true, completion: nil)
        
    }
    

}
