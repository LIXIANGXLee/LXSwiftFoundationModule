//
//  SwiftRegex.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/5/1.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// 定义正则处理类型，用于配置不同的正则匹配规则及样式
public struct SwiftRegexType {
    /// 初始化方法
    /// - Parameters:
    ///   - regexPattern: 正则表达式字符串
    ///   - color: 文本颜色（仅对非表情有效）
    ///   - font: 文本字体（仅对非表情有效）
    ///   - isExpression: 是否为表情匹配（会替换为图片，需确保此类型配置在数组末尾）
    public init(
        regexPattern: String,
        color: UIColor = .orange,
        font: UIFont = UIFont.systemFont(ofSize: 15),
        isExpression: Bool = false
    ) {
        self.regexPattern = regexPattern
        self.isExpression = isExpression
        self.color = color
        self.font = font
    }
    
    public var regexPattern: String
    public var color: UIColor = .orange
    public var font: UIFont = UIFont.systemFont(ofSize: 15)
    public var isExpression: Bool = false
}

// MARK: - 正则处理核心类
public final class SwiftRegex {
    
    // 富文本自定义键，用于标识超链接和图片
    public static let textLinkAttributeKey = "SwiftRegexTextLinkKey"
    public static let imageLinkAttributeKey = "SwiftRegexImageLinkKey"
 
    /// 超链接匹配字符串表达式
    public static let httpRegex = "http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(\\[a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?"
    /// 电话号匹配表达式
    public static let phoneRegex = "\\d{3,4}[- ]?\\d{7,8}"
    /// 表情匹配表达式（匹配形如[xxx]的字符串）
    public static let expressionRegex = "\\[(.*?)\\]"
    
    /// 默认正则配置：注意替换类型（如表情）必须放在数组末尾处理
    public static let defaultRegexTypes: [SwiftRegexType] = [
        SwiftRegexType(regexPattern: httpRegex, color: .blue), // 超链接
        SwiftRegexType(regexPattern: phoneRegex, color: .green), // 电话
        SwiftRegexType(regexPattern: expressionRegex, isExpression: true) // 表情（最后处理）
    ]
}

// MARK: - 公开方法
extension SwiftRegex {
    
    /// 生成富文本（支持多规则匹配）
    /// - Parameters:
    ///   - text: 原始文本
    ///   - textColor: 基础文本颜色
    ///   - textFont: 基础字体
    ///   - lineSpacing: 行间距
    ///   - wordSpacing: 字间距
    ///   - regexTypes: 使用的正则配置（替换类型如表情必须放在数组末尾）
    public static func createAttributedString(
        from text: String,
        textColor: UIColor = .black,
        textFont: UIFont = .systemFont(ofSize: 15),
        lineSpacing: CGFloat = 4,
        wordSpacing: CGFloat = 0,
        regexTypes: [SwiftRegexType] = defaultRegexTypes
    ) -> NSAttributedString? {
        guard !text.isEmpty else { return nil }
        
        // 初始化富文本基础属性
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        let baseAttributes: [NSAttributedString.Key: Any] = [
            .font: textFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle,
            .kern: wordSpacing
        ]
        let attributedString = NSMutableAttributedString(string: text, attributes: baseAttributes)
        
        // 按顺序处理每个正则配置
        for regexType in regexTypes {
            // 确保表情类型的正则最后处理以避免范围偏移
            if regexType.isExpression {
                processExpressionMatches(
                    in: attributedString,
                    regexType: regexType
                )
            } else {
                processTextAttributes(
                    in: attributedString,
                    regexType: regexType
                )
            }
        }
        return attributedString
    }
    
    // MARK: - 私有处理函数
    
    /// 处理文本属性匹配（颜色、字体等）
    private static func processTextAttributes(
        in attributedString: NSMutableAttributedString,
        regexType: SwiftRegexType) {
        let text = attributedString.string
        text.lx.enumerateMatches(regex: regexType.regexPattern) { _, matchedString, range in
            // 添加颜色和字体属性
            attributedString.addAttributes([
                .foregroundColor: regexType.color,
                .font: regexType.font
            ], range: range)
            // 添加自定义链接属性
            let key = NSAttributedString.Key(rawValue: textLinkAttributeKey)
            attributedString.addAttribute(key, value: matchedString, range: range)
        }
    }
    
    /// 处理表情图片替换
    private static func processExpressionMatches(
        in attributedString: NSMutableAttributedString,
        regexType: SwiftRegexType) {
        let text = attributedString.string
        text.lx.enumerateMatches(regex: regexType.regexPattern) { _, matchedString, range in
            // 从匹配的字符串中提取表情名称（去除方括号）
            let expressionName = String(matchedString.dropFirst().dropLast())
            guard let image = UIImage(named: expressionName) else {
                SwiftLog.log("表情图片未找到: \(expressionName)")
                return
            }
            
            // 创建文本附件
            let attachment = NSTextAttachment()
            attachment.image = image
            let lineHeight = regexType.font.lineHeight
            attachment.bounds = CGRect(
                x: 0,
                y: -3, // 微调Y轴位置使其与文本对齐
                width: lineHeight,
                height: lineHeight
            )
            
            // 替换原始文本为图片附件
            let imageAttr = NSAttributedString(attachment: attachment)
            attributedString.replaceCharacters(in: range, with: imageAttr)
            
            // 添加自定义图片属性
            let key = NSAttributedString.Key(rawValue: imageLinkAttributeKey)
            attributedString.addAttribute(key, value: expressionName, range: range)
        }
    }
}
