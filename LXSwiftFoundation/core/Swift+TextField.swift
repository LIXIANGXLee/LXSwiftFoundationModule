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
    
    /// 设置文本框的占位文字及其样式
    /// - Parameters:
    ///   - placeholder: 占位文字内容（可选类型，传入 nil 将不执行设置操作）
    ///   - color: 占位文字颜色（默认值：十六进制 "#999999" 对应的浅灰色）
    ///   - font: 占位文字字体（默认值：常规体 14 号系统字体）
    public func set(withPlaceholder placeholder: String?,
                    color: UIColor = UIColor.lx.color(hex: "999999"),
                    font: UIFont = UIFont.lx.font(withRegular: 14)) {
        
        // 安全校验：当 placeholder 为 nil 时直接返回，避免空字符串设置
        guard let placeholder = placeholder, !placeholder.isEmpty else {
            return
        }
        
        // 创建文字属性字典，包含样式配置：
        // 1. 文字颜色 - 使用传入的 color 参数
        // 2. 字体样式 - 使用传入的 font 参数
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,  // 设置文字颜色
            .font: font                // 设置字体样式
        ]
        
        // 生成富文本占位字符串：
        // 使用 NSAttributedString 将普通字符串与样式属性结合
        let attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: attributes
        )
        
        // 将富文本赋值给文本框的 attributedPlaceholder 属性
        // 此属性接受 NSAttributedString 类型，支持样式化显示
        base.attributedPlaceholder = attributedPlaceholder
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
