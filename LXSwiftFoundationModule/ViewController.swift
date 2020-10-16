//
//  ViewController.swift
//  LXSwiftFoundationModule
//
//  Created by XL on 2020/9/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import LXSwiftFoundation
import SnapKit

class ViewController: UIViewController {
    var  objc : LXObjcThreadActive! = nil
    
    
     let button = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        

         let imgview = UIButton(frame: CGRect(x: 10, y: 200, width: 300, height: 300))
         imgview.backgroundColor = UIColor.blue
         view.addSubview(imgview)
        imgview.lx.preventDoubleHit(2)
        imgview.lx.setHandle { (button) in
        }
            
        
        
        
         button.backgroundColor = UIColor.blue
         view.addSubview(button)
        button.lx.preventDoubleHit(2)
        button.lx.setHandle { (button) in
        }
           
        button.snp.makeConstraints { (maker) in
            maker.left.equalTo(100)
            maker.bottom.equalTo(-100)
            maker.width.height.equalTo(100)
        }
        
        
    }
 

    override func viewLayoutMarginsDidChange() {
                print("===---==\(button.frame)")

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        

//        let vc = TestViewController()
//        self.present(vc, animated: true, completion: nil)
        
    }
    

}

extension String {
  
    func qq()  {
    }
}
