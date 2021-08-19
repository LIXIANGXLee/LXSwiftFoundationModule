//
//  LXSwift+Int.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2017/9/25.
//  Copyright © 2017 李响. All rights reserved.
//

import UIKit


/// 自定义运算符
prefix operator ~>  /// 大于
prefix operator ~<  /// 小于
prefix operator ~>= /// 大于等于
prefix operator ~<= /// 小于等于

public prefix func ~>  (_ index: Int) -> (Int) -> (Bool) { { $0 >  index } }
public prefix func ~>= (_ index: Int) -> (Int) -> (Bool) { { $0 >= index } }
public prefix func ~<  (_ index: Int) -> (Int) -> (Bool) { { $0 <  index } }
public prefix func ~<= (_ index: Int) -> (Int) -> (Bool) { { $0 <= index } }

extension Int: LXSwiftCompatible {
    
    /// Switch 匹配模式
    public static func ~= (pattern: (Int) -> (Bool), value: Int) -> Bool {
         pattern(value)
    }
}

//MARK: -  Extending methods for Int
extension LXSwiftBasics where Base == Int {
    
    /// 生成区间的随机数
    public static func randomInt(lower: Int = 0, upper: Int = Int(UInt32.max)) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower)))
    }
    
    /// 生成区间的随机数
    public static func randomInt(with range: Range<Int>) -> Int {
        return randomInt(lower: range.lowerBound, upper: range.upperBound)
    }
    
    /// 转换为字符串格式
    public var toString: String {
        return String(base)
    }
    
    /// int转bool
    public var toBool: Bool {
        return base > 0 ? true : false
    }
    
    /// int转Int64
    public var toInt64: Int64 {
        return Int64(base)
    }
    
    /// 用户显示容量 (GB、MB、KB、B)
    public var sizeFileToStr: String {
       return Double(base).lx.sizeFileToStr
    }
    
    /// 时间（秒数）转换字符串
    public var timeToStr: String {
        return Double(base).lx.timeToStr
    }
    
    ///  时间戳转时间字符串 base: 时间戳（单位：s） ymd: 转换手的字符串格式， 转换后得到的字符串
    public func timeStampToString(with ymd: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let date = base.lx.timeStampToDate()
        return date.lx.dateTranformString(with: ymd)
    }
    
    ///  时间戳转时间字符串 base: 时间戳（单位：s） ymd: 转换手的字符串格式， 转换后得到的字符串
    public func timeStampToDate() -> Date {
        let timeInterval = TimeInterval(base)
        return Date(timeIntervalSince1970: timeInterval)
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
        case ~<60:
            return "刚刚"
        case ~<3600:
            return "\(timeDiff / 60)分钟前"
        case ~<(24 * 3600):
            return "\(timeDiff / 3600)小时前"
        default:
            let days = timeDiff / (24 * 3600)
            if days > 7 {
                let date = base.lx.timeStampToDate()
                if date.lx.isThisYear {
                    return date.lx.dateTranformString(with: "MM月dd日 HH:mm")
                }else{
                    return date.lx.dateTranformString(with: "yyyy年MM月dd日 HH:mm")
                }
            }else{
                return "\(days)天前"
            }
        }
    }
}
