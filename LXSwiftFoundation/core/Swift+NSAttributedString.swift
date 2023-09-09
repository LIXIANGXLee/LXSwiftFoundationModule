//
//  Swift+NSAttributedString.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2017/9/29.
//  Copyright © 2017 李响. All rights reserved.
//

import UIKit

//MARK: -  Extending properties and methods for NSAttributedString
extension SwiftBasics where Base: NSAttributedString {
    
    /// 根据字体大小和宽度获取字体大小
    public func size(_ width: CGFloat) -> CGSize {
        let size = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let rect = base.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return rect.size
    }
    
    /// 获取基于字体和宽度的文本高度
    public func height(_ width: CGFloat) -> CGFloat {
        size(width).height
    }
    
    /// 获取基于字体和宽度的文本宽度
    public var width: CGFloat {
        size(SCREEN_WIDTH_TO_WIDTH).width
    }
    
    /// 获取的NSAttributeString属性字典
    public var attributes: [NSAttributedString.Key: Any] {
        base.attributes(at: 0, effectiveRange: nil)
    }
}

//MARK: -  Extending properties and methods for NSMutableAttributedString
extension SwiftBasics where Base: NSMutableAttributedString {
    
    public func setAttribute(with attribute: NSAttributedString.Key, value: Any?, range: NSRange) {
        guard let value = value else { return }
        base.addAttribute(attribute, value: value, range: range)
    }
    
    public func attribute(with key: NSAttributedString.Key, index: Int) -> Any? {
        base.attribute(key, at: index, effectiveRange: nil)
    }
    
    @discardableResult
    public func set(with font: UIFont?, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSMakeRange(0, base.length)
        setAttribute(with: .font, value: font, range: range)
        return base
    }
    
    @discardableResult
    public func set(with textColor: UIColor?, range: NSRange? = nil) -> NSMutableAttributedString {
        guard let color = textColor else {
            return base
        }
        let range = range ?? NSMakeRange(0, base.length)
        setAttribute(with: .foregroundColor, value: color, range: range)
        return base
    }
    
    @discardableResult
    public func setBackgroundColor(with color: UIColor?, range: NSRange? = nil) -> NSMutableAttributedString {
        guard let backgroundColor = color else {
            return base
        }
        let range = range ?? NSMakeRange(0, base.length)
        setAttribute(with: .backgroundColor, value: backgroundColor, range: range)
        return base
    }
    
    /// 添加下划线类型
    @discardableResult
    public func setUnderlineStyle(with style: NSUnderlineStyle, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSMakeRange(0, base.length)
        setAttribute(with: .underlineStyle, value: style.rawValue, range: range)
        return base
    }
    
    /// 添加下划线颜色
    @discardableResult
    public func setUnderlineColor(with color: UIColor, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSMakeRange(0, base.length)
        setAttribute(with: .underlineColor, value: color, range: range)
        return base
    }
    
    @discardableResult
    public func setKern(with kern: CGFloat, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSMakeRange(0, base.length)
        setAttribute(with: .kern, value: kern, range: range)
        return base
    }
    
    /// 阴影大小
    @discardableResult
    public func setShadow(with shadow: NSShadow, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSMakeRange(0, base.length)
        setAttribute(with: .shadow, value: shadow, range: range)
        return base
    }
    
    /// 内容横穿线
    @discardableResult
    public func setStrikethrough(with style: NSUnderlineStyle, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSMakeRange(0, base.length)
        setAttribute(with: .strikethroughStyle, value: style.rawValue, range: range)
        return base
    }
    
    /// 内容横穿线颜色
    @discardableResult
    public func setStrikethroughColor(with color: UIColor, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSMakeRange(0, base.length)
        setAttribute(with: .strikethroughColor, value: color, range: range)
        return base
    }
    
    /// 对齐方式
    @discardableResult
    public func setAlignment(with alignment: NSTextAlignment) -> NSMutableAttributedString {
        let paragraphStyle = self.paragraphStyle
        let range = NSRange(location: 0, length: base.length)
        paragraphStyle.alignment = alignment
        setAttribute(with: .paragraphStyle, value: paragraphStyle, range: range)
        return base
    }
    
    /// 行间距
    @discardableResult
    public func setLineSpace(with size: CGFloat, range: NSRange? = nil) -> NSMutableAttributedString {
        let paragraphStyle = self.paragraphStyle
        let range = range ?? NSMakeRange(0, base.length)
        paragraphStyle.lineSpacing = size
        setAttribute(with: .paragraphStyle, value: paragraphStyle, range: range)
        return base
    }
    
    /// 字间距
    @discardableResult
    public func setParagraphSpacing(with size: CGFloat, range: NSRange? = nil) -> NSMutableAttributedString {
        let paragraphStyle = self.paragraphStyle
        let range = range ?? NSMakeRange(0, base.length)
        paragraphStyle.paragraphSpacing = size
        setAttribute(with: .paragraphStyle, value: paragraphStyle, range: range)
        return base
    }
    
    /// Ellipsis pattern of ellipsis
    @discardableResult
    public func setLineBreakMode(with mode: NSLineBreakMode, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSMakeRange(0, base.length)
        paragraphStyle.lineBreakMode = mode
        setAttribute(with: .paragraphStyle, value: paragraphStyle, range: range)
        return base
    }
    
    var paragraphStyle: NSMutableParagraphStyle {
        if let paraStyle = attribute(with: .paragraphStyle, index: 0) as? NSParagraphStyle,
            let mulParaStyle = paraStyle.mutableCopy() as? NSMutableParagraphStyle {
            setAttribute(with: .paragraphStyle, value: mulParaStyle, range: NSMakeRange(0, base.length))
            return mulParaStyle
        } else {
            let mulParaStyle = NSMutableParagraphStyle()
            setAttribute(with: .paragraphStyle, value: mulParaStyle, range: NSMakeRange(0, base.length))
            return mulParaStyle
        }
    }
}
