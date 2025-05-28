//
//  Swift+Number.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/9/27.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

// MARK: - NSNumber 扩展方法
extension SwiftBasics where Base: NSNumber {
    
    /// 数字格式化，支持四舍五入和指定小数位数
    /// - Parameters:
    ///   - mode: 舍入模式，默认使用银行家舍入法(.halfEven)
    ///   - minDigits: 最小保留小数位数，默认为0
    ///   - maxDigits: 最大保留小数位数，默认为0
    /// - Returns: 格式化后的字符串
    public func numberFormatter(with mode: NumberFormatter.RoundingMode = .halfEven,
                              minDigits: Int = 0,
                              maxDigits: Int = 2) -> String? {
        base.numberFormatter(with: mode, minDigits: minDigits, maxDigits: maxDigits)
    }

}

// MARK: - NSNumber 内部扩展方法
extension NSNumber {
    
    /// 数字格式化核心实现
    /// - Parameters:
    ///   - mode: 舍入模式
    ///   - minDigits: 最小保留小数位数
    ///   - maxDigits: 最大保留小数位数
    /// - Returns: 格式化后的字符串
    fileprivate func numberFormatter(with mode: NumberFormatter.RoundingMode = .halfEven,
                                   minDigits: Int = 0,
                                   maxDigits: Int = 0) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal          // 设置为十进制格式
        formatter.groupingSeparator = ","          // 千位分隔符
        formatter.minimumFractionDigits = minDigits // 最小小数位数
        formatter.maximumFractionDigits = maxDigits // 最大小数位数
        formatter.roundingMode = mode             // 舍入模式
        return formatter.string(from: self)
    }
}
