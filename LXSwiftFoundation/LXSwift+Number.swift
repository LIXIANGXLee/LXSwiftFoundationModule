//
//  LXSwift+Number.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/9/27.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

extension NSNumber: LXSwiftCompatible { }

//MARK: -  Extending methods for NSNumber
extension LXSwiftBasics where Base: NSNumber {
    
    /// minDigits: How many decimal places should be reserved with  rounding 
    ///maxDigits:Keep a few decimal places
    public  func numberFormatter(with mode: NumberFormatter.RoundingMode = .halfEven, minDigits: Int = 0, maxDigits:Int = 0) -> String? {
        return base.numberFormatter(with: mode, minDigits: minDigits, maxDigits: maxDigits)
    }
    
    ///Keep a two decimal places
    public  func numberFormatter() -> String? {
        return base.numberFormatter(with: .halfEven, minDigits: 0, maxDigits: 2)
    }
}

//MARK: -  Extending internal methods for NSNumber
extension NSNumber {
    
    /// minDigits: How many decimal places should be reserved with  rounding
    ///maxDigits:Keep a few decimal places
    internal func numberFormatter(with mode: NumberFormatter.RoundingMode = .halfEven, minDigits: Int = 0, maxDigits:Int = 0) -> String? {
        let formate = NumberFormatter()
        formate.numberStyle = NumberFormatter.Style.decimal
        formate.groupingSeparator = ","
        formate.minimumFractionDigits = minDigits
        formate.maximumFractionDigits = maxDigits
        formate.roundingMode = mode
        return formate.string(from: self)
    }
}
