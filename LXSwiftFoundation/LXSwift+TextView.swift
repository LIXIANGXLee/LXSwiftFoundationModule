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
    
    /// public method call back
    public func setHandle(_ textCallBack: LXSwiftTextView.TextCallBack?) {
        base.textCallBack = textCallBack
    }
    
    /// set placeholder and color
    public func set(with placeholder: String?,
                    color: UIColor? = UIColor.lx.color(hex: "999999")) {
        base.placehoderLabel.text = placeholder
        if let c = color {
            base.placehoderLabel.textColor = c
        }
        
        base.setNeedsLayout()
    }
    
    /// set placeholder and color string
    public func set(with placeholder: String?,
                    color: String = "999999") {
        set(with: placeholder,
            color: UIColor.lx.color(hex: color))
    }
    
    /// set font and textColor
    public func set(withFont font: UIFont,
                    textColor: UIColor?) {
        base.font = font
        if let c = textColor {
            base.textColor = c
        }
    }
    
    /// set bold font and textColor
    public func set(withBoldFont fontSize: CGFloat,
                    textColor: String) {
        set(withFont: UIFont.lx.fontWithBold(fontSize),
            textColor: UIColor.lx.color(hex: textColor))
    }
    
    /// set medium font and textColor
    public func set(withMediumFont fontSize: CGFloat,
                    textColor: String) {
        set(withFont: UIFont.lx.fontWithMedium(fontSize),
            textColor: UIColor.lx.color(hex: textColor))
    }
    
    /// set regular font and textColor
    public func set(withRegularFont fontSize: CGFloat,
                    textColor: String) {
        set(withFont: UIFont.lx.fontWithRegular(fontSize),
            textColor: UIColor.lx.color(hex: textColor))
    }
    
    /// call updateUI  after set text or NSAttributedString
    ///After calling this method, if you want to call the callback function setHandle,
    /// please call after setHandle settings.
    public func updateUI() {
        base.textDidChange()
        base.textCallBack?(base.text)
    }
    
    /// remove observer
    public func removeObserver() {
        NotificationCenter.default.removeObserver(base)
    }
    
    /// 配置文本可输入最长文本长度
    public var maxLength: Int? {
        get{ return base.maxTextLength }
        set{
            guard let newValue = newValue,
                  newValue > 0 else { return }
            base.maxTextLength = newValue
        }
    }
}
