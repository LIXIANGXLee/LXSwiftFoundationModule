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
        
        // 预计算各容量单位阈值（避免重复计算 pow 函数）
        let GBThreshold = pow(unit, 3)       // 1 GB = 1000^3 字节
        let MBThreshold = pow(unit, 2)       // 1 MB = 1000^2 字节
        let KBThreshold = unit               // 1 KB = 1000 字节

        switch base {
        case ~~~>=GBThreshold:
            // 大于等于 1GB 时转换为 GB 单位
           return String(format: "%.2fGB", base / GBThreshold)
        case ~~~>=MBThreshold:
            // 大于等于 1MB 时转换为 MB 单位
            return String(format: "%.2fMB", base / MBThreshold)
        case ~~~>=KBThreshold:
            // 大于等于 1KB 时转换为 KB 单位
            return String(format: "%.2fKB", base / KBThreshold)
        default:
            // 不足 1KB 时直接显示字节数
            return String(format: "%dB", Int(base))
        }

    }
    
    /// 时间字符串
    @available(*, deprecated, renamed: "timeToString")
    public var timeToStr: String { timeToString }
    
    /// 时间字符串
    public var timeToString: String {
        // 总秒数（四舍五入取整）
        let dur = Int(round(base))
        switch dur {
            // 超过1小时：显示时:分:秒
        case ~~~>=3600:
            let h = dur / 3600
            let m = (dur % 3600) / 60
            let s = dur % 60
            return String(format: "%02d:%02d:%02d", h, m, s)
            // 超过1分钟：显示分:秒（小时位补零）
        case ~~~>=60:
            let m = dur / 60
            let s = dur % 60
            return String(format: "00:%02d:%02d", m, s)
            // 正数秒数：仅显示秒（小时/分钟位补零）
        case ~~~>=0:
            return String(format: "00:00:%02d", dur)
            // 负数或异常值：返回默认时间
        default:
            return "00:00:00"
        }
    }
}
