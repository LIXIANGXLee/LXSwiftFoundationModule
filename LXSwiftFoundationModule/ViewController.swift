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

     override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlStr = "http//msb.com/activity-rank?activityId=xxx&isEnd=0"
        
        let p1 =  URL(string: urlStr)!.lx.getUrlParams1
        let p2 =  URL(string: urlStr)!.lx.getUrlParamsWithOrder
        let p3 = urlStr.lx.getUrlParams1
        
        
        let dic = ["aa", "bb"] as [Any]
        
        
        print("-=-=-=-========\(LXSwiftApp.touchBarH)==\(dic.lx.arrToJsonStr?.lx.jsonStrToArr)==")
        
        
        print("=====----====\(Date().lx.isLeapYear)")
        
        self.view.backgroundColor = UIColor.white
        NotificationCenter.addObserver(self, selector: #selector(aa(_:)), notification: LXSwiftNotifications.shared)
        
        
        var btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.orange
        btn.frame = CGRect(x: 100, y: 100, width: 260, height: 100)
        btn.lx.y = 20

        btn.setTitle("首页tab_center", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.setImage(UIImage(named: "tab_center"), for: .normal)
//        btn.lx.horizontalCenterImageAndTitle(space: 20)
        btn.lx.verticalCenterImageAndTitle(space: 30, isLeftImage: false)
        view.addSubview(btn)
      }
    
    @objc func aa(_ notification: Notification) {
        let noti = LXSwiftNotifications.shared
        guard let config = noti.decodeInfo(from: notification) else {
            return
        }
        print("-------\(config.id)")
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        LXSwiftNotifications.shared.post(with: LXSwiftNotifications.Model.init(id: 10))
    }
}


extension LXSwiftNotifications {
     static let shared = LXSwiftNotification<Model>("aa")
     struct Model: Codable {
         var id: Int64
     }
 }
 
