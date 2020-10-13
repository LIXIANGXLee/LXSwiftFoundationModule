//
//  LXSwiftUtil.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/9/25.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

public struct LXSwiftUtil: LXSwiftCompatible {
    
    /// callBack after  call tell
    public typealias TellCallBack = ((Bool) -> ())
    
    /// version enum
    public enum VersionCompareResult {
        case big
        case equal
        case small
    }
}

/// version  init
extension LXSwiftUtil.VersionCompareResult {
    fileprivate init(rawValue: Int32) {
        switch rawValue {
        case 0: self = .equal
        case Int32.min ... -1: self = .small
        case 1 ... Int32.max: self = .big
        default: self = .equal
        }
    }
}

//MARK: -  Extending methods for LXSwiftUtil
extension LXSwiftBasics where Base == LXSwiftUtil {
    
    /// one version campare two version
    ///
    /// - Parameters:
    ///   - v1: one version
    ///   - v2: two version
    /// - Returns: big: one > two  ,small:two  < one,equal:one == two
    public static func versionCompare(v1: String, v2: String) -> LXSwiftUtil.VersionCompareResult {
        let ret = _compareVersionInSwift(v1, v2)
        return LXSwiftUtil.VersionCompareResult(rawValue: ret)
    }
    
    /// call tel for all app
    public static func openTel(with number: String?, _ tellCallBack: LXSwiftUtil.TellCallBack? = nil) {
        guard let number = number,
            let url = URL(string: "tel:" + number) else{ return }
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: tellCallBack)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}


