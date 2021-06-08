//
//  LXSwift+Double.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

extension Double: LXSwiftCompatible { }

//MARK: -  Extending methods for Double
extension LXSwiftBasics where Base == Double {
    
    /// Keep decimal places after decimal points
    /// - Parameters:
    ///   - minDigits: min decimal
    ///   - maxDigits: max decimal
    public func roundTo(minDigits: Int = 0,
                        maxDigits: Int = 2) -> String {
        return NSNumber(value: base).lx.numberFormatter(with: .halfEven,
                                                        minDigits: minDigits,
                                                        maxDigits: maxDigits) ?? ""
    }
    
    /// Keep decimal places after decimal points
    /// - Parameters:
    ///   - digits:  min decimal max decimal is  digits
    public func roundTo(digits: Int = 0) -> String {
        return NSNumber(value: base).lx.numberFormatter(with: .halfEven,
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
    
    /// User display capacity size size
    public var sizeToStr: String {
        let unit = 1000.0
        if base > pow(unit, 3) {
            return String(format: "%.2fGB", base / pow(unit, 3))
        } else if base > pow(unit, 2) {
            return String(format: "%.2fMB", base / pow(unit, 2))
        } else if base > pow(unit, 1) {
            return String(format: "%.2fKB", base / pow(unit, 1))
        } else {
            return String(format: "%dKB", 0)
        }
    }
    
    /// timer string
    public var timeToStr: String {
        let dur = Int(round(base))
        switch dur {
        case 0..<60:
            return String(format: "00:%02d", dur)
        case 60..<3600:
            let m = dur / 60
            let s = dur % 60
            return String(format: "%02d:%02d", m, s)
        case 3600...:
            let h = dur / 3600
            let m = (dur % 3600) / 60
            let s = dur % 60
            return String(format: "%02d:%02d:%02d", h, m, s)
        default:
            return ""
        }
    }
}
