//
//  Swift+View.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import WebKit

//MARK: - UIView 扩展属性
extension SwiftBasics where Base: UIView {
    
    /// 获取应用的根导航控制器
    public var rootNavViewController: UINavigationController? {
        UIApplication.lx.rootNavViewController
    }
    
    /// 获取应用的根视图控制器
    public static var rootViewController: UIViewController? {
        UIApplication.lx.rootViewController
    }
    
    /// 获取包含当前视图的控制器
    public static func currentViewController(ofView view: UIView) -> UIViewController? {
        UIApplication.lx.currentViewController(ofView: view)
    }
    
    /// 获取应用的主窗口
    public var rootWindow: UIWindow? {
        UIApplication.lx.rootWindow
    }
 
    /// 获取应用最顶层的窗口（排除键盘窗口）
    public static var lastWindow: UIWindow? {
        UIApplication.lx.lastWindow
    }

    /// 生成当前视图的快照图像
    /// - 注意：针对 WKWebView 做了特殊处理
    public var snapShotImage: UIImage? {
        // 创建图像上下文
        UIGraphicsBeginImageContextWithOptions(base.bounds.size, base.isOpaque, 0)
        defer { UIGraphicsEndImageContext() } // 确保结束后释放上下文
        
        if isContainsWKWebView() {
            // 使用层级绘制（适用于 WKWebView）
            base.drawHierarchy(in: base.bounds, afterScreenUpdates: true)
        } else {
            // 使用图层渲染（常规视图）
            base.layer.render(in: UIGraphicsGetCurrentContext()!)
        }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// 检查当前视图或其子视图是否包含 WKWebView
    /// - 用于快照时选择正确的渲染方式
    private func isContainsWKWebView() -> Bool {
        // 当前视图是 WKWebView
        if base.isKind(of: WKWebView.self) {
            return true
        }
        // 递归检查子视图
        for subView in base.subviews {
            if subView.lx.isContainsWKWebView() {
                return true
            }
        }
        return false
    }
}

//MARK: - 视图样式扩展
extension SwiftBasics where Base: UIView {
  
    /// 设置渐变背景
    /// - Parameters:
    ///   - colors: 渐变色数组
    ///   - locations: 颜色位置 (默认 [0.0, 1.0])
    ///   - startPoint: 渐变起点 (默认 (0, 0.5))
    ///   - endPoint: 渐变终点 (默认 (1, 0.5))
    ///   - size: 渐变层尺寸 (默认使用视图尺寸)
    public func setGradientLayer(
        with colors: [UIColor],
        locations: [NSNumber] = [0.0, 1.0],
        startPoint: CGPoint = CGPoint(x: 0, y: 0.5),
        endPoint: CGPoint = CGPoint(x: 1, y: 0.5),
        size: CGSize? = nil
    ) {
        let targetSize = size ?? base.bounds.size
        guard !targetSize.equalTo(.zero) else { return }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: .zero, size: targetSize)
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        // 插入到视图最底层
        base.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /// 设置视图阴影
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - radius: 阴影模糊半径
    ///   - opacity: 阴影透明度 (0-1)
    ///   - offset: 阴影偏移量 (默认 .zero)
    public func setShadow(
        color: UIColor,
        radius: CGFloat,
        opacity: Float,
        offset: CGSize = .zero
    ) {
        base.layer.shadowColor = color.cgColor
        base.layer.shadowRadius = radius
        base.layer.shadowOpacity = opacity
        base.layer.shadowOffset = offset
    }
    
    /// 移除视图阴影
    public func removeShadow() {
        base.layer.shadowOpacity = 0
    }
    
    /// 设置视图边框
    /// - Parameters:
    ///   - width: 边框宽度
    ///   - color: 边框颜色
    ///   - cornerRadius: 圆角半径 (可选)
    public func setBorder(
        width: CGFloat,
        color: UIColor,
        cornerRadius: CGFloat? = nil
    ) {
        base.layer.borderWidth = width
        base.layer.borderColor = color.cgColor
        
        if let radius = cornerRadius {
            base.layer.cornerRadius = radius
        }
    }
    
    /// 设置统一圆角
    /// - Parameters:
    ///   - radius: 圆角半径 (默认 4)
    ///   - clips: 是否裁剪超出部分 (默认 true)
    public func setCornerRadius(radius: CGFloat = 4, clips: Bool = true) {
        base.layer.cornerRadius = radius
        base.layer.masksToBounds = clips
    }
    
    /// 设置部分圆角
    /// - Parameters:
    ///   - radius: 圆角半径 (默认 4)
    ///   - roundingCorners: 需要设置的角
    ///   - viewSize: 自定义尺寸 (默认使用视图当前尺寸)
    public func setPartCornerRadius(
        radius: CGFloat = 4,
        roundingCorners: UIRectCorner = .allCorners,
        viewSize: CGSize? = nil
    ) {
        let targetSize = viewSize ?? base.bounds.size
        guard !targetSize.equalTo(.zero) else { return }
        
        let bezierPath = UIBezierPath(
            roundedRect: CGRect(origin: .zero, size: targetSize),
            byRoundingCorners: roundingCorners,
            cornerRadii: CGSize(width: radius, height: radius))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        base.layer.mask = shapeLayer
    }
}

//MARK: - 视图布局快捷属性
extension SwiftBasics where Base: UIView {
    
    /// 视图的 X 坐标
    public var x: CGFloat {
        get { base.frame.origin.x }
        set { base.frame.origin.x = newValue }
    }
    
    /// 视图的 Y 坐标
    public var y: CGFloat {
        get { base.frame.origin.y }
        set { base.frame.origin.y = newValue }
    }
    
    /// 视图宽度
    public var width: CGFloat {
        get { base.frame.size.width }
        set { base.frame.size.width = newValue }
    }
    
    /// 视图高度
    public var height: CGFloat {
        get { base.frame.size.height }
        set { base.frame.size.height = newValue }
    }

    /// 视图中心点 X 坐标
    public var centerX: CGFloat {
        get { base.center.x }
        set { base.center.x = newValue }
    }
    
    /// 视图中心点 Y 坐标
    public var centerY: CGFloat {
        get { base.center.y }
        set { base.center.y = newValue }
    }

    /// 视图左边界
    public var left: CGFloat {
        get { x }
        set { x = newValue }
    }

    /// 视图右边界
    public var right: CGFloat {
        get { x + width }
        set { x = newValue - width }
    }

    /// 视图上边界
    public var top: CGFloat {
        get { y }
        set { y = newValue }
    }

    /// 视图下边界
    public var bottom: CGFloat {
        get { y + height }
        set { y = newValue - height }
    }
}
