//
//  LXSwift+Label.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

//MARK: -  Extending properties for UILabel
extension LXSwiftBasics where Base: UILabel {
    
    /// 宽度
    public func width(_ width: CGFloat = LXSwiftApp.screenW) -> CGFloat {
        return size(height: CGFloat(MAXFLOAT),
                    width: width, lines: 1).width
    }
    
    ///高度
    public func height(_ width: CGFloat,
                       lines: Int) -> CGFloat {
        return size(height: height,
                    width: width, lines: lines).width
    }
   
    /// size
    public func size(height: CGFloat,
                      width: CGFloat, lines: Int) -> CGSize {
        let r = CGRect(origin: CGPoint.zero,
                          size: CGSize(width: width, height: height))
        return rect(rect: r, lines: lines).size
    }
    
    /// rect
    public func rect(rect: CGRect, lines: Int) -> CGRect {
        return base.textRect(forBounds: rect,
                             limitedToNumberOfLines: lines)
    }
    
    ///Provides a convenient way to set the properties of the label
    ///
    /// - Parameters:
    ///- Font: set font
    ///- textcolor: set text color
    ///- alignment: set the text alignment method
    public func set(withFont font: UIFont, textColor: UIColor,
                    alignment: NSTextAlignment? = nil) {
        base.font = font
        base.textColor = textColor
        if let alignment = alignment {
            base.textAlignment = alignment
        }
    }
    
    ///Provides a convenient way to set the properties of the label
    ///
    /// - Parameters:
    ///- Font: set regularSize
    ///- textcolor: set text color
    ///- alignment: set the text alignment method
    public func set(regularSize: CGFloat, textColor: String,
                    alignment: NSTextAlignment? = nil) {
        let color = UIColor.lx.color(hex: textColor)
        set(withFont: UIFont.lx.fontWithRegular(regularSize),
            textColor: color,
            alignment: alignment)
    }
    
    ///Provides a convenient way to set the properties of the label
    ///
    /// - Parameters:
    ///- Font: set mediumSize
    ///- textcolor: set text color
    ///- alignment: set the text alignment method
    public func set(mediumSize: CGFloat, textColor: String,
                    alignment: NSTextAlignment? = nil) {
        let color = UIColor.lx.color(hex: textColor)
        set(withFont: UIFont.lx.fontWithMedium(mediumSize),
            textColor: color,
            alignment: alignment)
    }
    
   ///Provides a convenient way to set the properties of the label
   ///
   /// - Parameters:
   ///- Font: set boldSize
   ///- textcolor: set text color
   ///- alignment: set the text alignment method
   public func set(boldSize: CGFloat, textColor: String,
                   alignment: NSTextAlignment? = nil) {
       let color = UIColor.lx.color(hex: textColor)
       set(withFont: UIFont.lx.fontWithBold(boldSize),
           textColor: color,
           alignment: alignment)
   }
}
