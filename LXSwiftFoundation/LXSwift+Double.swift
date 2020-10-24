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
    public func roundTo(minDigits: Int = 0, maxDigits: Int = 2) -> String {
        return NSNumber(value: base).lx.numberFormatter(with: .halfEven, minDigits: minDigits, maxDigits: maxDigits) ?? ""
    }
    
    /// Keep decimal places after decimal points
    /// - Parameters:
    ///   - digits:  min decimal max decimal is  digits
    public func roundTo(digits: Int = 0) -> String {
        return NSNumber(value: base).lx.numberFormatter(with: .halfEven, minDigits: digits, maxDigits: digits) ?? ""
    }

    
}
