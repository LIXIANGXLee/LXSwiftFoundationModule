//
//  LXSwift+Dictionary.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

extension Dictionary: LXSwiftCompatible { }

/// 两个字典相加 +
public func + (left: [String: Any], right: [String: Any]) -> [String: Any] {
        var dic = left
        for (k, v) in right { dic[k] = v }
        return dic
}

/// 两个字典相减 -
public func - (left: [String: Any], right: [String: Any]) -> [String: Any] {
        var dic = left
        for (k, _) in right where dic.keys.contains(k) {
            dic.removeValue(forKey: k)
        }
        return dic
}

//MARK: -  Extending properties for Date
extension LXSwiftBasics where Base == Dictionary<String, Any> {
    
    /// 字典到json字符串
    public var dicToJsonStr: String? {
        guard JSONSerialization.isValidJSONObject(base) else { return nil }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: base, options: []), let json = String(data: jsonData, encoding: .utf8) else { return nil }
        return json
    }

    /// 字典到json字符串
    public var dicToPrettyStr: String? {
        guard JSONSerialization.isValidJSONObject(base) else { return nil }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: base, options: .prettyPrinted), let json = String(data: jsonData, encoding: .utf8) else { return nil }
        return json
    }
}

//MARK: -  Extending methods for Date
extension LXSwiftBasics where Base == Dictionary<String, Any> {
    
    /// dic到plist数据类型
    public var plistData: Data? {
        return try? PropertyListSerialization.data(fromPropertyList: base, format: .xml, options: 0)
    }
    
    /// plist 字典到字符串类型
    public var plistString: String {
        return plistData?.lx.utf8String ?? ""
    }
}
