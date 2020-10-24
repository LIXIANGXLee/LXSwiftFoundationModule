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
        

         var viewt = LXSwiftTextField(frame: CGRect(x: 10, y: 200, width: 300, height: 300))
         viewt.backgroundColor = UIColor.red
         self.view.addSubview(viewt)
        viewt.lx.maxLength = 8
        viewt.lx.setHandle { (str) in
            print("======\(str)")
        }
        
        let d: Double = 3.54657855643
//        print("-=-=-=\(3.232434.lx.k)")
        d.lx.keep
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
        

        let vc = Test1ViewController()
        self.present(vc, animated: true, completion: nil)
        
    }
    

}
