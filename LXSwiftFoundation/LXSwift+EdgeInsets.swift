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

    public mutating func setTop(_ top: CGFloat) {
        base.top = LXSwiftApp.flat(top)
    }

    public mutating func setLeft(_ left: CGFloat) {
        base.left = LXSwiftApp.flat(left)
    }

    public mutating func setBottom(_ bottom: CGFloat) {
        base.bottom = LXSwiftApp.flat(bottom)
    }

    public mutating func setRight(_ right: CGFloat) {
        base.right = LXSwiftApp.flat(right)
    }
}
