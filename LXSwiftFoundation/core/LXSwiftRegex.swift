//
//  LXSwiftRegex.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/5/1.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

// MARK: public LXRegexType Hyperlink type
public struct LXSwiftRegexType {
    
    public init(with link: String, color: UIColor = UIColor.orange, font: UIFont = UIFont.lx.font(withRegular: 15), isExpression: Bool = false) {
        self.link = link
        self.color = color
        self.font = font
        self.isExpression = isExpression
    }
    
    public var link: String
    public var color: UIColor = UIColor.orange
    public var font: UIFont = UIFont.systemFont(ofSize: 15)
    
    /// 是否匹配表达式true 是匹配表情 
    public var isExpression: Bool = false
}

// MARK: public
public final class LXSwiftRegex {
    
    public static let textLinkConst = "textLinkConst__"
    public static let imageLinkConst = "imageLinkConst__"
    
    /// 超链接匹配字符串表达式
    public static let httpRegex = """
    http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(/\
    [a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?
    """
    /// 电话号匹配表达式
    public static let phoneRegex = "\\d{3,4}[- ]?\\d{7,8}"
    
    /// 表情匹配表达式
    public static let expressionRegex = "\\[.*?\\]"
    
    /// 默认匹配集合（超链接、电话号码、表情）
    public static let wordRegexTypes = [
        LXSwiftRegexType(with: httpRegex, isExpression: false),
        LXSwiftRegexType(with: phoneRegex, isExpression: false),
        LXSwiftRegexType(with: expressionRegex, isExpression: true)
    ]
}

// MARK: public method
extension LXSwiftRegex {
    
    /// 字符串匹配 识别返回NSAttributedString富文本
    ///
    /// - 参数：
    /// - text：文本内容
    /// - textColor：文本内容颜色
    /// - textFont：文本内容字体大小
    /// - lineSpaceing：行间距
    /// - wordSpaceing：字间距
    /// - wordregextypes:超链接文本配置信息
    public static func regex(of text: String, textColor: UIColor = UIColor.black,textFont: UIFont = UIFont.systemFont(ofSize: 15),  lineSpaceing: CGFloat = 4, wordSpaceing: CGFloat = 0, wordRegexTypes: [LXSwiftRegexType] = wordRegexTypes) -> NSAttributedString? {
        if text.count <= 0 { return nil }
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpaceing
        let attributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.paragraphStyle: style,
            NSAttributedString.Key.kern: wordSpaceing
        ] as [NSAttributedString.Key : Any]
        let attributedStr = NSMutableAttributedString(string: text, attributes:attributes)
        /// Start text matching
        for wordRegexType in wordRegexTypes {
            if wordRegexType.isExpression { // Expression matching
                text.lx.enumerateStringsMatchedByRegex(regex: wordRegexType.link)
                { (captureCount, capturedStrings, range) in
                    let attachment = NSTextAttachment()
                    attachment.image = UIImage(named: capturedStrings)
                    attachment.bounds = CGRect(x: 0,
                                               y: SCALE_IP6_WIDTH_TO_WIDTH(-3),
                                               width: wordRegexType.font.lineHeight,
                                               height: wordRegexType.font.lineHeight)
                    let imageAttr = NSAttributedString(attachment: attachment)
                    attributedStr.replaceCharacters(in: range, with: imageAttr)
                    let key = NSAttributedString.Key(rawValue: LXSwiftRegex.imageLinkConst)
                    attributedStr.addAttribute(key, value: capturedStrings, range: range)
                }
            }else {
                /// Match hyperlinks
                text.lx.enumerateStringsMatchedByRegex(regex: wordRegexType.link)
                { (captureCount, capturedStrings, range) in
                    attributedStr.addAttributes([.foregroundColor : wordRegexType.color,
                             .font: wordRegexType.font], range: range)
                    let key = NSAttributedString.Key(rawValue: LXSwiftRegex.textLinkConst)
                    attributedStr.addAttribute(key, value: capturedStrings, range: range)
                }
            }
        }
        return attributedStr
    }
}
