//
//  LXSwiftUtil.swift
//  LXSwiftFoundationModule
//
//  Created by Mac on 2020/9/25.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

public struct LXSwiftUtil: LXSwiftCompatible {
    
    /// 版本号大小的枚举
     public enum VersionCompareResult {
         case big
         case equal
         case small
     }
}

/// 版本号大小的初始化方法
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

//MARK: -  Extending methods for LXSwiftTool
extension LXSwiftBasics where Base == LXSwiftUtil {
 
   /// 比较版本号大小
   ///
   /// - Parameters:
   ///   - v1: 第一个版本号
   ///   - v2: 第二个版本号
   /// - Returns: big:第一个大,small:第二个大,equal:两个相等
   public static func versionCompare(v1: String, v2: String) -> LXSwiftUtil.VersionCompareResult {
       let ret = _compareVersion(v1, v2)
       return LXSwiftUtil.VersionCompareResult(rawValue: ret)
   }
}


