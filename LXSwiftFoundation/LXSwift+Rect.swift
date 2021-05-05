//
//  LXSwift+Rect.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/5/5.
//

import UIKit

extension LXSwiftBasics where Base: UIView {
    
    public var x: CGFloat {
        set(num) { base.frame = CGRect(x: LXSwiftApp.flat(num),
                                       y: y,
                                       width: width,
                                       height: height) }
        get { return base.frame.origin.x }
    }
    
    public var y: CGFloat {
        set(num) { base.frame = CGRect(x: x,
                                       y: LXSwiftApp.flat(num),
                                       width: width,
                                       height: height) }
        get { return base.frame.origin.y }
    }
    
    public var width: CGFloat {
        set(num) { base.frame = CGRect(x: x,
                                       y: y,
                                       width: LXSwiftApp.flat(num),
                                       height: height) }
        get { return base.frame.size.width }
    }
    
    public var height: CGFloat {
        set(num) { base.frame = CGRect(x: x,
                                       y: y,
                                       width: width,
                                       height: LXSwiftApp.flat(num)) }
        get { return base.frame.size.height }
    }

    /// 中心点横坐标
    public var centerX: CGFloat {
        set(num) { base.frame = CGRect(x: LXSwiftApp.flat(num - width / 2),
                                       y: y,
                                  width: width,
                                  height: height) }
        get { return x + LXSwiftApp.flat(width / 2) }
    }
    
    /// 中心点纵坐标
    public var centerY: CGFloat {
        set(num) { base.frame = CGRect(x: x,
                                       y: LXSwiftApp.flat(num - height / 2),
                                  width: width,
                                  height: height) }
        get { return y + LXSwiftApp.flat(height / 2) }
    }

    /// 左边缘
    public var left: CGFloat {
        set(num) { x = LXSwiftApp.flat(num) }
        get { return base.frame.origin.x }
    }

    /// 右边缘
    public var right: CGFloat {
        set(num) { x =  LXSwiftApp.flat(num - width) }
        get { return x + width }
    }

    /// 上边缘
    public var top: CGFloat {
        set(num) { y = LXSwiftApp.flat(num) }
        get { return y }
    }

    /// 下边缘
    public var bottom: CGFloat {
        set(num) { y = LXSwiftApp.flat(num - height) }
        get { return y + height }
    }
}
