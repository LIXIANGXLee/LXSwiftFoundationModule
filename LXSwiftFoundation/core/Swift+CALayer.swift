//
//  Swift+CALayer.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/8/3.
//

import UIKit

extension SwiftBasics where Base: CALayer {
   
    /// 给CALayer上内容拍照并保存成UImage对象
    ///
    /// - Returns: 返回截屏后的UIImage对象, 如果截图失败则返回nil
    public var snapshotImage: UIImage? {
        UIGraphicsBeginImageContextWithOptions(base.bounds.size, base.isOpaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        base.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 添加边框
    public func addBorder(_ edge: UIRectEdge, color: UIColor = UIColor.lx.color(hex: "999999"), side: CGFloat = 0.5) {
        let border = CALayer()
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: base.frame.width, height: side)
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: base.frame.height - side, width: base.frame.width, height: side)
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: side, height: base.frame.height)
        case UIRectEdge.right:
            border.frame = CGRect(x: base.frame.width - side, y: 0, width: side, height: base.frame.height)
        default: break
        }
        border.backgroundColor = color.cgColor
        base.addSublayer(border)
    }
}
