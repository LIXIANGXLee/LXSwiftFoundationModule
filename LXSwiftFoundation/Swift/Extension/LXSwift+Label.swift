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
    
    /// UILabel的宽度
    public func width(_ width: CGFloat = LXSwiftApp.screenW) -> CGFloat { size(height: CGFloat(MAXFLOAT), width: width, lines: 1).width }
    
    /// UILabel的高度
    public func height(_ width: CGFloat, lines: Int) -> CGFloat { size(height: height, width: width, lines: lines).width }
   
    /// UILabel的size 大小
    public func size(height: CGFloat, width: CGFloat, lines: Int) -> CGSize { rect(CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height)), lines: lines).size }
    
    /// UILabel的rect 尺寸
    public func rect(_ rect: CGRect, lines: Int) -> CGRect { base.textRect(forBounds: rect, limitedToNumberOfLines: lines) }
    
    /// 提供了设置标签属性的方便方法（颜色、字体大小、对齐方式）
    public func set(withFont font: UIFont, textColor: UIColor, alignment: NSTextAlignment? = nil) {
        base.font = font
        base.textColor = textColor
        if let alignment = alignment { base.textAlignment = alignment }
    }
    
    /// 提供了设置标签属性的方便方法（颜色、字体大小、对齐方式）
    public func set(regularSize: CGFloat, textColor: String, alignment: NSTextAlignment? = nil) { set(withFont: UIFont.lx.font(withRegular: regularSize),
            textColor: UIColor.lx.color(hex: textColor), alignment: alignment) }
    
    /// 提供了设置标签属性的方便方法（颜色、字体大小、对齐方式）
    public func set(mediumSize: CGFloat, textColor: String, alignment: NSTextAlignment? = nil) { set(withFont: UIFont.lx.font(withMedium: mediumSize),
            textColor: UIColor.lx.color(hex: textColor), alignment: alignment) }
    
    /// 提供了设置标签属性的方便方法（颜色、字体大小、对齐方式）
   public func set(boldSize: CGFloat, textColor: String, alignment: NSTextAlignment? = nil) { set(withFont: UIFont.lx.font(withBold: boldSize), textColor: UIColor.lx.color(hex: textColor), alignment: alignment) }
    
    /// 提供了设置标签属性的方便方法（颜色、字体大小、对齐方式）
    public func set(semiboldSize: CGFloat, textColor: String, alignment: NSTextAlignment? = nil) { set(withFont: UIFont.lx.font(withSemibold: semiboldSize), textColor: UIColor.lx.color(hex: textColor), alignment: alignment) }
     
    /// 提供了设置标签属性的方便方法（颜色、字体大小、对齐方式）
    public func set(heavySize: CGFloat, textColor: String, alignment: NSTextAlignment? = nil) { set(withFont: UIFont.lx.font(withHeavy: heavySize), textColor: UIColor.lx.color(hex: textColor), alignment: alignment) }
}
