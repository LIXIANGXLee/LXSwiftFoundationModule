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
        

         let imgview = UIView(frame: CGRect(x: 10, y: 200, width: 300, height: 300))
         imgview.backgroundColor = UIColor.blue
         view.addSubview(imgview)
//         imgview.lx.preventDoubleHit(2)
//         imgview.lx.setHandle { (button) in
      
//        imgview.lx.setGradientLayer(with: [UIColor.red,UIColor.orange])
        

        imgview.lx.setPartCornerRadius(radius: 20, roundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight])
      
        
        let str = "rtrewdsds"
        
        switch str {
        case has_prefix("e"):
        print("-=-==-e")
        case has_suffix("w"):
        print("-=-==e-")
        case has_contains("ew"):
        print("-=-==ew-")

        default:
            break
        }
   
      }
    
    

 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        

        let vc = TestViewController()
        self.present(vc, animated: true, completion: nil)
        
    }
    

}

extension String {
  
    func qq()  {
    }
}
