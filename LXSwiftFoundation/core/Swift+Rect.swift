//
//  Swift+Rect.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2017/8/5.
//

import UIKit

extension SwiftBasics where Base == CGRect {
    
    @discardableResult
    public mutating func top(with size: CGFloat) -> CGRect {
        base.origin.y = size
        return base
    }

    @discardableResult
    public mutating func bottom(with size: CGFloat) -> CGRect {
        base.origin.y = size - base.height
        return base
    }

    @discardableResult
    public mutating func right(with size: CGFloat) -> CGRect {
        base.origin.x = size - base.width
        return base
    }

    @discardableResult
    public mutating func left(with size: CGFloat) -> CGRect {
        base.origin.x = size
        return base
    }

    @discardableResult
    public mutating func width(with size: CGFloat) -> CGRect {
        base.size.width = size
        return base
    }

    @discardableResult
    public mutating func height(with size: CGFloat) -> CGRect {
        base.size.height = size
        return base
    }

    /// 获取中心点
    public var center: CGPoint {
        CGPoint(x: base.midX, y: base.midY)
    }
    
}
