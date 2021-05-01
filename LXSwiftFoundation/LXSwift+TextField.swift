//
//  LXSwift+TextField.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/9/28.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

//MARK: -  Extending properties for LXSwiftTextField
extension LXSwiftBasics where Base : LXSwiftTextField {
    
    /// 配置文本可输入最长文本长度
    public var maxLength: Int? {
        get{ return base.maxTextLength }
        set{
            guard let newValue = newValue, newValue > 0 else { return }
            base.maxTextLength = newValue
            NotificationCenter.default.addObserver(base,
                               selector:#selector(base.textFieldTextChange(notification:)),
                               name: UITextField.textDidChangeNotification,
                               object: base)
        }
    }
    
    /// public method call back
    public func setHandle(_ textFieldCallBack: ((String?) -> Void)?) {
        base.swiftCallBack = textFieldCallBack
    }
    
}

//MARK: -  Extending methods for LXSwiftTextField
extension LXSwiftBasics where Base : LXSwiftTextField {
    
    ///  set textField leftView
    public func setLeftView(_ view: UIView,
                            mode: UITextField.ViewMode = .always) {
        base.leftView = view
        base.leftViewMode = mode
    }
    
    /// set textField rightView
    public func setRightView(_ view: UIView,
                             mode: UITextField.ViewMode = .always) {
        base.rightView = view
        base.rightViewMode = mode
    }
    
    /// set placeholder and color
    public func set(withPlaceholder placeholder: String?,
                    color: UIColor? = UIColor.lx.color(hex: "999999")) {
        guard let placeholder = placeholder,
              let c = color else {  return  }
        let att = NSMutableAttributedString(string: placeholder,
                                            attributes:
                                                [NSAttributedString.Key.foregroundColor: c])
        base.attributedPlaceholder = att
    }
    
    /// set placeholder and color string
    public func set(withPlaceholder placeholder: String?,
                    color: String =  "999999") {
        set(withPlaceholder: placeholder,
            color: UIColor.lx.color(hex: color))
    }
    
    /// set font and textColor
    public func set(withFont font: UIFont, textColor: UIColor?) {
        base.font = font
        if let c = textColor{
            base.textColor = c
        }
    }
    
    /// set bold font and textColor
    public func set(withBoldFont fontSize: CGFloat,
                    textColor: String) {
        set(withFont: UIFont.lx.systemFontWithBold(ofSize: fontSize),
            textColor: UIColor.lx.color(hex: textColor))
    }
    
    /// set medium font and textColor
    public func set(withMediumFont fontSize: CGFloat,
                    textColor: String) {
        set(withFont: UIFont.lx.systemFontWithMedium(ofSize: fontSize),
            textColor: UIColor.lx.color(hex: textColor))
    }
    
    /// set regular font and textColor
    public func set(withRegularFont fontSize: CGFloat,
                    textColor: String) {
        set(withFont: UIFont.lx.systemFontWithRegular(ofSize: fontSize),
            textColor: UIColor.lx.color(hex: textColor))
    }
    
    /// remove observer
    public func removeObserver() {
        NotificationCenter.default.removeObserver(base)
    }
}


//MARK: -  Extending methods for LXSwiftTextField
private var maxTextLengthKey: Void?
private var textFieldCallBackKey: Void?

extension LXSwiftTextField: LXSwiftPropertyCompatible{
    
    /// can save maxTextLength
    internal var maxTextLength: Int? {
        get { return lx_getAssociatedObject(self,
                                            &maxTextLengthKey) }
        set { lx_setRetainedAssociatedObject(self,
                                             &maxTextLengthKey,
                                             newValue,.OBJC_ASSOCIATION_ASSIGN) }
    }
    
    internal typealias T = String
    internal var swiftCallBack: SwiftCallBack? {
        get { return lx_getAssociatedObject(self,
                                            &textFieldCallBackKey) }
        set { lx_setRetainedAssociatedObject(self,
                                             &textFieldCallBackKey,
                                             newValue) }
    }
    
    /// action
    @objc internal func textFieldTextChange(notification: Notification) {
        if let maxLength = self.lx.maxLength {
            if (text?.count ?? 0) > maxLength {
                text = text?.lx.substring(to: maxLength)
            }
        }
        self.swiftCallBack?(text)
    }
}

