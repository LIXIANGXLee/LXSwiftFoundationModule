//
//  Swift+Number.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/9/27.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

//MARK: -  Extending methods for NSNumber
extension SwiftBasics where Base: NSNumber {
 
    /// 四舍五入应该保留多少小数位
    /// - maxDigits：保留几个小数位
    public func numberFormatter(with mode: NumberFormatter.RoundingMode = .halfEven, minDigits: Int = 0, maxDigits:Int = 0) -> String? {
        base.numberFormatter(with: mode, minDigits: minDigits, maxDigits: maxDigits)
    }
    
    /// 保留两位小数
    public func numberFormatter() -> String? {
        base.numberFormatter(with: .halfEven, minDigits: 0,maxDigits: 2)
    }
}

//MARK: -  Extending internal methods for NSNumber
extension NSNumber {
    
    /// 四舍五入应该保留多少小数位 maxDigits：保留几个小数位
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
