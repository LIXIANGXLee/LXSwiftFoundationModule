//
//  Swift+CALayer.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/8/3.
//

import UIKit

extension SwiftBasics where Base: CALayer {
    
    /// 对 CALayer 的内容进行截图并转换为 UIImage 对象
    ///
    /// - 返回值: 截图后的 UIImage 对象，如果截图失败则返回 nil
    /// - 注意事项: 此方法会创建一个与 layer 相同大小的图像上下文
    public var snapshotImage: UIImage? {
        // 创建图像上下文，大小与 layer 相同，透明度和设备缩放比例适配
        UIGraphicsBeginImageContextWithOptions(base.bounds.size, base.isOpaque, 0)
        defer { UIGraphicsEndImageContext() } // 确保在方法结束时关闭图像上下文
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        // 将 layer 内容渲染到图像上下文中
        base.render(in: context)
        
        // 从当前图像上下文中获取图像
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// 为 CALayer 添加指定边缘的边框
    ///
    /// - 参数:
    ///   - edge: 要添加边框的边缘位置（上、下、左、右）
    ///   - color: 边框颜色，默认为黑色
    ///   - thickness: 边框厚度，默认为 0.5 点
    /// - 注意事项: 此方法会创建一个新的 CALayer 作为边框并添加到目标 layer 上
    public func addBorder(_ edge: UIRectEdge, color: UIColor = .black, thickness: CGFloat = 0.5) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        
        // 根据边缘位置设置边框 frame
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0,
                                width: base.bounds.width,
                                height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0,
                                y: base.bounds.height - thickness,
                                width: base.bounds.width,
                                height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0,
                                 width: thickness,
                                 height: base.bounds.height)
        case .right:
            border.frame = CGRect(x: base.bounds.width - thickness, y: 0,
                                width: thickness,
                                height: base.bounds.height)
        default:
            // 对于不支持的多边缘情况，不做任何操作
            return
        }
        
        base.addSublayer(border)
    }
}
