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

    open override func textRect(forBounds bounds: CGRect,
                                limitedToNumberOfLines numberOfLines: Int) -> CGRect {
     var rect = super.textRect(forBounds: bounds.inset(by: self.padding),
                               limitedToNumberOfLines: numberOfLines)
        rect.origin.x    -= self.padding.left
        rect.origin.y    -= self.padding.top
        rect.size.width  += (self.padding.left + self.padding.right)
        rect.size.height += (self.padding.top + self.padding.bottom)
        return rect
    }

}

