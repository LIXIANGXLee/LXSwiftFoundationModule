//
//  Swift+Bundle.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// 应用包信息管理器
extension SwiftBasics where Base: Bundle {
    // MARK: - 基础信息
    
    /// 应用包名称（取自 Info.plist 的 CFBundleName）
    /// - 注意：此名称通常用于系统内部标识，非用户可见名称
    public static var bundleName: String? {
        getInfoDictionaryValue(forKey: "CFBundleName")
    }
    
    /// 应用显示名称（取自本地化信息字典的 CFBundleDisplayName）
    /// - 注意：此名称为用户在Springboard看到的应用名称，支持本地化
    public static var bundleDisplayName: String? {
        Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as? String
    }
    
    /// 应用唯一标识（Bundle Identifier）
    /// - 示例："com.company.AppName"
    public static var bundleID: String? {
        getInfoDictionaryValue(forKey: "CFBundleIdentifier")
    }
    
    // MARK: - 版本信息
    
    /// 应用市场版本号（短版本号，格式：x.x.x）
    /// - 取自：CFBundleShortVersionString
    public static var bundleVersion: String? {
        getInfoDictionaryValue(forKey: "CFBundleShortVersionString")
    }
    
    /// 构建版本号（持续集成版本号）
    /// - 取自：CFBundleVersion
    public static var buildVersion: String? {
        getInfoDictionaryValue(forKey: "CFBundleVersion")
    }
    
    // MARK: - 运行环境信息
    
    /// 可执行文件命名空间（通常用于反射操作）
    /// - 示例："YourApp_Executable"
    public static var namespace: String? {
        Bundle.main.infoDictionary?["CFBundleExecutable"] as? String
    }
    
    // MARK: - 图标资源
    
    /// 应用主图标（自动选择当前分辨率最合适的图标）
    /// - 返回：UIImage对象，如果获取失败返回nil
    public static var appIcon: UIImage? {
        guard let iconName = appIconNames?.last else { return nil }
        return UIImage(named: iconName)
    }
    
    /// 应用图标资源名称集合（按分辨率升序排列）
    /// - 格式：["Icon-20", "Icon-20@2x", "Icon-20@3x"]
    public static var appIconNames: [String]? {
        guard let icons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String] else {
            SwiftLog.log("⚠️ 图标配置信息缺失，请检查CFBundleIcons配置")
            return nil
        }
        return iconFiles
    }
    
    // MARK: - 私有方法
    
    /// 通用信息字典取值方法
    /// - Parameter key: Info.plist 字段键
    /// - Returns: 泛型返回值，自动进行类型转换
    private static func getInfoDictionaryValue<T>(forKey key: String) -> T? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? T else {
            SwiftLog.log("⚠️ 无法获取 \(key) 或类型不匹配")
            return nil
        }
        return value
    }
}
