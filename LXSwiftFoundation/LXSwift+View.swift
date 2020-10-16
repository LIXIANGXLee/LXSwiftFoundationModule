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
    
    /// presented root
    public var aboveView: UIView? {
        var aboveController = UIApplication.shared.delegate?.window??.rootViewController
        while aboveController?.presentedViewController != nil {
            aboveController = aboveController?.presentedViewController
        }
        return aboveController?.view
    }
    
    /// snapShot image
    public var snapShotImage: UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(base.bounds.size, base.isOpaque, 0)
        if isContainsWKWebView() {
            base.drawHierarchy(in: base.bounds, afterScreenUpdates: true)
        }else{
            base.layer.render(in: UIGraphicsGetCurrentContext()!)
        }
        
        let snapImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapImage
    }
    
    
    /// chromium source - snapshot_manager, fix wkwebview screenshot bug.
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
    
    /// async  snapShot image
    public func async_snapShotImage(complete: @escaping (UIImage?) -> ()) {
        DispatchQueue.global().async{
            let async_image = self.snapShotImage
            DispatchQueue.main.async(execute: {
                complete(async_image)
            })
        }
    }
}

//MARK: -  Extending methods for UIView
extension LXSwiftBasics where Base: UIView {
    ///  view set Gradient
    ///
    /// - Parameters:
    ///   - colors: [UIColor]
    ///   - locations: []
    ///   - startPoint: start
    ///   - endPoint: end
    public func setGradientLayer(with colors: [CGColor],
                                 locations: [NSNumber] = [0.0,1.0],
                                 startPoint: CGPoint = CGPoint(x: 0, y: 0),
                                 endPoint: CGPoint = CGPoint(x: 1, y: 1)){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame =  base.bounds
        base.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
    }
    
    /// view set Shadow
    ///
    /// - Parameters:
    ///   - color: Shadow color
    ///   - radius: shadowRadius
    ///   - opacity: shadowOpacity
    ///   - offset: shadowOffset
    public func setShadow(color: UIColor, radius: CGFloat, opacity: Float, offset: CGSize = CGSize.zero) {
        base.layer.shadowColor = color.cgColor
        base.layer.shadowRadius = radius
        base.layer.shadowOpacity = opacity
        base.layer.shadowOffset = offset
    }
    
    /// remove Shadow
    public func removeShadow() {
        base.layer.shadowOpacity = 0.0
    }
    
    /// view set border
    public func setBorder(width: CGFloat, color: UIColor, cornerRadius: CGFloat? = nil) {
        base.layer.borderWidth = width
        base.layer.borderColor = color.cgColor
        if let cornerRadius = cornerRadius {
            base.layer.cornerRadius = cornerRadius
        }
    }
    
    /// cornerRadius
    public func setCornerRadius(_ radius: CGFloat = 4.0, clips: Bool = false) {
        base.layer.cornerRadius = radius
        base.layer.masksToBounds = clips
    }
    
    /// cornerRadius(topLeft topRight bottomLeft bottomRight)
    ///
    /// - Parameters:
    ///   - cornerRadii: radius size
    ///   - roundingCorners: UIRectCorner(rawValue:
    ///   (UIRectCorner.topRight.rawValue) | (UIRectCorner.bottomRight.rawValue))
    public func setPartCornerRadius(_ radius: CGFloat = 4.0, _ roundingCorners:UIRectCorner) {
        let fieldPath =  UIBezierPath(roundedRect: base.bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: radius, height: radius))
        let fieldLayer = CAShapeLayer()
        fieldLayer.frame = base.bounds
        fieldLayer.path = fieldPath.cgPath
        base.layer.mask = fieldLayer
    }
    
}


//MARK: -  Extending methods for UIView
extension LXSwiftBasics where Base: UIView {
    
    /// add gesture
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
    
    /// can save callback
    internal var viewCallBack: ((UIView?) -> ())? {
        get { return getAssociatedObject(self, &viewCallBackKey) }
        set { setRetainedAssociatedObject(self, &viewCallBackKey, newValue) }
    }
    
    @objc internal func gestureTap(_ gesture: UIGestureRecognizer) {
        self.viewCallBack?(gesture.view)
    }
    
}
