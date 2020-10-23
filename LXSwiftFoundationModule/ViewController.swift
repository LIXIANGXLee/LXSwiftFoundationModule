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
        

         let imgview = UIImageView(frame: CGRect(x: 10, y: 200, width: 300, height: 300))
         imgview.backgroundColor = UIColor.blue
         view.addSubview(imgview)
//         imgview.lx.preventDoubleHit(2)
//         imgview.lx.setHandle { (button) in
      
//        imgview.lx.setGradientLayer(with: [UIColor.red,UIColor.orange])
        
      
        guard let image = UIImage(named: "截屏2020-10-01 下午5.13.28") else {return }
        
        
        guard let base64String = image.lx.base64EncodingImageString  else {return }
        
        imgview.image = base64String.lx.base64EncodingImage
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
