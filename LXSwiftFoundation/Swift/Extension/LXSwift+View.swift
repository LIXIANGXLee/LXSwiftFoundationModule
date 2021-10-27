//
//  LXSwift+View.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import WebKit

extension UIView: LXSwiftCompatible { }

//MARK: -  Extending properties for UIView
extension LXSwiftBasics where Base: UIView {
    
    /// presented 根视图
    public var presentView: UIView? { UIApplication.lx.presentViewController?.view }
    
    /// 当前的view
    public var visibleVCView: UIView? { UIApplication.lx.visibleViewController?.view }
    
    /// 导航跟控制器
    public var visibleNavVC: UINavigationController? { UIApplication.lx.visibleNavRootViewController }
    
    /// 获取跟窗口
    public var rootWindow: UIWindow? { UIApplication.lx.rootWindow }
    
    /// 获取定制化跟窗口
    public static var scheduledLastWindow: UIWindow? { UIApplication.lx.scheduledLastWindow }
    
    /// 获取最外层窗口 需要判断不是UIRemoteKeyboardWindow才行，否则在ipad会存在问题
    public static var lastWindow: UIWindow? { UIApplication.lx.lastWindow }
 
    /// view截图
    public var snapShotImage: UIImage? {
        UIGraphicsBeginImageContextWithOptions(base.bounds.size, base.isOpaque, 0)
        if isContainsWKWebView() {
            base.drawHierarchy(in: base.bounds, afterScreenUpdates: true)
        } else {
            if let ctx = UIGraphicsGetCurrentContext() { base.layer.render(in: ctx) }
        }
        let snapImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapImage
    }
    
    /// 快照管理器，修复wkwebview屏幕截图错误。
    public func isContainsWKWebView() -> Bool {
        if base.isKind(of: WKWebView.self) { return true }
        for subView in base.subviews {
            if (subView.lx.isContainsWKWebView()) { return true }
        }
        return false
    }
    
    /// 打开url
    @inline(__always)
    public static func openUrl(_ urlStr: String, completionHandler: ((Bool) -> Void)? = nil) { UIApplication.lx.openUrl(urlStr, completionHandler: completionHandler) }
    
    /// 已经进入App
    @inline(__always)
    public func didBecomeActive(_ aSelector: Selector) { LXSwiftUtils.didBecomeActive(base, selector: aSelector) }
    
    /// 即将退出App
    @inline(__always)
    public func willResignActive(_ aSelector: Selector) { LXSwiftUtils.willResignActive(base, selector: aSelector) }
    
    /// 监听键盘即将弹起
    @inline(__always)
    public func keyboardWillShow(_ aSelector: Selector) { LXSwiftUtils.keyboardWillShow(base, selector: aSelector) }
    
    /// 监听键盘已经弹起
    @inline(__always)
    public func keyboardDidShow(_ aSelector: Selector) { LXSwiftUtils.keyboardDidShow(base, selector: aSelector) }
    
    /// 监听键盘即将退下
    @inline(__always)
    public func keyboardWillHide(_ aSelector: Selector) { LXSwiftUtils.keyboardWillHide(base, selector: aSelector) }
    
    /// 监听键盘已经退下
    @inline(__always)
    public func keyboardDidHide(_ aSelector: Selector) { LXSwiftUtils.keyboardDidHide(base, selector: aSelector) }
}

//MARK: -  Extending methods for UIView
extension LXSwiftBasics where Base: UIView {
  
    /// view 渐变色 size如果设置尺寸的话 则使用其尺寸，如果没有设置则使用view的尺寸
    public func setGradientLayer(with colors: [UIColor],
                                 locations: [NSNumber] = [0.0,1.0],
                                 startPoint: CGPoint = CGPoint(x: 0, y: 0.5),
                                 endPoint: CGPoint = CGPoint(x: 1, y: 0.5),
                                 size: CGSize? = nil){
        
        let s = size ?? base.bounds.size
        if !s.equalTo(CGSize.zero) {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = CGRect(origin: base.bounds.origin, size: s)
            base.layer.insertSublayer(gradientLayer, at: 0)
            gradientLayer.colors = colors.map{ $0.cgColor }
            gradientLayer.locations = locations
            gradientLayer.startPoint = startPoint
            gradientLayer.endPoint = endPoint
        }
    }
    
    /// view 的阴影
    public func setShadow(color: UIColor, radius: CGFloat, opacity: Float, offset: CGSize = CGSize.zero) {
        base.layer.shadowColor = color.cgColor
        base.layer.shadowRadius = radius
        base.layer.shadowOpacity = opacity
        base.layer.shadowOffset = offset
    }
    
    /// 移除阴影
    public func removeShadow() { base.layer.shadowOpacity = 0.0 }
    
    /// view 边框
    public func setBorder(width: CGFloat, color: UIColor, cornerRadius: CGFloat? = nil) {
        base.layer.borderWidth = width
        base.layer.borderColor = color.cgColor
        if let cornerRadius = cornerRadius {
            base.layer.cornerRadius = cornerRadius
        }
    }
    
    /// 圆角
    public func setCornerRadius(radius: CGFloat = 4.0, clips: Bool = true) {
        base.layer.cornerRadius = radius
        base.layer.masksToBounds = clips
    }
    
    /// 圆角 cornerRadius(topLeft topRight bottomLeft bottomRight)
    ///
    /// - Parameters:
    ///   - cornerRadii: radius size
    ///   - roundingCorners: UIRectCorner(rawValue:
    ///   (UIRectCorner.topRight.rawValue) | (UIRectCorner.bottomRight.rawValue))
    ///   - viewSize: size of the current view
    public func setPartCornerRadius(radius: CGFloat = 4.0, roundingCorners: UIRectCorner = .allCorners, viewSize: CGSize? = nil) {
        
        let s = viewSize ?? base.bounds.size
        let rect = CGRect(origin: CGPoint.zero, size: s)
        let bezierPath = UIBezierPath(roundedRect: rect,
                                     byRoundingCorners: roundingCorners,
                                     cornerRadii: CGSize(width: radius, height: radius))
        if !s.equalTo(CGSize.zero) {
            let rect = CGRect(origin: base.bounds.origin, size: s)
            base.layer.mask = bezierPath.lx.layer(with: rect)
        }
    }
}

//MARK: -  快捷设置view尺寸
extension LXSwiftBasics where Base: UIView {
    
    public var x: CGFloat {
        set(num) { base.frame = CGRect(x: LXSwiftApp.flat(num), y: y, width: width, height: height) }
        get { base.frame.origin.x }
    }
    
    public var y: CGFloat {
        set(num) { base.frame = CGRect(x: x, y: LXSwiftApp.flat(num), width: width, height: height) }
        get { base.frame.origin.y }
    }
    
    public var width: CGFloat {
        set(num) { base.frame = CGRect(x: x, y: y, width: LXSwiftApp.flat(num), height: height) }
        get { base.frame.size.width }
    }
    
    public var height: CGFloat {
        set(num) { base.frame = CGRect(x: x, y: y, width: width, height: LXSwiftApp.flat(num)) }
        get { base.frame.size.height }
    }

    /// 中心点横坐标
    public var centerX: CGFloat {
        set(num) { base.frame = CGRect(x: LXSwiftApp.flat(num - width / 2), y: y, width: width, height: height) }
        get { x + LXSwiftApp.flat(width / 2) }
    }
    
    /// 中心点纵坐标
    public var centerY: CGFloat {
        set(num) { base.frame = CGRect(x: x, y: LXSwiftApp.flat(num - height / 2), width: width, height: height) }
        get { y + LXSwiftApp.flat(height / 2) }
    }

    /// 左边缘
    public var left: CGFloat {
        set(num) { x = LXSwiftApp.flat(num) }
        get { base.frame.origin.x }
    }

    /// 右边缘
    public var right: CGFloat {
        set(num) { x =  LXSwiftApp.flat(num - width) }
        get { x + width }
    }

    /// 上边缘
    public var top: CGFloat {
        set(num) { y = LXSwiftApp.flat(num) }
        get { y }
    }

    /// 下边缘
    public var bottom: CGFloat {
        set(num) { y = LXSwiftApp.flat(num - height) }
        get { y + height }
    }
}

//MARK: -  Extending methods for UIView
extension LXSwiftBasics where Base: UIView {
    
    /// 添加手势直接闭包回调
    @discardableResult
    public func addGesture(_ viewCallBack: @escaping ((UIView?) -> ())) -> UITapGestureRecognizer {
        base.viewCallBack = viewCallBack
        let gesture = UITapGestureRecognizer(target: base, action: #selector(base.gestureTap(_:)))
        base.addGestureRecognizer(gesture)
        return gesture
    }
}

private var viewCallBackKey: Void?
extension UIView {
    
    fileprivate var viewCallBack: ((UIView?) -> ())? {
        get { lx_getAssociatedObject(self, &viewCallBackKey) }
        set { lx_setRetainedAssociatedObject(self, &viewCallBackKey, newValue) }
    }
    
    @objc fileprivate func gestureTap(_ gesture: UIGestureRecognizer) { viewCallBack?(gesture.view) }
}
