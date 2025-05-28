//
//  Swift+NSAttributedString.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2017/9/29.
//  Copyright © 2017 李响. All rights reserved.
//

import UIKit

// MARK: - NSAttributedString 扩展
extension SwiftBasics where Base: NSAttributedString {
    
    /// 计算富文本在指定宽度下的尺寸
    /// - Parameter width: 指定的宽度
    /// - Returns: 计算得出的尺寸
    public func size(_ width: CGFloat) -> CGSize {
        let size = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let rect = base.boundingRect(with: size,
                                   options: [.usesLineFragmentOrigin, .usesFontLeading],
                                   context: nil)
        return rect.size
    }
    
    /// 计算富文本在指定宽度下的高度
    /// - Parameter width: 指定的宽度
    /// - Returns: 计算得出的高度
    public func height(_ width: CGFloat) -> CGFloat {
        return size(width).height
    }
    
    /// 获取富文本在屏幕宽度下的宽度
    public var width: CGFloat {
        return size(SCREEN_WIDTH_TO_WIDTH).width
    }
    
    /// 获取富文本的属性字典
    public var attributes: [NSAttributedString.Key: Any] {
        return base.attributes(at: 0, effectiveRange: nil)
    }
}

// MARK: - NSMutableAttributedString 扩展
extension SwiftBasics where Base: NSMutableAttributedString {
    
    /// 设置富文本属性
    /// - Parameters:
    ///   - attribute: 属性键
    ///   - value: 属性值
    ///   - range: 应用范围，默认为全文
    public func setAttribute(with attribute: NSAttributedString.Key, value: Any?, range: NSRange) {
        guard let value = value else { return }
        base.addAttribute(attribute, value: value, range: range)
    }
    
    /// 获取指定位置的属性值
    /// - Parameters:
    ///   - key: 属性键
    ///   - index: 字符位置
    /// - Returns: 属性值
    public func attribute(with key: NSAttributedString.Key, index: Int) -> Any? {
        return base.attribute(key, at: index, effectiveRange: nil)
    }
    
    // MARK: - 字体相关
    
    /// 设置字体
    /// - Parameters:
    ///   - font: 要设置的字体
    ///   - range: 应用范围，默认为全文
    /// - Returns: 修改后的富文本(链式调用)
    @discardableResult
    public func set(with font: UIFont?, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSRange(location: 0, length: base.length)
        setAttribute(with: .font, value: font, range: range)
        return base
    }
    
    // MARK: - 颜色相关
    
    /// 设置文本颜色
    /// - Parameters:
    ///   - textColor: 要设置的颜色
    ///   - range: 应用范围，默认为全文
    /// - Returns: 修改后的富文本(链式调用)
    @discardableResult
    public func set(with textColor: UIColor?, range: NSRange? = nil) -> NSMutableAttributedString {
        guard let color = textColor else { return base }
        let range = range ?? NSRange(location: 0, length: base.length)
        setAttribute(with: .foregroundColor, value: color, range: range)
        return base
    }
    
    /// 设置背景颜色
    /// - Parameters:
    ///   - color: 要设置的背景色
    ///   - range: 应用范围，默认为全文
    /// - Returns: 修改后的富文本(链式调用)
    @discardableResult
    public func setBackgroundColor(with color: UIColor?, range: NSRange? = nil) -> NSMutableAttributedString {
        guard let backgroundColor = color else { return base }
        let range = range ?? NSRange(location: 0, length: base.length)
        setAttribute(with: .backgroundColor, value: backgroundColor, range: range)
        return base
    }
    
    // MARK: - 下划线相关
    
    /// 设置下划线样式
    /// - Parameters:
    ///   - style: 下划线样式
    ///   - range: 应用范围，默认为全文
    /// - Returns: 修改后的富文本(链式调用)
    @discardableResult
    public func setUnderlineStyle(with style: NSUnderlineStyle, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSRange(location: 0, length: base.length)
        setAttribute(with: .underlineStyle, value: style.rawValue, range: range)
        return base
    }
    
    /// 设置下划线颜色
    /// - Parameters:
    ///   - color: 下划线颜色
    ///   - range: 应用范围，默认为全文
    /// - Returns: 修改后的富文本(链式调用)
    @discardableResult
    public func setUnderlineColor(with color: UIColor, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSRange(location: 0, length: base.length)
        setAttribute(with: .underlineColor, value: color, range: range)
        return base
    }
    
    // MARK: - 字间距相关
    
    /// 设置字间距
    /// - Parameters:
    ///   - kern: 字间距值
    ///   - range: 应用范围，默认为全文
    /// - Returns: 修改后的富文本(链式调用)
    @discardableResult
    public func setKern(with kern: CGFloat, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSRange(location: 0, length: base.length)
        setAttribute(with: .kern, value: kern, range: range)
        return base
    }
    
    // MARK: - 阴影相关
    
    /// 设置阴影
    /// - Parameters:
    ///   - shadow: 阴影对象
    ///   - range: 应用范围，默认为全文
    /// - Returns: 修改后的富文本(链式调用)
    @discardableResult
    public func setShadow(with shadow: NSShadow, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSRange(location: 0, length: base.length)
        setAttribute(with: .shadow, value: shadow, range: range)
        return base
    }
    
    // MARK: - 删除线相关
    
    /// 设置删除线样式
    /// - Parameters:
    ///   - style: 删除线样式
    ///   - range: 应用范围，默认为全文
    /// - Returns: 修改后的富文本(链式调用)
    @discardableResult
    public func setStrikethrough(with style: NSUnderlineStyle, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSRange(location: 0, length: base.length)
        setAttribute(with: .strikethroughStyle, value: style.rawValue, range: range)
        return base
    }
    
    /// 设置删除线颜色
    /// - Parameters:
    ///   - color: 删除线颜色
    ///   - range: 应用范围，默认为全文
    /// - Returns: 修改后的富文本(链式调用)
    @discardableResult
    public func setStrikethroughColor(with color: UIColor, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSRange(location: 0, length: base.length)
        setAttribute(with: .strikethroughColor, value: color, range: range)
        return base
    }
    
    // MARK: - 段落样式相关
    
    /// 设置文本对齐方式
    /// - Parameter alignment: 对齐方式
    /// - Returns: 修改后的富文本(链式调用)
    @discardableResult
    public func setAlignment(with alignment: NSTextAlignment) -> NSMutableAttributedString {
        let paragraphStyle = self.paragraphStyle
        let range = NSRange(location: 0, length: base.length)
        paragraphStyle.alignment = alignment
        setAttribute(with: .paragraphStyle, value: paragraphStyle, range: range)
        return base
    }
    
    /// 设置行间距
    /// - Parameters:
    ///   - size: 行间距值
    ///   - range: 应用范围，默认为全文
    /// - Returns: 修改后的富文本(链式调用)
    @discardableResult
    public func setLineSpace(with size: CGFloat, range: NSRange? = nil) -> NSMutableAttributedString {
        let paragraphStyle = self.paragraphStyle
        let range = range ?? NSRange(location: 0, length: base.length)
        paragraphStyle.lineSpacing = size
        setAttribute(with: .paragraphStyle, value: paragraphStyle, range: range)
        return base
    }
    
    /// 设置段落间距
    /// - Parameters:
    ///   - size: 段落间距值
    ///   - range: 应用范围，默认为全文
    /// - Returns: 修改后的富文本(链式调用)
    @discardableResult
    public func setParagraphSpacing(with size: CGFloat, range: NSRange? = nil) -> NSMutableAttributedString {
        let paragraphStyle = self.paragraphStyle
        let range = range ?? NSRange(location: 0, length: base.length)
        paragraphStyle.paragraphSpacing = size
        setAttribute(with: .paragraphStyle, value: paragraphStyle, range: range)
        return base
    }
    
    /// 设置换行模式
    /// - Parameters:
    ///   - mode: 换行模式
    ///   - range: 应用范围，默认为全文
    /// - Returns: 修改后的富文本(链式调用)
    @discardableResult
    public func setLineBreakMode(with mode: NSLineBreakMode, range: NSRange? = nil) -> NSMutableAttributedString {
        let range = range ?? NSRange(location: 0, length: base.length)
        paragraphStyle.lineBreakMode = mode
        setAttribute(with: .paragraphStyle, value: paragraphStyle, range: range)
        return base
    }
    
    /// 获取或创建段落样式
    private var paragraphStyle: NSMutableParagraphStyle {
        if let paraStyle = attribute(with: .paragraphStyle, index: 0) as? NSParagraphStyle,
           let mulParaStyle = paraStyle.mutableCopy() as? NSMutableParagraphStyle {
            // 如果已有段落样式，则复制并设置
            setAttribute(with: .paragraphStyle, value: mulParaStyle, range: NSRange(location: 0, length: base.length))
            return mulParaStyle
        } else {
            // 如果没有段落样式，则创建新的
            let mulParaStyle = NSMutableParagraphStyle()
            setAttribute(with: .paragraphStyle, value: mulParaStyle, range: NSRange(location: 0, length: base.length))
            return mulParaStyle
        }
    }
}
