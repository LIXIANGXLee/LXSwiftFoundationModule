//
//  NotificationTest.swift
//  LXSwiftFoundationModule
//
//  Created by xrj on 2025/5/28.
//  Copyright © 2025 李响. All rights reserved.
//
// 定义数据类型
struct UserData: Codable {
    let name: String
    let age: Int
}


class NotificationTest: UIViewController {
    
    
    // 创建通知实例
    let userNotification = SwiftNotification<UserData>("UserUpdated")


    @objc func handleNotification(_ notification: Notification) {
        if let data = userNotification.decodeInfo(from: notification) {
            SwiftLog.log("收到用户数据: \(data.name), \(data.age)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        view.backgroundColor = UIColor.white
        
        NotificationCenter.addObserver(self, selector: #selector(handleNotification(_:)), notification: userNotification)
        
    
         // 发送通知
         userNotification.post(with: UserData(name: "John", age: 30))

    }
}
