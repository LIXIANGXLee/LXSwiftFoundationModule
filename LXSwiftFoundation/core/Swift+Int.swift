//
//  Swift+Int.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2017/9/25.
//  Copyright © 2017 李响. All rights reserved.
//

import UIKit

/// 自定义运算符
prefix operator ~~~>  /// 大于
prefix operator ~~~<  /// 小于
prefix operator ~~~>= /// 大于等于
prefix operator ~~~<= /// 小于等于

public prefix func ~~~>  (_ index: Int32) -> (Int32) -> (Bool) { { $0 >  index } }
public prefix func ~~~>= (_ index: Int32) -> (Int32) -> (Bool) { { $0 >= index } }
public prefix func ~~~<  (_ index: Int32) -> (Int32) -> (Bool) { { $0 <  index } }
public prefix func ~~~<= (_ index: Int32) -> (Int32) -> (Bool) { { $0 <= index } }

public prefix func ~~~>  (_ index: Int64) -> (Int64) -> (Bool) { { $0 >  index } }
public prefix func ~~~>= (_ index: Int64) -> (Int64) -> (Bool) { { $0 >= index } }
public prefix func ~~~<  (_ index: Int64) -> (Int64) -> (Bool) { { $0 <  index } }
public prefix func ~~~<= (_ index: Int64) -> (Int64) -> (Bool) { { $0 <= index } }

public prefix func ~~~>  (_ index: Int) -> (Int) -> (Bool) { { $0 >  index } }
public prefix func ~~~>= (_ index: Int) -> (Int) -> (Bool) { { $0 >= index } }
public prefix func ~~~<  (_ index: Int) -> (Int) -> (Bool) { { $0 <  index } }
public prefix func ~~~<= (_ index: Int) -> (Int) -> (Bool) { { $0 <= index } }

extension Int {
    public static func ~= (pattern: (Int) -> (Bool), value: Int) -> Bool {
        pattern(value)
    }
}
//MARK: -  Extending methods for Int
extension SwiftBasics where Base == Int {
    /// int转bool
    public var toBool: Bool { base > 0 ? true : false }
   
    /// 生成区间的随机数
    public static func randomInt(lower: Int = 0, upper: Int = Int(UInt32.max)) -> Int {
        lower + Int(arc4random_uniform(UInt32(upper - lower)))
    }
    
    /// 生成区间的随机数
    public static func randomInt(with range: Range<Int>) -> Int {
        randomInt(lower: range.lowerBound, upper: range.upperBound)
    }
    
    /// 用户显示容量 (GB、MB、KB、B)
    @available(*, deprecated, renamed: "sizeFileToString")
    public var sizeFileToStr: String { sizeFileToString }
    
    /// 用户显示容量 (GB、MB、KB、B)
    public var sizeFileToString: String { Double(base).lx.sizeFileToString }
    
    /// 时间（秒数）转换字符串
    @available(*, deprecated, renamed: "timeToString")
    public var timeToStr: String { timeToString }
    
    /// 时间（秒数）转换字符串
    public var timeToString: String { Double(base).lx.timeToString }
    
    ///  时间戳转时间字符串 base: 时间戳（单位：s） ymd: 转换手的字符串格式， 转换后得到的字符串
    public func timeStampToString(with ymd: String = "yyyy-MM-dd HH:mm:ss") -> String {
        base.lx.timeStampToDate().lx.dateTranformString(with: ymd)
    }
    
    ///  时间戳转时间字符串 base: 时间戳（单位：s） ymd: 转换手的字符串格式， 转换后得到的字符串
    public func timeStampToDate() -> Date {
        Date(timeIntervalSince1970: TimeInterval(base))
    }
    
    /**
     特备注意：传进来的时间戳base的单位是秒
     60秒内：刚刚
     1-60分钟 ：5分钟前
     60以上 - 今天0点之后：几小时以前，
     前1-7日前，在今年内：X天前
     7日前-今年1.1：XX-XX XX:XX
     去年及以前：20XX-XX-XX XX:XX
     */
    public var timeDateDescription: String {
        let current = Date().lx.timeInterval
        let timeDiff = Int(current) - base
        switch timeDiff {
        case ~~~<60:
            return "刚刚"
        case ~~~<3600:
            return "\(timeDiff / 60)分钟前"
        case ~~~<(24 * 3600):
            return "\(timeDiff / 3600)小时前"
        default:
            let days = timeDiff / (24 * 3600)
            if days > 7 {
                let date = base.lx.timeStampToDate()
                if date.lx.isThisYear {
                    return date.lx.dateTranformString(with: "MM月dd日 HH:mm")
                } else {
                    return date.lx.dateTranformString(with: "yyyy年MM月dd日 HH:mm")
                }
            }
            return "\(days)天前"
        }
    }
}
