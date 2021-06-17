//
//  LXSwiftUtil.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/9/25.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

public struct LXSwiftUtils: LXSwiftCompatible {
    
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
extension LXSwiftUtils.VersionCompareResult {
    fileprivate init(rawValue: Int32) {
        switch rawValue {
        case 0: self = .equal
        case Int32.min ... -1: self = .small
        case 1 ... Int32.max: self = .big
        default: self = .equal
        }
    }
}

//MARK: -  Extending methods for LXSwiftUtils
extension LXSwiftBasics where Base == LXSwiftUtils {
    
    /// one version campare two version
    ///
    /// - Parameters:
    ///   - v1: one version
    ///   - v2: two version
    /// - Returns: big: one > two  ,small:two  < one,equal:one == two
    public static func versionCompare(v1: String,
                                      v2: String)
    -> LXSwiftUtils.VersionCompareResult {
        let ret = _compareVersionInSwift(v1, v2)
        return LXSwiftUtils.VersionCompareResult(rawValue: ret)
    }
    
    /// one version campare two version
    ///
    /// - Parameters:
    ///   - v1: one version
    ///   - v2: two version
    /// - Returns: big: one > two  ,small:two  < one,equal:one == two
    public static func versionCompare(_ v1: String,
                                      _ v2: String)
    -> LXSwiftUtils.VersionCompareResult {

        let com = v1.compare(v2)
        var temp: LXSwiftUtils.VersionCompareResult
        switch com {
        case .orderedSame:
            temp = LXSwiftUtils.VersionCompareResult.equal
        case .orderedAscending:
            temp = LXSwiftUtils.VersionCompareResult.small
        case .orderedDescending:
            temp = LXSwiftUtils.VersionCompareResult.big
        default:
            temp = LXSwiftUtils.VersionCompareResult.small
        }
        return temp
    }
    
    /// call tel for all app
    public static func openTel(with number: String?,
                               _ tellCallBack: LXSwiftUtils.TellCallBack? = nil) {
        if let number = number,
            let url = URL(string: "tel:" + number) {
            if UIApplication.lx.isCanOpen(url) {
                UIApplication.lx.openUrl(url)
            }
        }
    }
    
    /// Keep a few significant digits after the decimal point
    ///
    /// - Parameters:
    ///   - text: text string
    ///   - digits: digits Number of significant digits reserved
    ///   - mode: mode
    /// - Returns: string
    public static func formatDecimalString(with text: String,
                                           _ digits: Int,
                                           _ mode: NumberFormatter.RoundingMode = .down)
    -> String {
        guard let m = Double(text) else { return text }
        return NSNumber(value: m).numberFormatter(with: .down,
                                                  minDigits: digits,
                                                  maxDigits: digits) ?? text
    }

    ///Keep two valid digits after the decimal point.
    public static func formatDecimalStringTwo(with text: String) -> String {
       return formatDecimalString(with: text, 2)
    }
    
    ///Keep three  valid digits after the decimal point.
    public static func formatDecimalStringThree(with text: String) -> String {
       return formatDecimalString(with: text, 3)
    }
    
    ///Keep Four valid digits after the decimal point.
    public static func formatDecimalStringFour(with text: String) -> String {
       return formatDecimalString(with: text, 4)
    }
    
}

