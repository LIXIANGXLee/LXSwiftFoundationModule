//
//  LXSwift+TextView.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/29.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

//MARK: -  Extending properties and methods for LXSwiftTextView
extension LXSwiftBasics where Base: LXSwiftTextView {
    
    /// 设置字体和文本颜色
    public func set(with font: UIFont, textColor: UIColor?) {
        base.font = font
        if let color = textColor { base.textColor = color }
    }
    
    /// 设置粗体字体和文本颜色
    public func set(withBold fontSize: CGFloat, textColor: String) { set(with: UIFont.lx.font(withBold: fontSize), textColor: UIColor.lx.color(hex: textColor)) }
    
    /// 设置中等字体和文本颜色
    public func set(withMedium fontSize: CGFloat, textColor: String) { set(with: UIFont.lx.font(withMedium: fontSize), textColor: UIColor.lx.color(hex: textColor)) }
    
    /// 设置常规字体和文本颜色
    public func set(withRegular fontSize: CGFloat, textColor: String) { set(with: UIFont.lx.font(withRegular: fontSize), textColor: UIColor.lx.color(hex: textColor)) }

}
