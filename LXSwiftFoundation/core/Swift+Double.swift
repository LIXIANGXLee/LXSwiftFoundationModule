//
//  Swift+Double.swift
//  LXSwiftFoundation
//
//  Created by XL on 2017/9/24.
//  Copyright © 2017 李响. All rights reserved.
//

import UIKit

public prefix func ~~~>  (_ index: CGFloat) -> (CGFloat) -> (Bool) { { $0 >  index } }
public prefix func ~~~>= (_ index: CGFloat) -> (CGFloat) -> (Bool) { { $0 >= index } }
public prefix func ~~~<  (_ index: CGFloat) -> (CGFloat) -> (Bool) { { $0 <  index } }
public prefix func ~~~<= (_ index: CGFloat) -> (CGFloat) -> (Bool) { { $0 <= index } }

public prefix func ~~~>  (_ index: Double) -> (Double) -> (Bool) { { $0 >  index } }
public prefix func ~~~>= (_ index: Double) -> (Double) -> (Bool) { { $0 >= index } }
public prefix func ~~~<  (_ index: Double) -> (Double) -> (Bool) { { $0 <  index } }
public prefix func ~~~<= (_ index: Double) -> (Double) -> (Bool) { { $0 <= index } }

extension CGFloat {
    public static func ~= (pattern: (CGFloat) -> (Bool), value: CGFloat) -> Bool {
        pattern(value)
    }
}

extension Double {
    public static func ~= (pattern: (Double) -> (Bool), value: Double) -> Bool {
        pattern(value)
    }
}

//MARK: -  Extending methods for CGFloat
extension SwiftBasics where Base == CGFloat {
    
    ///CGFloat转Double
    public var toDouble: Double { Double(base) }
    
    /// CGFloat转bool
    public var toBool: Bool { base > 0 ? true : false }
 
    /// 用户显示容量 (GB、MB、KB、B)
    @available(*, deprecated, renamed: "sizeFileToString")
    public var sizeFileToStr: String { sizeFileToString }
    
    /// 用户显示容量 (GB、MB、KB、B)
    public var sizeFileToString: String {
        base.lx.toDouble.lx.sizeFileToString
    }
    
    /// 时间字符串
    @available(*, deprecated, renamed: "timeToString")
    public var timeToStr: String { timeToString }
    
    /// 时间字符串
    public var timeToString: String {
        base.lx.toDouble.lx.timeToString
    }
}

//MARK: -  Extending methods for Double
extension SwiftBasics where Base == Double {
    
    /// Double转bool
    public var toBool: Bool { base > 0 ? true : false }

    /// 保留小数点后的小数位
    public func roundTo(minDigits: Int = 0,
                        maxDigits: Int = 2,
                        mode: NumberFormatter.RoundingMode = .halfEven) -> String? {
        
        let number = NSNumber(value: base);
    
        return number.lx.numberFormatter(with: mode,
                                        minDigits: minDigits,
                                        maxDigits: maxDigits)
    }
    
    /// 用户显示容量 (GB、MB、KB、B)
    @available(*, deprecated, renamed: "sizeFileToString")
    public var sizeFileToStr: String { sizeFileToString }
    
    /// 用户显示容量 (GB、MB、KB、B)
    public var sizeFileToString: String {
        let unit = 1000.0
        
        /// 优化代码判断逻辑

//        if base > pow(unit, 3) {
//            return String(format: "%.2fGB", base / pow(unit, 3))
//        } else if base > pow(unit, 2) {
//            return String(format: "%.2fMB", base / pow(unit, 2))
//        } else if base > pow(unit, 1) {
//            return String(format: "%.2fKB", base / pow(unit, 1))
//        } else {
//            return String(format: "%dB", Int(base))
//        }
        
        switch base {
        case ~~~>pow(unit, 3):
           return String(format: "%.2fGB", base / pow(unit, 3))
        case ~~~>pow(unit, 2):
            return String(format: "%.2fMB", base / pow(unit, 2))
        case ~~~>pow(unit, 1):
            return String(format: "%.2fKB", base / pow(unit, 1))
        default:
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
        case ~~~>=3600:
            let h = dur / 3600
            let m = (dur % 3600) / 60
            let s = dur % 60
            return String(format: "%02d:%02d:%02d", h, m, s)
        case ~~~>=60:
            let m = dur / 60
            let s = dur % 60
            return String(format: "00:%02d:%02d", m, s)
        case ~~~>=0:
            return String(format: "00:00:%02d", dur)
        default:
            return "00:00:00"
        }
    }
}
