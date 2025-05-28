//
//  SwiftNotification.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/5/1.
//


/*
 // 定义数据类型
 struct UserData: Codable {
     let name: String
     let age: Int
 }

 // 创建通知实例
 let userNotification = SwiftNotification<UserData>("UserUpdated")

 // 发送通知
 userNotification.post(with: UserData(name: "John", age: 30))

 // 添加观察者
 class Observer {
     @objc func handleNotification(_ notification: Notification) {
         if let data = userNotification.decodeInfo(from: notification) {
            SwiftLog.log("收到用户数据: \(data.name), \(data.age)")
         }
     }
 }

 let observer = Observer()
 NotificationCenter.addObserver(observer,
                              selector: #selector(Observer.handleNotification(_:)),
                              notification: userNotification)

 // 移除观察者
 NotificationCenter.removeObserver(observer, notification: userNotification)
 // 或移除所有
 NotificationCenter.removeAllObservers(observer)*/

import UIKit

/// 通知基类，继承自NSObject以确保与NotificationCenter的兼容性
open class SwiftNotificationBase: NSObject {
    /// 通知名称
    public let name: Notification.Name
    
    /// 初始化方法
    /// - Parameter name: 通知名称字符串
    public init(name: String) {
        self.name = Notification.Name(name)
        super.init()
    }
}

/// 通用类型安全通知处理类，支持Codable类型的数据传输
public final class SwiftNotification<T: Codable>: SwiftNotificationBase {
    
    /// 初始化方法
    /// - Parameter name: 通知名称字符串
    public init(_ name: String) {
        super.init(name: name)
    }
    
    /// 发送通知
    /// - Parameter object: 要发送的Codable对象，将自动转换为字典格式
    public func post(with object: T?) {
        // 定义发送闭包
        let postObject = { (userInfo: [AnyHashable: Any]?) in
            NotificationCenter.default.post(
                name: self.name,
                object: nil,       // 设置为nil以接收所有同名通知
                userInfo: userInfo
            )
        }
        
        // 1. 将对象编码为JSON数据
        guard let jsonData = try? JSONEncoder().encode(object) else {
            SwiftLog.log("SwiftNotification: 编码失败 - 类型 \(T.self)")
            postObject(nil)
            return
        }
        
        // 2. 将JSON数据转换为字典对象
        guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData),
              let userInfo = jsonObject as? [AnyHashable: Any] else {
            SwiftLog.log("SwiftNotification: 转换字典失败 - 类型 \(T.self)")
            postObject(nil)
            return
        }
        
        postObject(userInfo)
    }
    
    /// 从通知中解析数据
    /// - Parameter notification: 接收到的系统通知
    /// - Returns: 解析后的Codable对象，失败时返回nil
    public func decodeInfo(from notification: Notification) -> T? {
        guard let userInfo = notification.userInfo else {
            SwiftLog.log("SwiftNotification: 用户信息为空 - 类型 \(T.self)")
            return nil
        }
        
        // 1. 将字典转换为JSON数据
        guard let jsonData = try? JSONSerialization.data(withJSONObject: userInfo) else {
            SwiftLog.log("SwiftNotification: 用户信息转换数据失败 - 类型 \(T.self)")
            return nil
        }
        
        // 2. 将JSON数据解码为对象
        do {
            return try JSONDecoder().decode(T.self, from: jsonData)
        } catch {
            SwiftLog.log("SwiftNotification: 解码失败 - 类型 \(T.self) 错误: \(error)")
            return nil
        }
    }
}

// MARK: - NotificationCenter扩展
extension NotificationCenter {
    
    /// 添加通知观察者
    /// - Parameters:
    ///   - observer: 观察者对象
    ///   - aSelector: 响应方法
    ///   - notification: 通知实例
    public class func addObserver<T: Codable>(
        _ observer: Any,
        selector aSelector: Selector,
        notification: SwiftNotification<T>
    ) {
        NotificationCenter.default.addObserver(
            observer,
            selector: aSelector,
            name: notification.name,
            object: nil  // 监听所有发送者
        )
    }
    
    /// 移除特定通知的观察者
    /// - Parameters:
    ///   - observer: 观察者对象
    ///   - notification: 要移除的通知实例
    public class func removeObserver<T: Codable>(
        _ observer: Any,
        notification: SwiftNotification<T>
    ) {
        NotificationCenter.default.removeObserver(
            observer,
            name: notification.name,
            object: nil
        )
    }
    
    /// 移除观察者的所有通知监听
    /// - Parameter observer: 要移除的观察者对象
    public class func removeAllObservers(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
}
