//
//  SwiftStorage.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/2/8.
//

/*   1. 定义存储键枚举
     enum AppSettings: String, SwiftUserDefaultsProtocol {
         case userToken
         case darkModeEnabled
     }

     // 2. 安全存储（自动添加命名空间）
     SwiftUserDefaults[AppSettings.userToken] = "a1b2c3d4"

     // 3. 安全读取
     let token = SwiftUserDefaults[AppSettings.userToken] as? String

     // 4. 原始键存储（不推荐）
     SwiftUserDefaults.lx.set(with: true, key: "global_notifications")
 */

import UIKit

/// 用户默认值存储协议
/// 要求实现对象必须提供唯一键标识符
public protocol SwiftUserDefaultsProtocol {
    
    /// 唯一键标识符（用于避免键名冲突）
    var uniqueKey: String { get }
}

/// 协议扩展：为RawRepresentable且原始值为String的类型提供默认实现
public extension SwiftUserDefaultsProtocol where Self: RawRepresentable, Self.RawValue == String {
    
    /// 计算属性：生成带命名空间的唯一键
    /// 格式：[命名空间].[原始值]
    var uniqueKey: String {
        // 获取命名空间（优先使用自定义命名空间，次选BundleID）
        let namespace = Bundle.lx.namespace ?? Bundle.lx.bundleID ?? "lx"
        // 组合成唯一键
        return namespace + "." + "\(rawValue)"
    }
}

/*
 使用示例：
 enum UserDefaultKeys: String, LXUserDefaultsProtocol {
     case userName    // 使用时自动转换为"com.yourapp.userName"
     case lastLogin
 }
*/

/// SwiftUserDefaults核心结构体
public struct SwiftUserDefaults: SwiftCompatible {
    
    /// 标准UserDefaults实例
    private static let defaultStandard = UserDefaults.standard
    
    /// 下标访问器（使用协议约束的键）
    /// - 设置值：当newValue为nil时相当于删除该键
    /// - 获取值：键不存在时返回nil
    public static subscript(key: SwiftUserDefaultsProtocol) -> Any? {
        set {
            // 通过协议对象获取唯一键并进行存储
            set(with: newValue, key: key.uniqueKey)
        }
        get {
            // 通过协议对象获取唯一键并读取值
            get(for: key.uniqueKey)
        }
    }
    
    /// 基础存储方法（使用原始字符串键）
    /// - Parameters:
    ///   - value: 要存储的值（支持可序列化类型，nil表示删除键）
    ///   - key: 原始字符串键
    public static func set(with value: Any?, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()  // 确保立即写入
    }
    
    /// 基础取值方法
    /// - Parameter key: 原始字符串键
    /// - Returns: 存储的值（键不存在时返回nil）
    public static func get(for key: String) -> Any? {
        UserDefaults.standard.object(forKey: key)
    }
}

/// SwiftBasics扩展：为SwiftUserDefaults添加语法糖
extension SwiftBasics where Base == SwiftUserDefaults {
    
    /// 存储方法（内联优化版）
    /// - Parameters:
    ///   - value: 要存储的值
    ///   - key: 原始字符串键
    public static func set(with value: Any?, key: String) {
        SwiftUserDefaults.set(with: value, key: key)
    }
    
    /// 取值方法（内联优化版）
    /// - Parameter key: 原始字符串键
    /// - Returns: 存储的值
    public static func get(for key: String) -> Any? {
        SwiftUserDefaults.get(for: key)
    }
}
