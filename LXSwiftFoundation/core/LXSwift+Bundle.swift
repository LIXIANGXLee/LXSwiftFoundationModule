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

    /// 项目名字
    public static var bundleName: String? { Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String }
    
    /// 获取APP装到手机里之后显示的名称
    static var bundleDisplayName: String? { Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as? String }
    
    /// bundleID 唯一标识
    public static var bundleID: String? { Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String }
    
    /// app version 版本号 - 应用程序的版本号标识
    public static var bundleVersion: String? { Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String }
    
    /// build 版本号
    public static var buildVersion: String? { Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String }
    
    /// 获取命名空间
    public static var namespace: String? { Bundle.main.infoDictionary?["CFBundleExecutable"] as? String }
    
    /// 获取icon图标
    public static var appIcon: UIImage? {
        guard let lastIcon = appIconStrs?.last else { return nil }
        return UIImage(named: lastIcon)
    }
    
    /// 获取icon string 集合
    public static var appIconStrs: [String]? {
        guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any], let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? [String: Any], let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? [String] else { return nil }
        return iconFiles
    }
}
