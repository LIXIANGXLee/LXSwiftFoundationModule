//
//  LXSwift+NSAttributedString.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/9/29.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit


//MARK: -  Extending properties and methods for NSAttributedString
extension LXSwiftBasics where Base : NSAttributedString {
    
    ///Get the font size based on the font size and width
    public func size(width: CGFloat) -> CGSize {
        let rect = base.boundingRect(with: CGSize(width: width, height: 0), options: .usesLineFragmentOrigin, context: nil)
        return rect.size
    }
    
    /// Gets the height of the text based on the font and width
    public func height(width: CGFloat) -> CGFloat {
        return size(width: width).height
    }
    
    /// Gets the width of the text based on the font and width
    public var width: CGFloat {
        return size(width: LXSwiftApp.screenW).width
    }
    
    /// Gets NSAttributedString Property dictionary for
    public var attributes: [NSAttributedString.Key: Any] {
        return base.attributes(at: 0, effectiveRange: nil)
    }
}


//MARK: -  Extending properties and methods for NSMutableAttributedString
extension LXSwiftBasics where Base : NSMutableAttributedString {
    
    internal func setAttribute(_ attribute: NSAttributedString.Key, value: Any?, range: NSRange) {
        guard let value = value else { return }
        base.addAttribute(attribute, value: value, range: range)
    }
    
    internal func attribute(_ key: NSAttributedString.Key, index: Int) -> Any? {
        return base.attribute(key, at: index, effectiveRange: nil)
    }
    
    /// Set font information
    @discardableResult
    public func set(with font: UIFont?, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSMakeRange(0, base.length)
        setAttribute(.font, value: font, range: range)
        return base
    }
    
    /// Set font color information
    @discardableResult
    public func set(with textColor: UIColor?, range: NSRange? = nil) -> NSMutableAttributedString {
        guard let color = textColor else { return base}
        let range = range ?? NSMakeRange(0, base.length)
        setAttribute(.foregroundColor, value: color, range: range)
        return base
    }
    
    /// The background color of the font
    @discardableResult
    public func setBackgroundColor(with backgroundColor: UIColor?, range: NSRange? = nil) -> NSMutableAttributedString {
        guard let backgroundColor = backgroundColor else { return base}
        let range = range ?? NSMakeRange(0, base.length)
        setAttribute(.backgroundColor, value: backgroundColor, range: range)
        return base
    }
    
    /// Underline
    @discardableResult
    public func setUnderlineStyle(_ underlineStyle: NSUnderlineStyle, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSMakeRange(0, base.length)
        setAttribute(.underlineStyle, value: underlineStyle.rawValue, range: range)
        return base
    }
    
    /// Underline color
    @discardableResult
    public func setUnderlineColor(_ underlineColor: UIColor, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSMakeRange(0, base.length)
        setAttribute(.underlineColor, value: underlineColor, range: range)
        return base
    }
    
    /// Word spacing
    @discardableResult
    public func setKern(_ kern: CGFloat, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSMakeRange(0, base.length)
        setAttribute(.kern, value: kern, range: range)
        return base
    }
    
    /// Shadow of font
    @discardableResult
    public func setShadow(_ shadow: NSShadow, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSMakeRange(0, base.length)
        setAttribute(.shadow, value: shadow, range: range)
        return base
    }
    
    // Strikethrough
    @discardableResult
    public func setStrikethrough(_ style: NSUnderlineStyle, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSMakeRange(0, base.length)
        setAttribute(.strikethroughStyle, value: style.rawValue, range: range)
        return base
    }
    
    /// Color of strikethrough
    @discardableResult
    public func setStrikethroughColor(_ color: UIColor, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSMakeRange(0, base.length)
        setAttribute(.strikethroughColor, value: color, range: range)
        return base
    }
    
    /// Set font alignment
    @discardableResult
    public func setAlignment(_ alignment: NSTextAlignment) -> NSMutableAttributedString {
        let paragraphStyle = self.paragraphStyle
        let range = NSRange(location: 0, length: base.length)
        paragraphStyle.alignment = alignment
        setAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        return base
    }
    
    /// Row spacing
    @discardableResult
    public func setLineSpace(_ lignSpace: CGFloat, range: NSRange? = nil) -> NSMutableAttributedString {
        let paragraphStyle = self.paragraphStyle
        let range = range ?? NSMakeRange(0, base.length)
        paragraphStyle.lineSpacing = lignSpace
        setAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        return base
    }
    
    /// Segment spacing
    @discardableResult
    public func setParagraphSpacing(_ paragraphSpacing: CGFloat, range: NSRange? = nil) -> NSMutableAttributedString {
        let paragraphStyle = self.paragraphStyle
        let range = range ?? NSMakeRange(0, base.length)
        paragraphStyle.paragraphSpacing = paragraphSpacing
        setAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        return base
    }
    
    /// Ellipsis pattern of ellipsis
    @discardableResult
    public func setLineBreakMode(_ lineBreakMode: NSLineBreakMode, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSMakeRange(0, base.length)
        paragraphStyle.lineBreakMode = lineBreakMode
        setAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        return base
    }
    
    internal var paragraphStyle: NSMutableParagraphStyle {
        if let paraStyle = attribute(.paragraphStyle, index: 0) as? NSParagraphStyle,
            let mulParaStyle = paraStyle.mutableCopy() as? NSMutableParagraphStyle {
            setAttribute(.paragraphStyle, value: mulParaStyle, range: NSMakeRange(0, base.length))
            return mulParaStyle
        }else{
            let mulParaStyle = NSMutableParagraphStyle()
            setAttribute(.paragraphStyle, value: mulParaStyle, range: NSMakeRange(0, base.length))
            return mulParaStyle
        }
    }
}
