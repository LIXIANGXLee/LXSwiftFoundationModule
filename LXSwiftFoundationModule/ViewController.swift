//
//  ViewController.swift
//  LXSwiftFoundationModule
//
//  Created by XL on 2020/9/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
//import LXSwiftFoundation

class ViewController: UIViewController {
    var  objc : LXObjcThreadActive! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        

             let imgview = UIButton(frame: CGRect(x: 10, y: 200, width: 300, height: 300))
             imgview.backgroundColor = UIColor.blue
             view.addSubview(imgview)
        
        imgview.lx.setHandle { (button) in
            print("=======\(button)")
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
