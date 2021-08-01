//
//  LXSwift+TextView.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/29.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

//MARK: -  Extending properties and methods for LXSwiftTextView
extension LXSwiftBasics where Base : LXSwiftTextView {
    
    /// 公共方法回调
    public func setHandle(_ textCallBack: LXSwiftTextView.TextCallBack?) {
        base.textCallBack = textCallBack
    }
    
    /// 设置占位符和颜色
    public func set(with placeholder: String?,
                    color: UIColor? = UIColor.lx.color(hex: "999999")) {
        base.placehoderLabel.text = placeholder
        if let c = color {
            base.placehoderLabel.textColor = c
        }
        base.setNeedsLayout()
    }
    
    /// 设置占位符和颜色字符串
    public func set(with placeholder: String?, color: String = "999999") {
        set(with: placeholder,
            color: UIColor.lx.color(hex: color))
    }
    
    /// 设置字体和文本颜色
    public func set(with font: UIFont, textColor: UIColor?) {
        base.font = font
        if let c = textColor {
            base.textColor = c
        }
    }
    
    /// 设置粗体字体和文本颜色
    public func set(withBold fontSize: CGFloat,textColor: String) {
        set(with: UIFont.lx.fontWithBold(fontSize),
            textColor: UIColor.lx.color(hex: textColor))
    }
    
    /// 设置中等字体和文本颜色
    public func set(withMedium fontSize: CGFloat, textColor: String) {
        set(with: UIFont.lx.fontWithMedium(fontSize),
            textColor: UIColor.lx.color(hex: textColor))
    }
    
    /// 设置常规字体和文本颜色
    public func set(withRegular fontSize: CGFloat, textColor: String) {
        set(with: UIFont.lx.fontWithRegular(fontSize),
            textColor: UIColor.lx.color(hex: textColor))
    }
    
    /// 在set text或nsattributestring之后调用updateUI，调用此方法后，
    /// 如果要调用回调函数setHandle，请在设置句柄设置后调用。
    public func updateUI() {
        base.textDidChange()
        base.textCallBack?(base.text)
    }
    
    /// 移除观察者
    public func removeObserver() {
        NotificationCenter.default.removeObserver(base)
    }
    
    /// 配置文本可输入最长文本长度
    public var maxLength: Int? {
        get{ return base.maxTextLength }
        set{
            guard let newValue = newValue, newValue > 0 else { return }
            base.maxTextLength = newValue
        }
    }
}
