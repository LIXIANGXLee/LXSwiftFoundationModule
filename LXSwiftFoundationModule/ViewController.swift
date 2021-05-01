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
        
        print("-----------\(UIApplication.shared.statusBarFrame.height)")
        print("-----------\(LXSwiftRegex.httpRegex)")

        

         let imgView = UIImageView(frame: CGRect(x: 10, y: 200, width: 300, height: 300))
         self.view.addSubview(imgView)
        
         
        let str1 = "1.3.3.1"
        let str2 = "1.3.3"

        let  temp = str1.lx.versionCompare(str2)

        let image = UIImage(named: "截屏2020-10-01 下午5.13.28")
        image!.lx.async_imageWithCircle { (img) in
            imgView.image = img
        }
        
        let str = "dsdasdfsfdsfdsf"
        
        print(str.lx.substring(to: 3));
        
        
        NotificationCenter.addObserver(self, selector: #selector(aa(_:)), notification: LXSwiftNotifications.shared)
        
      }
    
    @objc func aa(_ notification: Notification) {
        let noti = LXSwiftNotifications.shared
        guard let config = noti.decodeInfo(from: notification) else {
            return
        }
        print("-------\(config.id)")
      
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        LXSwiftStorage.lx.setStorage(with: "dsdsdsdsds", key: "haha")
        
        
        let urlStr = "https://www.baidu.com?id=20&aa=dew"
        let url = URL(string: urlStr)
        print(url!.lx.getParameters())
        print(url!.lx.getParametersWithOrder())

        
        LXSwiftNotifications.shared.post(with: LXSwiftNotifications.Model.init(id: 10))
        

        
//        let index = 3
//
//        switch index {
//        case ~>=1:
//            print("====>1")
//
//        case ~<11:
//            print("====>1")
//        default:
//            break
//        }
//
//
//        let vc = TestViewController()
//        self.present(vc, animated: true, completion: nil)
//
    }
    

}


extension LXSwiftNotifications {
     static let shared = LXSwiftNotification<Model>("aa")
     struct Model: Codable {
         var id: Int64
     }
 }
 
