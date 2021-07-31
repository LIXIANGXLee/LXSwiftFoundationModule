//
//  LXSwift+Double.swift
//  LXSwiftFoundation
//
//  Created by XL on 2017/9/24.
//  Copyright © 2017 李响. All rights reserved.
//

import UIKit

extension Double: LXSwiftCompatible { }

//MARK: -  Extending methods for Double
extension LXSwiftBasics where Base == Double {
    
    /// 保留小数点后的小数位
    public func roundTo(minDigits: Int = 0, maxDigits: Int = 2,
                        mode: NumberFormatter.RoundingMode = .halfEven) -> String {
        return NSNumber(value: base).lx.numberFormatter(with: mode,
                                                        minDigits: minDigits,
                                                        maxDigits: maxDigits) ?? ""
    }
    
    /// 保留小数点后的小数位
    public func roundTo(digits: Int = 0,
                        mode: NumberFormatter.RoundingMode = .halfEven) -> String {
        return NSNumber(value: base).lx.numberFormatter(with: mode,
                                                        minDigits: digits,
                                                        maxDigits: digits) ?? ""
    }
    
    /// 取余两位
    public var leaveTwoFormat: String {
        let num = base
        let numberFormatter1 = NumberFormatter()
        numberFormatter1.positiveFormat = "###,##0.00"
        var str = String()
        str = numberFormatter1.string(from: NSNumber(value: num as Double))!
        return str
    }
    
    /// 百分比显示 乘100
    public var hundredPercentFormat: String {
        let num = base * 100
        let numberFormatter1 = NumberFormatter()
        numberFormatter1.positiveFormat = "###,##0.00"
        var str = String()
        str = numberFormatter1.string(from: NSNumber(value: num as Double))!
        return str+"%"
    }
    
    /// 用户显示容量 (G、M、KB)
    public var sizeFileToStr: String {
        let unit = 1000.0
        if base > pow(unit, 3) {
            return String(format: "%.2fG", base / pow(unit, 3))
        } else if base > pow(unit, 2) {
            return String(format: "%.2fM", base / pow(unit, 2))
        } else if base > pow(unit, 1) {
            return String(format: "%.2fKB", base / pow(unit, 1))
        } else {
            return String(format: "%dB", 0)
        }
    }
    
    /// 时间字符串
    public var timeToStr: String {
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
