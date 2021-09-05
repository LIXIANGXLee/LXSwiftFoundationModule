//
//  LXSwift+Label.swift
//  LXSwiftFoundation
//
//  Created by XL on 2017/9/24.
//  Copyright © 2017 李响. All rights reserved.
//

import UIKit

//MARK: -  Extending properties for UILabel
extension LXSwiftBasics where Base: UILabel {
    
    /// 宽度
    public func width(_ width: CGFloat = LXSwiftApp.screenW) -> CGFloat {
        return size(height: CGFloat(MAXFLOAT), width: width, lines: 1).width
    }
    
    /// 高度
    public func height(_ width: CGFloat, lines: Int) -> CGFloat {
        return size(height: height, width: width, lines: lines).width
    }
   
    /// size 大小
    public func size(height: CGFloat, width: CGFloat, lines: Int) -> CGSize {
        let r = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height))
        return rect(rect: r, lines: lines).size
    }
    
    /// rect 尺寸
    public func rect(rect: CGRect, lines: Int) -> CGRect {
        return base.textRect(forBounds: rect, limitedToNumberOfLines: lines)
    }
    
    /// 提供了设置标签属性的方便方法（颜色、字体大小、对齐方式）
    public func set(withFont font: UIFont, textColor: UIColor, alignment: NSTextAlignment? = nil) {
        base.font = font
        base.textColor = textColor
        if let alignment = alignment {
            base.textAlignment = alignment
        }
    }
    
    /// 提供了设置标签属性的方便方法（颜色、字体大小、对齐方式）
    public func set(regularSize: CGFloat, textColor: String, alignment: NSTextAlignment? = nil) {
        let color = UIColor.lx.color(hex: textColor)
        set(withFont: UIFont.lx.font(withRegular: regularSize),
            textColor: color, alignment: alignment)
    }
    
    /// 提供了设置标签属性的方便方法（颜色、字体大小、对齐方式）
    public func set(mediumSize: CGFloat, textColor: String, alignment: NSTextAlignment? = nil) {
        let color = UIColor.lx.color(hex: textColor)
        set(withFont: UIFont.lx.font(withMedium: mediumSize),
            textColor: color, alignment: alignment)
    }
    
    /// 提供了设置标签属性的方便方法（颜色、字体大小、对齐方式）
   public func set(boldSize: CGFloat, textColor: String, alignment: NSTextAlignment? = nil) {
       let color = UIColor.lx.color(hex: textColor)
       set(withFont: UIFont.lx.font(withBold: boldSize),
           textColor: color, alignment: alignment)
   }
}
