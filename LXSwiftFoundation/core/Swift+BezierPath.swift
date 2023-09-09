//
//  Swift+BezierPath.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/8/3.
//

import UIKit

extension SwiftBasics where Base: UIBezierPath {
  
    /// 返回cglayer
    public func layer(with rect: CGRect) -> CALayer {
        let layer = CAShapeLayer()
        layer.frame = rect
        layer.path = base.cgPath
        return layer
    }

}


