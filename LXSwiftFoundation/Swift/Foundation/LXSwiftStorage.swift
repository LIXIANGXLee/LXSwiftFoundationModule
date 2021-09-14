//
//  LXSwiftStorage.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/2/8.
//

import UIKit

/// LXUserDefaultsProtocol 协议
public protocol LXUserDefaultsProtocol  {
    
    /// key的唯一表示
    var uniqueKey: String { get }
}

/// 限定为String类型 赋值uniqueKey为命名空间 + value为新传进来的值 防止key值重复
public extension LXUserDefaultsProtocol where Self: RawRepresentable, Self.RawValue == String {
    
    /// 重写唯一key
    var uniqueKey: String {
        let namespace = Bundle.lx.namespace ?? Bundle.lx.bundleID ?? "lx"
        return namespace + "." + "\(rawValue)"
    }
}

/*
 举个例子：
 可以定一个枚举，当作参数key存储
 enum UserDefaultKeys: String, LXUserDefaultsProtocol {
     case key
 }
*/
private let defaultStandard = UserDefaults.standard
public struct LXSwiftStorage: LXSwiftCompatible {
   
    /// 遵守协议，处理唯一标识存储
    private static let defaultStandard = UserDefaults.standard
    public static subscript(key: LXUserDefaultsProtocol) -> Any? {
        set { set(with: newValue, key: key.uniqueKey) }
        get { get(for: key.uniqueKey) }
    }
    
    /// 基本存储
    public static func set(with value: Any?, key: String) {
        defaultStandard.set(value, forKey: key)
        defaultStandard.synchronize()
    }
    
    /// 基本取值
    public static func get(for key: String) -> Any? { defaultStandard.object(forKey: key) }
}

/// 扩展存储 并且加密
extension LXSwiftBasics where Base == LXSwiftStorage {

    /// 基本存储
    public static func set(with value: Any?, key: String) { Base.set(with: value, key: key) }
    
    /// 基本取值
    public static func get(for key: String) -> Any? { Base.get(for: key) }
    
}
