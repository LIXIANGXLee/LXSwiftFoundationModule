//
//  LXNotificationCenter.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/5/1.
//

import UIKit

/// 例子
//extension LXSwiftNotificationBase {
//     static let shared = LXSwiftNotification<Model>("aa")
//     struct Model: Codable {
//         var id: Int64
//     }
// }
//
//LXSwiftNotificationBase.shared.post(with: LXSwiftNotificationBase.Model.init(id: 0))
//
//NotificationCenter.addObserver(self, selector: #selector(aa(_:)), notification: LXSwiftNotificationBase.shared)
//@objc func aa(_ notification: Notification) {
//    let noti = LXSwiftNotificationBase.shared
//    guard let config = noti.decodeInfo(from: notification) else {
//        return
//    }
//    print("-------\(config.id)")
//
//}

open class LXSwiftNotificationBase { }
public class LXSwiftNotification<T: Codable>: LXSwiftNotificationBase {
    
    let name: Notification.Name
    public init(_ name: String) {
        self.name = Notification.Name(name)
    }
    
    public func post(with object: T?) {
      
        let postObject = { (result: [AnyHashable: Any]?) in
            NotificationCenter.default.post(name: self.name, object: self, userInfo: result)
        }
        guard let jsonData = try? JSONEncoder().encode(object) else {
            postObject(nil)
            return
        }
        guard let jsonObjc = try? JSONSerialization.jsonObject(with: jsonData, options: []) else {
            postObject(nil)
            return
        }
        postObject(jsonObjc as? [AnyHashable: Any])
    }
    
    public func decodeInfo(from notification: Notification) -> T? {
        let systemInfo = notification.userInfo
        guard let notNilInfo = systemInfo else { return nil }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: notNilInfo, options: []) else { return nil }
        guard let decodeObjc = try? JSONDecoder().decode(T.self, from: jsonData) else { return nil }
        return decodeObjc
    }
}

extension NotificationCenter {
    public class func addObserver<T: Codable>(_ observer: Any,
            selector aSelector: Selector, notification: LXSwiftNotification<T>) {
        NotificationCenter.default.addObserver(observer,
             selector: aSelector, name: notification.name, object: nil)
    }
    
    public class func removeObserver(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }

}
