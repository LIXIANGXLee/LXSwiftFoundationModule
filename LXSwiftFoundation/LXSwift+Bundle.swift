//
//  LXSwift+Bundle.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

extension Bundle: LXSwiftCompatible { }

//MARK: -  Extending methods  for Bundle
extension LXSwiftBasics where Base: Bundle {
    
    ///Get namespace
    public static var namespace: String? {
        return Bundle.main.infoDictionary?["CFBundleExecutable"] as? String
    }
    
    /// progect name
    public static var bundleName: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
    }
    
    /// bundleID
    public static var bundleID: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String
    }
    
    /// app version 版本号 - 应用程序的版本号标识
    public static var bundleVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    /// build version
    public static var buildVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
    
    /// AppName - APP装到手机里之后显示的名称
    static var displayName: String? {
        return Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as? String
    }
    
    ///获取icon图标
    public static var appIcon: UIImage? {
        guard let lastIcon = appIconStrs?.last else { return nil }
        return UIImage(named: lastIcon)
    }
    
    ///获取icon string 集合
    public static var appIconStrs: [String]? {
        guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? [String] else {
            return nil
        }
        return iconFiles
    }
}
