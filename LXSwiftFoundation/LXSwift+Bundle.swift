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
    public static var namespace: String {
        guard let namespace =  Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else { return "" }
        return  namespace
    }
    
    /// progect name
    public static var bundleName: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
    }
    
    /// bundleID
    public static var bundleID: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String
    }
    
    /// app version
    public static var bundleVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    /// build version
    public static var buildVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
}
