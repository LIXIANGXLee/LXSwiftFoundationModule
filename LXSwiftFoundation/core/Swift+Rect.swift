//
//  Swift+Rect.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2017/8/5.
//
import UIKit

// 定义一个泛型扩展，限定 Base 类型为 CGRect
extension SwiftBasics where Base == CGRect {
    
    // MARK: - 位置调整方法
    
    /// 设置矩形顶部位置（保持高度不变）
    /// - Parameter size: 顶部边缘的 y 坐标值
    /// - Returns: 调整后的 CGRect
    @discardableResult
    public mutating func top(with size: CGFloat) -> CGRect {
        base.origin.y = size
        return base
    }

    /// 设置矩形底部位置（保持高度不变）
    /// - Parameter size: 底部边缘的 y 坐标值
    /// - Returns: 调整后的 CGRect
    @discardableResult
    public mutating func bottom(with size: CGFloat) -> CGRect {
        base.origin.y = size - base.height
        return base
    }

    /// 设置矩形右侧位置（保持宽度不变）
    /// - Parameter size: 右侧边缘的 x 坐标值
    /// - Returns: 调整后的 CGRect
    @discardableResult
    public mutating func right(with size: CGFloat) -> CGRect {
        base.origin.x = size - base.width
        return base
    }

    /// 设置矩形左侧位置（保持宽度不变）
    /// - Parameter size: 左侧边缘的 x 坐标值
    /// - Returns: 调整后的 CGRect
    @discardableResult
    public mutating func left(with size: CGFloat) -> CGRect {
        base.origin.x = size
        return base
    }

    // MARK: - 尺寸调整方法
    
    /// 设置矩形宽度（保持原点不变）
    /// - Parameter size: 新的宽度值
    /// - Returns: 调整后的 CGRect
    @discardableResult
    public mutating func width(with size: CGFloat) -> CGRect {
        base.size.width = size
        return base
    }

    /// 设置矩形高度（保持原点不变）
    /// - Parameter size: 新的高度值
    /// - Returns: 调整后的 CGRect
    @discardableResult
    public mutating func height(with size: CGFloat) -> CGRect {
        base.size.height = size
        return base
    }

    // MARK: - 计算属性
    
    /// 获取矩形中心点坐标
    public var center: CGPoint {
        CGPoint(x: base.midX, y: base.midY)
    }
    
    // MARK: - 新增功能建议
    
    /// 设置矩形中心点 x 坐标（保持宽度不变）
    /// - Parameter x: 新的中心点 x 坐标
    /// - Returns: 调整后的 CGRect
    @discardableResult
    public mutating func centerX(with x: CGFloat) -> CGRect {
        base.origin.x = x - base.width / 2
        return base
    }
    
    /// 设置矩形中心点 y 坐标（保持高度不变）
    /// - Parameter y: 新的中心点 y 坐标
    /// - Returns: 调整后的 CGRect
    @discardableResult
    public mutating func centerY(with y: CGFloat) -> CGRect {
        base.origin.y = y - base.height / 2
        return base
    }
    
    /// 设置矩形中心点（保持尺寸不变）
    /// - Parameter center: 新的中心点坐标
    /// - Returns: 调整后的 CGRect
    @discardableResult
    public mutating func center(with center: CGPoint) -> CGRect {
        base.origin.x = center.x - base.width / 2
        base.origin.y = center.y - base.height / 2
        return base
    }
}
