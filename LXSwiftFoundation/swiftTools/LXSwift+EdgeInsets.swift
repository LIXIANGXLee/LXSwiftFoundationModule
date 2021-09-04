//
//  LXSwift+EdgeInsets.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/5/5.
//

import UIKit

extension UIEdgeInsets: LXSwiftCompatible { }

extension LXSwiftBasics where Base == UIEdgeInsets {
    
    /// 获取UIEdgeInsets在水平方向上的值
    public var horizontalValue: CGFloat {
        return base.left + base.right
    }

    /// 获取UIEdgeInsets在垂直方向上的值
    public var verticalValue: CGFloat {
        return base.top + base.bottom
    }

    /// 将两个UIEdgeInsets合并为一个
    public func concat(insets: UIEdgeInsets) -> UIEdgeInsets {
        let top = base.top + insets.top
        let left = base.left + insets.left
        let bottom = base.bottom + insets.bottom
        let right = base.right + insets.right
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }

    public mutating func set(withTop size: CGFloat) {
        base.top = LXSwiftApp.flat(size)
    }

    public mutating func set(withLeft size: CGFloat) {
        base.left = LXSwiftApp.flat(size)
    }

    public mutating func set(withBottom size: CGFloat) {
        base.bottom = LXSwiftApp.flat(size)
    }

    public mutating func set(withRight size: CGFloat) {
        base.right = LXSwiftApp.flat(size)
    }
}
