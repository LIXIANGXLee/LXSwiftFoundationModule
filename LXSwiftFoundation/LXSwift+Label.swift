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
   
        /// w
        public var bestWidth: CGFloat {
            return base.sizeThatFits(CGSize.zero).width
        }
       
        /// h
        public var bestHeight: CGFloat {
           return base.sizeThatFits(CGSize.zero).height
        }
    
       ///Provides a convenient way to set the properties of the label
       ///
       /// - Parameters:
       ///- Font: set font
       ///- textcolor: set text color
       ///- alignment: set the text alignment method
       public func set(font: UIFont, textColor: UIColor, alignment: NSTextAlignment? = nil) {
           base.font = font
           base.textColor = textColor
           //当对齐方式不为空时候,重置对齐方式
           guard let alignment = alignment else { return }
           base.textAlignment = alignment
       }
    
}
