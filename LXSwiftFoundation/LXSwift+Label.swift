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
    public var bestWidth: CGFloat {
        return base.sizeThatFits(CGSize.zero).width
    }
    
    /// 高度
    public var bestHeight: CGFloat {
        return base.sizeThatFits(CGSize.zero).height
    }
    
    ///Provides a convenient way to set the properties of the label
    ///
    /// - Parameters:
    ///- Font: set font
    ///- textcolor: set text color
    ///- alignment: set the text alignment method
    public func set(withFont font: UIFont,
                    textColor: UIColor,
                    alignment: NSTextAlignment? = nil) {
        base.font = font
        base.textColor = textColor
        guard let alignment = alignment else { return }
        base.textAlignment = alignment
    }
    
    ///Provides a convenient way to set the properties of the label
    ///
    /// - Parameters:
    ///- Font: set regularSize
    ///- textcolor: set text color
    ///- alignment: set the text alignment method
    public func set(regularSize: CGFloat,
                    textColor: String,
                    alignment: NSTextAlignment? = nil) {
        let color = UIColor.lx.color(hex: textColor)
        set(withFont: UIFont.systemFont(ofSize: regularSize,
                                        weight: .regular),
            textColor: color,
            alignment: alignment)
    }
    
    ///Provides a convenient way to set the properties of the label
    ///
    /// - Parameters:
    ///- Font: set mediumSize
    ///- textcolor: set text color
    ///- alignment: set the text alignment method
    public func set(mediumSize: CGFloat,
                    textColor: String,
                    alignment: NSTextAlignment? = nil) {
        let color = UIColor.lx.color(hex: textColor)
        set(withFont: UIFont.systemFont(ofSize: mediumSize,
                                        weight: .medium),
            textColor: color,
            alignment: alignment)
    }
    
   ///Provides a convenient way to set the properties of the label
   ///
   /// - Parameters:
   ///- Font: set boldSize
   ///- textcolor: set text color
   ///- alignment: set the text alignment method
   public func set(boldSize: CGFloat,
                   textColor: String,
                   alignment: NSTextAlignment? = nil) {
       let color = UIColor.lx.color(hex: textColor)
       set(withFont: UIFont.systemFont(ofSize: boldSize,
                                       weight: .bold),
           textColor: color,
           alignment: alignment)
   }
    
}
