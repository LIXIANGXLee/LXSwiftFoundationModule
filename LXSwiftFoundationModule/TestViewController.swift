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
         
        
         let image =  LXSwiftTool.lx.getQrCodeImage(with: "https://www.baidu.com/s?wd=swift%20CGContextRelease&rsv_spt=1&rsv_iqid=0x8f032f8b000029de&issp=1&f=8&rsv_bp=1&rsv_idx=2&ie=utf-8&rqlang=cn&tn=baiduhome_pg&rsv_enter=0&rsv_dl=tb&oq=swift%2520%2526lt%253BG%2526lt%253BontextRelease&rsv_btype=t&rsv_t=c595FCEh4bwLc9B6vfUjo%2BCEdG6h3OLYpbQV%2BdeOoGXLjHRTc3VkJT1slUN7UNBrSQnG&rsv_sug3=10&rsv_pq=a0dbcb9c00007b4f&prefixsug=swift%2520%2526lt%253BG%2526lt%253BontextRelease&rsp=5&rsv_sug9=es_0_1&rsv_sug4=798&rsv_sug=9")
           
            imgview.image = image
        
       
        
        
        if let qrcodeStr = LXSwiftTool.lx.getQrCodeString(with: image) {
            print("=======\(qrcodeStr)")

        }

        let s =  UISwitch(frame: CGRect(x: 200, y: 300, width: 100, height: 100))
          
        s.lx.setHandle { (isOn) in
//            print("=======\(isOn)")
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
