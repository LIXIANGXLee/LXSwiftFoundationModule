//
//  LXSwift+Double.swift
//  LXSwiftFoundation
//
//  Created by XL on 2017/9/24.
//  Copyright © 2017 李响. All rights reserved.
//

import UIKit

public prefix func ~>  (_ index: CGFloat) -> (CGFloat) -> (Bool) { { $0 >  index } }
public prefix func ~>= (_ index: CGFloat) -> (CGFloat) -> (Bool) { { $0 >= index } }
public prefix func ~<  (_ index: CGFloat) -> (CGFloat) -> (Bool) { { $0 <  index } }
public prefix func ~<= (_ index: CGFloat) -> (CGFloat) -> (Bool) { { $0 <= index } }

public prefix func ~>  (_ index: Double) -> (Double) -> (Bool) { { $0 >  index } }
public prefix func ~>= (_ index: Double) -> (Double) -> (Bool) { { $0 >= index } }
public prefix func ~<  (_ index: Double) -> (Double) -> (Bool) { { $0 <  index } }
public prefix func ~<= (_ index: Double) -> (Double) -> (Bool) { { $0 <= index } }

extension CGFloat: LXSwiftCompatible {
 
    /// Switch 匹配模式
    public static func ~= (pattern: (CGFloat) -> (Bool), value: CGFloat) -> Bool {
         pattern(value)
    }
}

extension Double: LXSwiftCompatible {
    
    /// Switch 匹配模式
    public static func ~= (pattern: (Double) -> (Bool), value: Double) -> Bool {
         pattern(value)
    }
}

//MARK: -  Extending methods for CGFloat
extension LXSwiftBasics where Base == CGFloat {
    
    ///CGFloat转Double
    public var toDouble: Double { Double(base) }
    
    /// 用户显示容量 (GB、MB、KB、B)
    @available(*, deprecated, renamed: "sizeFileToString")
    public var sizeFileToStr: String { sizeFileToString }
    
    /// 用户显示容量 (GB、MB、KB、B)
    public var sizeFileToString: String { base.lx.toDouble.lx.sizeFileToString }
    
    /// 时间字符串
    @available(*, deprecated, renamed: "timeToString")
    public var timeToStr: String { timeToString }
    
    /// 时间字符串
    public var timeToString: String { base.lx.toDouble.lx.timeToString }
}

//MARK: -  Extending methods for Double
extension LXSwiftBasics where Base == Double {
    
    /// 保留小数点后的小数位
    public func roundTo(minDigits: Int = 0, maxDigits: Int = 2, mode: NumberFormatter.RoundingMode = .halfEven) -> String { NSNumber(value: base).lx.numberFormatter(with: mode, minDigits: minDigits, maxDigits: maxDigits) ?? "" }
    
    /// 保留小数点后的小数位
    public func roundTo(digits: Int = 0, mode: NumberFormatter.RoundingMode = .halfEven) -> String { NSNumber(value: base).lx.numberFormatter(with: mode, minDigits: digits, maxDigits: digits) ?? "" }
    
    /// 转换小写数字为大写数字 1 到 壹，2 到 贰 长度要小于19个，否则会crash闪退
    public var convertToUppercaseNumbers: String? {
       return LXSwiftUtils.convert(toUppercaseNumbers: base)
    }
    
    /// 用户显示容量 (GB、MB、KB、B)
    @available(*, deprecated, renamed: "sizeFileToString")
    public var sizeFileToStr: String { sizeFileToString }
    
    /// 用户显示容量 (GB、MB、KB、B)
    public var sizeFileToString: String {
        let unit = 1000.0
        if base > pow(unit, 3) {
            return String(format: "%.2fGB", base / pow(unit, 3))
        } else if base > pow(unit, 2) {
            return String(format: "%.2fMB", base / pow(unit, 2))
        } else if base > pow(unit, 1) {
            return String(format: "%.2fKB", base / pow(unit, 1))
        } else {
            return String(format: "%dB", Int(base))
        }
    }
    
    /// 时间字符串
    @available(*, deprecated, renamed: "timeToString")
    public var timeToStr: String { timeToString }
    
    /// 时间字符串
    public var timeToString: String {
        let dur = Int(round(base))
        switch dur {
        case ~>=3600:
            let h = dur / 3600
            let m = (dur % 3600) / 60
            let s = dur % 60
            return String(format: "%02d:%02d:%02d", h, m, s)
        case ~>=60:
            let m = dur / 60
            let s = dur % 60
            return String(format: "00:%02d:%02d", m, s)
        case ~>=0:
            return String(format: "00:00:%02d", dur)
        default:
            return "00:00:00"
        }
    }
}
