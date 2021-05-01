//
//  LXSwift+Dictionary.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

extension Dictionary: LXSwiftCompatible { }

/// overload operators +
/// dic + dic
///
/// - Parameters:
///   - left: dic
///   - right: dic
public func + (left: [String: Any],
               right: [String: Any]) -> [String: Any] {
        var dic = left
        for (k, v) in right { dic[k] = v }
        return dic
}

/// overload operators -
///
/// - Parameters:
///   - left: dic
///   - right: dic
public func - (left: [String: Any],
               right: [String: Any]) -> [String: Any] {
        var dic = left
        for (k, _) in right where dic.keys.contains(k) {
            dic.removeValue(forKey: k)
        }
        return dic
}

//MARK: -  Extending properties for Date
extension LXSwiftBasics where Base == Dictionary<String, Any> {
    
    /// Dictionary to json String
    public var jsonStringEncode: String? {
        guard JSONSerialization.isValidJSONObject(base) else {
            return nil
        }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self,
                                                         options: .init(rawValue: 0)),
            let json = String(data: jsonData, encoding: .utf8) else {
                return nil
        }
        return json
    }
    
    /// Dictionary to json string
    public var jsonPrettyStringEncoded: String? {
        guard JSONSerialization.isValidJSONObject(base) else {
            return nil
        }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self,
                                                         options: .prettyPrinted),
            let json = String(data: jsonData, encoding: .utf8) else {
                return nil
        }
        return json
    }
}

//MARK: -  Extending methods for Date
extension LXSwiftBasics where Base == Dictionary<String, Any> {
    
    ///  dic to plist data type
    public var plistData: Data? {
        return try? PropertyListSerialization.data(fromPropertyList: self,
                                                   format: .xml,
                                                   options: 0)
    }
    
    /// dic to plist string type
    public var plistString: String {
        return plistData?.lx.utf8String ?? ""
    }
}
