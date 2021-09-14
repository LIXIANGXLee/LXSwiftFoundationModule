//
//  LXSwiftLabel.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// 可设置文字内边距
@objc(LXObjcLabel)
@objcMembers open class LXSwiftLabel: UILabel {
  
    /// 方便携带的参数 有的时候可能想自定义一些参数，做为传参作用
    @objc(objcModel) open var swiftModel: Any?
   
    private var padding = UIEdgeInsets.zero
    @IBInspectable
    open var paddingLeft: CGFloat {
       get { padding.left }
       set { padding.left = newValue }
    }
   
    @IBInspectable
    open var paddingRight: CGFloat {
       get { padding.right }
       set { padding.right = newValue }
    }
   
    @IBInspectable
    open var paddingTop: CGFloat {
       get { padding.top }
       set { padding.top = newValue }
    }
   
    @IBInspectable
    open var paddingBottom: CGFloat {
       get { padding.bottom }
       set { padding.bottom = newValue }
    }
   
    open override func drawText(in rect: CGRect) { super.drawText(in: rect.inset(by: padding)) }

    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRect(forBounds: bounds.inset(by: self.padding), limitedToNumberOfLines: numberOfLines)
        rect.origin.x    -= self.padding.left
        rect.origin.y    -= self.padding.top
        rect.size.width  += (self.padding.left + self.padding.right)
        rect.size.height += (self.padding.top + self.padding.bottom)
        return rect
    }
}

