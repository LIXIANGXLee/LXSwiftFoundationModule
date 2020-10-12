//
//  TestViewController.swift
//  LXSwiftFoundationModule
//
//  Created by XL on 2020/10/9.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
//import LXSwiftFoundation

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
         let imgview = UIImageView(frame: CGRect(x: 10, y: 200, width: 300, height: 300))
//             imgview.contentMode = .scaleAspectFit
         imgview.backgroundColor = UIColor.blue
         imgview.isUserInteractionEnabled = true
         view.addSubview(imgview)
         


        let s =  UISlider(frame: CGRect(x: 100, y: 200, width: 300, height: 200))
        
        s.lx.setHandle { (value) in
            print("=======\(value)")
        }

//          s.addTarget(self, action: #selector(swichAction(_:)), for: .touchUpInside)
          view.addSubview(s)
    }
//
//    @objc private func swichAction(_ s: UISwitch) {
//        print("========\(s.isOn)")
//    }
    deinit {
        print("=TestViewController=deinit===")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.removeRunLoopObserver()

        self.dismiss(animated: true, completion: nil)
    }
}
