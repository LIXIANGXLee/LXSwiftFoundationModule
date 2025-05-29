//
//  SwiftRegex.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/5/1.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// 正则处理类型配置模型
/// 用于定义不同的正则匹配规则及其对应的样式
public struct SwiftRegexType {
    /// 初始化正则类型配置
    /// - Parameters:
    ///   - regexPattern: 正则表达式字符串，用于匹配目标文本
    ///   - color: 匹配文本的颜色（仅对非表情类型有效）
    ///   - font: 匹配文本的字体（仅对非表情类型有效）
    ///   - isExpression: 是否为表情类型（会替换为图片，需确保此类配置在规则数组末尾）
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
    
    public var regexPattern: String      // 正则表达式
    public var color: UIColor = .orange  // 文本高亮颜色
    public var font: UIFont = UIFont.systemFont(ofSize: 15) // 文本字体
    public var isExpression: Bool = false // 是否为表情类型
}

// MARK: - 正则处理核心类
public final class SwiftRegex {
    
    // 自定义富文本属性键
    public static let textLinkAttributeKey = "SwiftRegexTextLinkKey"   // 超链接标识键
    public static let imageLinkAttributeKey = "SwiftRegexImageLinkKey" // 表情图片标识键
 
    /// 预定义正则表达式模式
    public static let httpRegex = "http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(\\[a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?"
    public static let phoneRegex = "\\d{3,4}[- ]?\\d{7,8}"
    public static let expressionRegex = "\\[(.*?)\\]"  // 匹配形如[表情名]的格式
    
    /// 默认正则配置数组（注意：表情类型必须放在数组末尾）
    public static let defaultRegexTypes: [SwiftRegexType] = [
        SwiftRegexType(regexPattern: httpRegex, color: .blue),   // 超链接匹配（蓝色高亮）
        SwiftRegexType(regexPattern: phoneRegex, color: .green), // 电话匹配（绿色高亮）
        SwiftRegexType(regexPattern: expressionRegex, isExpression: true) // 表情匹配（最后处理）
    ]
}

// MARK: - 公开方法扩展
extension SwiftRegex {
    
    /// 生成富文本（支持多规则匹配）
    /// - Parameters:
    ///   - text: 原始文本内容
    ///   - textColor: 基础文本颜色（默认黑色）
    ///   - textFont: 基础字体（默认系统字体15pt）
    ///   - lineSpacing: 行间距（默认4pt）
    ///   - wordSpacing: 字间距（默认0）
    ///   - regexTypes: 使用的正则配置数组（默认使用defaultRegexTypes）
    /// - Returns: 处理后的富文本对象（可能为nil）
    public static func createAttributedString(
        from text: String,
        textColor: UIColor = .black,
        textFont: UIFont = .systemFont(ofSize: 15),
        lineSpacing: CGFloat = 4,
        wordSpacing: CGFloat = 0,
        regexTypes: [SwiftRegexType] = defaultRegexTypes
    ) -> NSAttributedString? {
        // 空文本检查
        guard !text.isEmpty else { return nil }
        
        // 1. 初始化富文本基础属性
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing  // 设置行间距
        
        // 基础文本属性配置
        let baseAttributes: [NSAttributedString.Key: Any] = [
            .font: textFont,                      // 字体
            .foregroundColor: textColor,           // 文本颜色
            .paragraphStyle: paragraphStyle,       // 段落样式
            .kern: wordSpacing                    // 字间距
        ]
        
        // 2. 创建可变的富文本对象
        let attributedString = NSMutableAttributedString(string: text, attributes: baseAttributes)
        
        // 3. 按顺序处理每个正则规则
        for regexType in regexTypes {
            if regexType.isExpression {
                // 表情类型处理（图片替换）
                processExpressionMatches(in: attributedString, regexType: regexType)
            } else {
                // 文本类型处理（颜色/字体高亮）
                processTextAttributes(in: attributedString, regexType: regexType)
            }
        }
        return attributedString
    }
    
    // MARK: - 私有处理函数
    
    /// 处理文本属性匹配（颜色、字体高亮）
    /// - Parameters:
    ///   - attributedString: 待处理的富文本（可修改）
    ///   - regexType: 当前处理的正则配置
    private static func processTextAttributes(
        in attributedString: NSMutableAttributedString,
        regexType: SwiftRegexType
    ) {
        let text = attributedString.string
        
        // 遍历所有匹配项
        text.lx.enumerateMatches(regex: regexType.regexPattern) { _, matchedString, range in
            // 添加高亮属性
            let highlightAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: regexType.color,
                .font: regexType.font
            ]
            attributedString.addAttributes(highlightAttributes, range: range)
            
            // 添加自定义链接标识（用于后续点击事件处理）
            let customKey = NSAttributedString.Key(rawValue: textLinkAttributeKey)
            attributedString.addAttribute(customKey, value: matchedString, range: range)
        }
    }
    
    /// 处理表情图片替换
    /// - Parameters:
    ///   - attributedString: 待处理的富文本（可修改）
    ///   - regexType: 当前处理的正则配置
    private static func processExpressionMatches(
        in attributedString: NSMutableAttributedString,
        regexType: SwiftRegexType
    ) {
        let text = attributedString.string
        
        // 注意：表情处理必须最后执行，因为替换操作会改变文本长度
        text.lx.enumerateMatches(regex: regexType.regexPattern) { _, matchedString, range in
            // 1. 提取表情名称（移除方括号）
            let expressionName = String(matchedString.dropFirst().dropLast())
            
            // 2. 获取对应图片资源
            guard let image = UIImage(named: expressionName) else {
                SwiftLog.log("表情图片未找到: \(expressionName)")
                return
            }
            
            // 3. 创建文本附件（图片容器）
            let attachment = NSTextAttachment()
            attachment.image = image
            
            // 4. 计算图片尺寸（与当前字体行高对齐）
            let lineHeight = regexType.font.lineHeight
            attachment.bounds = CGRect(
                x: 0,
                y: -3,  // Y轴微调，实现垂直居中
                width: lineHeight,
                height: lineHeight
            )
            
            // 5. 将图片附件转为富文本
            let imageAttr = NSAttributedString(attachment: attachment)
            
            // 6. 执行替换操作（用图片替换文本）
            attributedString.replaceCharacters(in: range, with: imageAttr)
            
            // 7. 添加自定义图片标识（用于后续事件处理）
            // 注意：替换后range长度变为1（单个字符表示图片）
            let newRange = NSRange(location: range.location, length: 1)
            let customKey = NSAttributedString.Key(rawValue: imageLinkAttributeKey)
            attributedString.addAttribute(customKey, value: expressionName, range: newRange)
        }
    }
}
