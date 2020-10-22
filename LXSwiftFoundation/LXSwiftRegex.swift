//
//  LXSwiftRegex.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/5/1.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import LXFitManager

// MARK: public LXRegexType Hyperlink type
public struct LXSwiftRegexType {
    
    public init(_ link: String,
                color: UIColor = UIColor.orange,
                font: UIFont = UIFont.systemFont(ofSize: 15),
                isExpression: Bool = false){
        self.link = link
        self.color = color
        self.font = font
        self.isExpression = isExpression
    }
    
    ///Hyperlink matching string
    public var link: String
    ///Hyperlink string color
    public var color: UIColor = UIColor.orange
    ///Hyperlink string font size
    public var font: UIFont = UIFont.systemFont(ofSize: 15)
    
    ///Whether to match for expression true for expression match false for hyperlink, phone match
    public var isExpression: Bool = false
    
}


// MARK: public
public class LXSwiftRegex {
    
    public static let textLinkConst = "textLinkConst__"
    public static let imageLinkConst = "imageLinkConst__"
    
    ///Hyperlink matching string
    public static let httpRegex = "http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(/[a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?"
    ///Phone number matching
    public static let phoneRegex = "\\d{3,4}[- ]?\\d{7,8}"
    ///Expression matching
    public static let expressionRegex = "\\[.*?\\]"
    
    ///Default parameters
    public static let wordRegexTypes = [
        LXSwiftRegexType(httpRegex, isExpression: false),
        LXSwiftRegexType(phoneRegex, isExpression: false),
        LXSwiftRegexType(expressionRegex, isExpression: true)
    ]
    
}

// MARK: public method
extension LXSwiftRegex {
    
    ///String matching
    ///
    /// - Parameters:
    ///- Text: text content
    ///- textcolor: text content color
    ///- textfont: text content font size
    ///- wordregextypes: hyperlink text configuration information
    public class func regex(of text: String,
                            textColor: UIColor = UIColor.black,
                            textFont: UIFont = UIFont.systemFont(ofSize: 15),
                            wordRegexTypes : [LXSwiftRegexType] = wordRegexTypes)
        -> NSAttributedString? {
            
        if text.count <= 0 { return nil }
        let attributes = [NSAttributedString.Key.font: textFont, NSAttributedString.Key.foregroundColor: textColor]
        let attributedStr = NSMutableAttributedString(string: text, attributes:attributes)
        
        // Start text matching
        for wordRegexType in wordRegexTypes {
            
            if wordRegexType.isExpression { // Expression matching
                text.lx.enumerateStringsMatchedByRegex(regex: wordRegexType.link) { (captureCount, capturedStrings, range) in
                    
                    let attachment = NSTextAttachment()
                    attachment.image = UIImage(named: capturedStrings)
                    attachment.bounds = CGRect(x: 0, y: LXFit.fitFloat(-3), width: wordRegexType.font.fitFont.lineHeight, height: wordRegexType.font.fitFont.lineHeight)
                    let imageAttr = NSAttributedString(attachment: attachment)
                    attributedStr.replaceCharacters(in: range, with: imageAttr)
                    attributedStr.addAttribute(NSAttributedString.Key(rawValue: LXSwiftRegex.imageLinkConst), value: capturedStrings, range: range)
                }
            }else {
                // Match hyperlinks
                text.lx.enumerateStringsMatchedByRegex(regex: wordRegexType.link) { (captureCount, capturedStrings, range) in
                    attributedStr.addAttributes([NSAttributedString.Key.foregroundColor : wordRegexType.color,NSAttributedString.Key.font: wordRegexType.font.fitFont], range: range)
                    attributedStr.addAttribute(NSAttributedString.Key(rawValue: LXSwiftRegex.textLinkConst), value: capturedStrings, range: range)
                }
            }
        }
        return attributedStr
    }
}
