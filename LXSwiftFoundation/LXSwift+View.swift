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
    public var aboveView: UIView? {
        return UIApplication.lx.visiblePresentViewController?.view
    }
    
    /// 当前的view
    public var currentVCView: UIView? {
        return UIApplication.lx.visibleViewController?.view
    }
    
    /// 导航跟控制器
    public var aboveNavVC: UINavigationController? {
        return UIApplication.lx.visibleNavRootViewController
    }
    
    /// view截图
    public var snapShotImage: UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(base.bounds.size,
                                               base.isOpaque, 0)
        if isContainsWKWebView() {
            base.drawHierarchy(in: base.bounds, afterScreenUpdates: true)
        }else{
            base.layer.render(in: UIGraphicsGetCurrentContext()!)
        }
        
        let snapImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapImage
    }
    
    /// -快照管理器，修复wkwebview屏幕截图错误。
    public func isContainsWKWebView() -> Bool {
        if base.isKind(of: WKWebView.self) {
            return true
        }
        for subView in base.subviews {
            if (subView.lx.isContainsWKWebView()) {
                return true
            }
        }
        return false
    }
}

//MARK: -  Extending methods for UIView
extension LXSwiftBasics where Base: UIView {
  
    ///  view 渐变色
    ///
    /// - Parameters:
    ///   - colors: [UIColor]
    ///   - locations: []
    ///   - startPoint: start
    ///   - endPoint: end
    ///   - size leyar 大小
    public func setGradientLayer(with colors: [UIColor],
                                 locations: [NSNumber] = [0.0,1.0],
                                 startPoint: CGPoint = CGPoint(x: 0, y: 0.5),
                                 endPoint: CGPoint = CGPoint(x: 1, y: 0.5),
                                 size: CGSize? = nil){
        
        let s = size ?? base.bounds.size
        if !s.equalTo(CGSize.zero) {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame =  CGRect(origin: CGPoint.zero, size: s)
            base.layer.insertSublayer(gradientLayer, at: 0)
            gradientLayer.colors = colors.map{ $0.cgColor }
            gradientLayer.locations = locations
            gradientLayer.startPoint = startPoint
            gradientLayer.endPoint = endPoint
        }
    }
    
    /// view 的阴影
    ///
    /// - Parameters:
    ///   - color: Shadow color
    ///   - radius: shadowRadius
    ///   - opacity: shadowOpacity
    ///   - offset: shadowOffset
    public func setShadow(color: UIColor, radius: CGFloat,
                          opacity: Float, offset: CGSize = CGSize.zero) {
        base.layer.shadowColor = color.cgColor
        base.layer.shadowRadius = radius
        base.layer.shadowOpacity = opacity
        base.layer.shadowOffset = offset
    }
    
    /// 移除阴影
    public func removeShadow() {
        base.layer.shadowOpacity = 0.0
    }
    
    /// view 边框
    public func setBorder(width: CGFloat,
                          color: UIColor,
                          cornerRadius: CGFloat? = nil) {
        base.layer.borderWidth = width
        base.layer.borderColor = color.cgColor
        if let cornerRadius = cornerRadius {
            base.layer.cornerRadius = cornerRadius
        }
    }
    
    /// 圆角
    public func setCornerRadius(radius: CGFloat = 4.0,
                                clips: Bool = true) {
        base.layer.cornerRadius = radius
        base.layer.masksToBounds = clips
    }
    
    ///  圆角 cornerRadius(topLeft topRight bottomLeft bottomRight)
    ///
    /// - Parameters:
    ///   - cornerRadii: radius size
    ///   - roundingCorners: UIRectCorner(rawValue:
    ///   (UIRectCorner.topRight.rawValue) | (UIRectCorner.bottomRight.rawValue))
    ///   - viewSize: size of the current view
    public func setPartCornerRadius(radius: CGFloat = 4.0,
                                    roundingCorners: UIRectCorner = .allCorners,
                                    viewSize: CGSize? = nil) {
        
        let s = viewSize ?? base.bounds.size
        let rect = CGRect(origin: CGPoint.zero, size: s)
        let fieldPath = UIBezierPath(roundedRect: rect,
                                      byRoundingCorners: roundingCorners,
                                      cornerRadii: CGSize(width: radius,
                                                          height: radius))
        if !s.equalTo(CGSize.zero) {
            let fieldLayer = CAShapeLayer()
            fieldLayer.frame = base.bounds
            fieldLayer.path = fieldPath.cgPath
            base.layer.mask = fieldLayer
        }
    }
}

//MARK: -  Extending methods for UIView
extension LXSwiftBasics where Base: UIView {
    
    /// add 手势直接闭包回调
    @discardableResult
    public func addGesture(_ viewCallBack: @escaping ((UIView?) -> ()))
    -> UITapGestureRecognizer {
        base.viewCallBack = viewCallBack
        let gesture = UITapGestureRecognizer(target: base,
                                             action: #selector(base.gestureTap(_:)))
        base.addGestureRecognizer(gesture)
        return gesture
    }
}

private var viewCallBackKey: Void?
extension UIView {
    
    var viewCallBack: ((UIView?) -> ())? {
        get { return lx_getAssociatedObject(self, &viewCallBackKey) }
        set { lx_setRetainedAssociatedObject(self,
                                             &viewCallBackKey, newValue) }
    }
    
    @objc func gestureTap(_ gesture: UIGestureRecognizer) {
        self.viewCallBack?(gesture.view)
    }
}
