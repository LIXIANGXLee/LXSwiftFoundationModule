//
//  LXWordRegex.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/5/1.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import LXFitManager

public let textLinkConst = "textLinkConst__"
public let imageLinkConst = "imageLinkConst__"


// MARK: public LXWordRegexType 超链接类型
public struct LXSwiftWordRegexType {
   
    /// 指定初始化起
    public init(_ link: String,
                color: UIColor = UIColor.orange,
                font: UIFont = UIFont.systemFont(ofSize: 15),
                isExpression: Bool = false){
        self.link = link
        self.color = color
        self.font = font
        self.isExpression = isExpression
    }
    
    ///超链接匹配字符串
    public var link: String
    ///超链接字符串颜色
    public var color: UIColor = UIColor.orange
    ///超链接字符串字体大小
    public var font: UIFont = UIFont.systemFont(ofSize: 15)
    
    ///是否为表情 匹配 true 为表情匹配 false 超链接、电话匹配
    public var isExpression: Bool = false
   
}


// MARK: public
public class LXSwiftWordRegex {
    
    ///超链接匹配
    public static let httpRegex = "http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(/[a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?"
    ///电话号匹配
    public static let phoneRegex = "\\d{3,4}[- ]?\\d{7,8}"
    ///表情匹配
    public static let expressionRegex = "\\[.*?\\]"
    
    ///默认参数
    public static let wordRegexTypes = [
        LXSwiftWordRegexType(httpRegex, isExpression: false),
        LXSwiftWordRegexType(phoneRegex, isExpression: false),
        LXSwiftWordRegexType(expressionRegex, isExpression: true)
     ]

}

// MARK: public method
extension LXSwiftWordRegex {
    
    ///字符串匹配
    ///
    /// - Parameters:
    ///   - text: 文本内容
    ///   - textColor: 文本内容颜色
    ///   - textFont: 文本内容字体大小
    ///   - wordRegexTypes: 超链接文本配置信息
    public class func regex(of text: String,
                            textColor: UIColor = UIColor.black,
                            textFont: UIFont = UIFont.systemFont(ofSize: 15),
                            wordRegexTypes : [LXSwiftWordRegexType] = wordRegexTypes)
        -> NSAttributedString? {
        
        /// 文本校验
       if text.count <= 0 { return nil }
       let attributes = [NSAttributedString.Key.font: textFont, NSAttributedString.Key.foregroundColor: textColor]
       let attributedStr = NSMutableAttributedString(string: text, attributes:attributes)
        
        // 开始文本匹配
        for wordRegexType in wordRegexTypes {
            
            if wordRegexType.isExpression { // 表情匹配
                text.lx.enumerateStringsMatchedByRegex(regex: wordRegexType.link) { (captureCount, capturedStrings, range) in
                    
                    let attachment = NSTextAttachment()
                    attachment.image = UIImage(named: capturedStrings)
                    attachment.bounds = CGRect(x: 0, y: LXFit.fitFloat(-3), width: wordRegexType.font.fitFont.lineHeight, height: wordRegexType.font.fitFont.lineHeight)
                    let imageAttr = NSAttributedString(attachment: attachment)
                    attributedStr.replaceCharacters(in: range, with: imageAttr)
                    attributedStr.addAttribute(NSAttributedString.Key(rawValue: imageLinkConst), value: capturedStrings, range: range)
                }
            }else {
                // 匹配超链接
                text.lx.enumerateStringsMatchedByRegex(regex: wordRegexType.link) { (captureCount, capturedStrings, range) in
                    attributedStr.addAttributes([NSAttributedString.Key.foregroundColor : wordRegexType.color,NSAttributedString.Key.font: wordRegexType.font.fitFont], range: range)
                 attributedStr.addAttribute(NSAttributedString.Key(rawValue: textLinkConst), value: capturedStrings, range: range)
              }
           }
        }
           return attributedStr
    }
}
