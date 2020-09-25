//
//  LXSwift+View.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

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
    
       /// image
       public var snapshotImageAfterScreenUpdates: UIImage? {
        UIGraphicsBeginImageContextWithOptions(base.bounds.size, base.isOpaque, 0)
           base.drawHierarchy(in: base.bounds, afterScreenUpdates: true)
           let snap = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           return snap
       }
       
      /// image
       public var snapshotImage: UIImage? {
           UIGraphicsBeginImageContextWithOptions(base.bounds.size, base.isOpaque, 0)
           base.layer.render(in: UIGraphicsGetCurrentContext()!)
           let snap = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           return snap
       }
    
}

//MARK: -  Extending methods for UILabel
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

