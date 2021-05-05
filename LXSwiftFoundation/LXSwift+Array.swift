//
//  LXSwift+Array.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/5/5.
//

import UIKit
extension Array: LXSwiftCompatible { }

extension LXSwiftBasics where Base == Array<Any> {
   
   /// 数组转成json
   public func toJson() -> String {
        if (!JSONSerialization.isValidJSONObject(self)) {
            print("无法解析出JSONString")
            return ""
        }
        
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) as NSData else {
            return ""
        }
        
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        
        return JSONString! as String
    }
}
