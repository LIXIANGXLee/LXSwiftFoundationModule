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
    
    /// 设置文本框的富文本占位文字
    /// - Parameters:
    ///   - placeholder: 占位文字内容（`nil` 或空字符串时不生效）
    ///   - color: 占位文字颜色（默认值：十六进制 "#999999" 对应的浅灰色）
    ///   - font: 占位文字字体（默认值：常规体 14 号系统字体）
    public func setPlaceholder(
        _ placeholder: String?,
        color: UIColor = UIColor.lx.color(hex: "999999"),
        font: UIFont = UIFont.lx.font(withRegular: 14))
    {
        // 安全校验：过滤 nil 和空字符串
        guard let text = placeholder, !text.isEmpty else { return }
        
        // 创建带样式的富文本属性
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: font
        ]
        
        // 生成富文本并赋值给文本框
        base.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: attributes
        )
    }
    
    /// 便捷设置占位文字（通过十六进制颜色和字号）
    /// - Parameters:
    ///   - placeholder: 占位文字内容
    ///   - color: 十六进制颜色字符串（默认："999999"）
    ///   - fontSize: 文字尺寸（默认：14）
    public func setPlaceholder(
        _ placeholder: String?,
        color: String = "999999",
        fontSize: CGFloat = 14)
    {
        // 转换为颜色/字体对象后调用主方法
        setPlaceholder(
            placeholder,
            color: UIColor.lx.color(hex: color),
            font: UIFont.lx.font(withRegular: fontSize)
        )
    }
}
