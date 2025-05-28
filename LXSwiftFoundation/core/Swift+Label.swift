//
//  Swift+Label.swift
//  LXSwiftFoundation
//
//  Created by XL on 2017/9/24.
//  Copyright © 2017 李响. All rights reserved.
//

import UIKit

//MARK: -  Extending properties for UILabel
extension SwiftBasics where Base: UILabel {
    
    /// UILabel的宽度
    public func width(_ width: CGFloat = SCREEN_WIDTH_TO_WIDTH) -> CGFloat {
        size(height: CGFloat(MAXFLOAT), width: width, lines: 1).width
    }
    
    /// UILabel的高度
    public func height(_ width: CGFloat, lines: Int) -> CGFloat {
        size(height: height, width: width, lines: lines).width
    }
   
    /// UILabel的size 大小
    public func size(height: CGFloat, width: CGFloat, lines: Int) -> CGSize {
        rect(CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height)), lines: lines).size
    }
    
    /// UILabel的rect 尺寸
    public func rect(_ rect: CGRect, lines: Int) -> CGRect {
        base.textRect(forBounds: rect, limitedToNumberOfLines: lines)
    }
    
}
