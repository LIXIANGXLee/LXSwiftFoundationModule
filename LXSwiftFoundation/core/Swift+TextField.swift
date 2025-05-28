//
//  Swift+TextField.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/9/28.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

// MARK: - UITextField 扩展方法
extension SwiftBasics where Base: UITextField {
    
    /// 设置文本框占位文字及其样式
    /// - Parameters:
    ///   - placeholder: 占位文字内容
    ///   - color: 占位文字颜色，默认为十六进制 "#999999" 对应的颜色
    ///   - font: 占位文字字体，默认为常规体14号字
    public func set(withPlaceholder placeholder: String?,
                    color: UIColor = UIColor.lx.color(hex: "999999"),
                    font: UIFont = UIFont.lx.font(withRegular: 14)) {
        // 确保占位文字不为nil
        guard let placeholder = placeholder else { return }
        
        // 创建文字属性字典
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: font
        ]
        
        // 设置带属性的占位文字
        base.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: attributes
        )
    }
    
    /// 设置文本框占位文字及其样式（使用十六进制颜色字符串和字号）
    /// - Parameters:
    ///   - placeholder: 占位文字内容
    ///   - color: 十六进制颜色字符串，默认为 "999999"
    ///   - fontSize: 占位文字字号，默认为14
    public func set(withPlaceholder placeholder: String?,
                    color: String = "999999",
                    fontSize: CGFloat = 14) {
        // 调用主方法，转换颜色和字体参数
        set(withPlaceholder: placeholder,
            color: UIColor.lx.color(hex: color),
            font: UIFont.lx.font(withRegular: fontSize))
    }
}
