//
//  LXSwift+NSAttributedString.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2017/9/29.
//  Copyright © 2017 李响. All rights reserved.
//

import UIKit

extension NSAttributedString: LXSwiftCompatible{ }

//MARK: -  Extending properties and methods for NSAttributedString
extension LXSwiftBasics where Base: NSAttributedString {
    
    /// 根据字体大小和宽度获取字体大小
    public func size(width: CGFloat) -> CGSize {
        let size = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let rect = base.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return rect.size
    }
    
    /// 获取基于字体和宽度的文本高度
    public func height(width: CGFloat) -> CGFloat {
        return size(width: width).height
    }
    
    /// 获取基于字体和宽度的文本宽度
    public var width: CGFloat {
        return size(width: LXSwiftApp.screenW).width
    }
    
    /// 获取的NSAttributeString属性字典
    public var attributes: [NSAttributedString.Key: Any] {
        return base.attributes(at: 0, effectiveRange: nil)
    }
}

//MARK: -  Extending properties and methods for NSMutableAttributedString
extension LXSwiftBasics where Base: NSMutableAttributedString {
    
    func setAttribute(with attribute: NSAttributedString.Key, value: Any?, range: NSRange) {
        guard let value = value else { return }
        base.addAttribute(attribute, value: value, range: range)
    }
    
    func attribute(with key: NSAttributedString.Key, index: Int) -> Any? {
        return base.attribute(key, at: index, effectiveRange: nil)
    }
    
    @discardableResult
    public func set(with font: UIFont?, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSMakeRange(0, base.length)
        setAttribute(with: .font, value: font, range: range)
        return base
    }
    
    @discardableResult
    public func set(with textColor: UIColor?, range: NSRange? = nil) -> NSMutableAttributedString {
        guard let color = textColor else { return base }
        let range = range ?? NSMakeRange(0, base.length)
        setAttribute(with: .foregroundColor, value: color, range: range)
        return base
    }
    
    @discardableResult
    public func setBackgroundColor(with backgroundColor: UIColor?, range: NSRange? = nil) -> NSMutableAttributedString {
        guard let backgroundColor = backgroundColor else { return base }
        let range = range ?? NSMakeRange(0, base.length)
        setAttribute(with: .backgroundColor, value: backgroundColor, range: range)
        return base
    }
    
    /// 添加下划线类型
    @discardableResult
    public func setUnderlineStyle(with underlineStyle: NSUnderlineStyle, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSMakeRange(0, base.length)
        setAttribute(with: .underlineStyle, value: underlineStyle.rawValue, range: range)
        return base
    }
    
    /// 添加下划线颜色
    @discardableResult
    public func setUnderlineColor(with underlineColor: UIColor, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSMakeRange(0, base.length)
        setAttribute(with: .underlineColor, value: underlineColor, range: range)
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
    public func setLineSpace(with lignSpace: CGFloat, range: NSRange? = nil) -> NSMutableAttributedString {
        let paragraphStyle = self.paragraphStyle
        let range = range ?? NSMakeRange(0, base.length)
        paragraphStyle.lineSpacing = lignSpace
        setAttribute(with: .paragraphStyle, value: paragraphStyle, range: range)
        return base
    }
    
    /// 字间距
    @discardableResult
    public func setParagraphSpacing(with paragraphSpacing: CGFloat,
                                    range: NSRange? = nil) -> NSMutableAttributedString {
        let paragraphStyle = self.paragraphStyle
        let range = range ?? NSMakeRange(0, base.length)
        paragraphStyle.paragraphSpacing = paragraphSpacing
        setAttribute(with: .paragraphStyle, value: paragraphStyle, range: range)
        return base
    }
    
    /// Ellipsis pattern of ellipsis
    @discardableResult
    public func setLineBreakMode(with lineBreakMode: NSLineBreakMode,
                                 range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSMakeRange(0, base.length)
        paragraphStyle.lineBreakMode = lineBreakMode
        setAttribute(with: .paragraphStyle, value: paragraphStyle, range: range)
        return base
    }
    
    var paragraphStyle: NSMutableParagraphStyle {
        if let paraStyle = attribute(with: .paragraphStyle, index: 0) as? NSParagraphStyle,
            let mulParaStyle = paraStyle.mutableCopy() as? NSMutableParagraphStyle {
            setAttribute(with: .paragraphStyle, value: mulParaStyle,
                         range: NSMakeRange(0, base.length))
            return mulParaStyle
        }else{
            let mulParaStyle = NSMutableParagraphStyle()
            setAttribute(with: .paragraphStyle, value: mulParaStyle,
                         range: NSMakeRange(0, base.length))
            return mulParaStyle
        }
    }
}
