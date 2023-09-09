//
//  Swift+TextField.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/9/28.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

//MARK: -  Extending methods for UITextField
extension SwiftBasics where Base: UITextField {
    
    /// 设置占位符和颜色
    public func set(withPlaceholder placeholder: String?,
                    color: UIColor = UIColor.lx.color(hex: "999999"),
                    font: UIFont = UIFont.lx.font(withRegular: 14)) {
        guard let placeholder = placeholder else { return }
        let attributes = [NSAttributedString.Key.foregroundColor: color,
                          NSAttributedString.Key.font: font]
        base.attributedPlaceholder = NSMutableAttributedString(string: placeholder, attributes: attributes)
    }
    
    /// 设置占位符和颜色字符串
    public func set(withPlaceholder placeholder: String?,
                    color: String = "999999",
                    fontSize: CGFloat = 14) {
        set(withPlaceholder: placeholder,
            color: UIColor.lx.color(hex: color),
            font: UIFont.lx.font(withRegular: fontSize))
    }
    
    /// 设置字体和文本颜色
    public func set(with font: UIFont, textColor: UIColor?) {
        base.font = font
        if let color = textColor {
            base.textColor = color
        }
    }
    
    /// 设置粗体字体和文本颜色
    public func set(withBold fontSize: CGFloat, textColor: String) {
        set(with: UIFont.lx.font(withBold: fontSize),
            textColor: UIColor.lx.color(hex: textColor))
    }
    
    /// 设置中等字体和文本颜色
    public func set(withMedium fontSize: CGFloat, textColor: String) {
        set(with: UIFont.lx.font(withMedium: fontSize),
            textColor: UIColor.lx.color(hex: textColor))
    }
    
    /// 设置常规字体和文本颜色
    public func set(withRegular fontSize: CGFloat, textColor: String) {
        set(with: UIFont.lx.font(withRegular: fontSize),
            textColor: UIColor.lx.color(hex: textColor))
    }
}

//MARK: -  Extending methods for UITextField
extension SwiftBasics where Base: UITextField {
    
    /// 设置文本字段左视图
    public func setLeftView(with view: UIView, mode: UITextField.ViewMode = .always) {
        base.leftView = view
        base.leftViewMode = mode
    }
    
    /// 设置文本字段右视图
    public func setRightView(with view: UIView, mode: UITextField.ViewMode = .always) {
        base.rightView = view
        base.rightViewMode = mode
    }
}
