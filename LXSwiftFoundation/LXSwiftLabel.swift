//
//  LXSwiftLabel.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

open class LXSwiftLabel: UILabel {
    open var swiftModel: Any?
   
    private var padding = UIEdgeInsets.zero
    @IBInspectable
    public var paddingLeft: CGFloat {
       get { return padding.left }
       set { padding.left = newValue }
    }
   
    @IBInspectable
    public var paddingRight: CGFloat {
       get { return padding.right }
       set { padding.right = newValue }
    }
   
    @IBInspectable
    public var paddingTop: CGFloat {
       get { return padding.top }
       set { padding.top = newValue }
    }
   
    @IBInspectable
    public var paddingBottom: CGFloat {
       get { return padding.bottom }
       set { padding.bottom = newValue }
    }
   
    open override func drawText(in rect: CGRect) {
       super.drawText(in: rect.inset(by: padding))
    }

    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
     let insets = self.padding
     var rect = super.textRect(forBounds: bounds.inset(by: insets), limitedToNumberOfLines: numberOfLines)
        rect.origin.x    -= insets.left
        rect.origin.y    -= insets.top
        rect.size.width  += (insets.left + insets.right)
        rect.size.height += (insets.top + insets.bottom)
        return rect
    }

}

