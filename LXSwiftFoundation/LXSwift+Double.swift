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
    public func leaveTwoFormatWith() -> String {
        let num = base
        let numberFormatter1 = NumberFormatter()
        numberFormatter1.positiveFormat = "###,##0.00"
        var str = String()
        str = numberFormatter1.string(from: NSNumber(value: num as Double))!
        return str
    }
    
    /// 百分比显示 乘100
    public func hundredPercentFormat() -> String {
        let num = base * 100
        let numberFormatter1 = NumberFormatter()
        numberFormatter1.positiveFormat = "###,##0.00"
        var str = String()
        str = numberFormatter1.string(from: NSNumber(value: num as Double))!
        return str+"%"
    }
    
    /// User display capacity size size
    public func sizeToStr() -> String {
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
}
