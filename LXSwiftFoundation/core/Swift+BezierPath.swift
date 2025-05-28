//
//  Swift+BezierPath.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/8/3.
//

import UIKit

extension SwiftBasics where Base: UIBezierPath {
    
    /// 将UIBezierPath转换为CALayer
    /// - Parameter rect: 指定Layer的frame矩形区域
    /// - Returns: 返回一个包含该路径的CAShapeLayer
    ///
    /// 使用说明：
    /// 1. 此方法会创建一个新的CAShapeLayer
    /// 2. 将UIBezierPath的CGPath赋值给layer的path属性
    /// 3. 设置layer的frame为传入的rect参数
    /// 4. 适用于需要将矢量路径转换为图层进行动画或显示的场景
    public func layer(with rect: CGRect) -> CALayer {
        // 创建形状图层
        let layer = CAShapeLayer()
        
        // 设置图层的框架尺寸
        layer.frame = rect
        
        // 将UIBezierPath转换为CGPath并赋值给图层
        layer.path = base.cgPath
        
        return layer
    }
}
