//
//  Swift+Dictionary.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

//MARK: -  Extending properties for Date
extension SwiftBasics where Base == Dictionary<String, Any> {
    
    /// 字典到json字符串
    public var toJsonString: String? {
        guard JSONSerialization.isValidJSONObject(base) else {
            return nil
        }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: base, options: []) else {
            return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }

    /// 字典到json字符串
    public var toPrettyString: String? {
        guard JSONSerialization.isValidJSONObject(base) else {
            return nil
        }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: base, options: .prettyPrinted) else {
            return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }
}

//MARK: -  Extending methods for Date
extension SwiftBasics where Base == Dictionary<String, Any> {
    
    /// dic到plist数据类型
    public var toPlistData: Data? {
        try? PropertyListSerialization.data(fromPropertyList: base, format: .xml, options: 0)
    }
    
    /// plist 字典到字符串类型
    public var toPlistString: String {
        toPlistData?.lx.utf8String ?? ""
    }
}
