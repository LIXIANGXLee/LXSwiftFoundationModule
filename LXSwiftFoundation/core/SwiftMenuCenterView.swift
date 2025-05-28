//
//  SwiftMenuCenterView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2021/9/12.
//

import UIKit

@objc(LXObjcMenuCenterView)
@objcMembers open class SwiftMenuCenterView: SwiftMenuView {
    
    @objc public enum MenuYType: Int {
         case bottom     // 下面弹起
         case top        // 上面落下
         case mid        // 中间放大
         case midRotate  // 中间放大加旋转
         case gradual    // 逐渐的
     }
     
     /// 纵向偏离距离 yType = mid 、midRotate、 gradual时有效
    open var offsetY: CGFloat = SCALE_IP6_WIDTH_TO_WIDTH(10)

     /// 布局位置，相对于传进来的按钮位置的布局摆放
    open var yType: SwiftMenuCenterView.MenuYType = .top
    
    /// 默认缩放倍数，有缩放效果时用，内部属性
    private let xyScale: CGFloat = 0.01
    
    open override var content: UIView? {
        didSet {
            guard let content = content else {
                return
            }
            scrollView.addSubview(content)
        }
    }
        
    open override func dismiss() {
        
        /// 结束动画
        endAnimation { (_) in super.dismiss() }
    }
}

extension SwiftMenuCenterView {
   
    /// 显示视图
    open func show(_ rootView: UIView? = nil,
                   callBack: ((Bool) -> Void)? = nil) {
      
        guard var content = content else {
            return
        }
        
        let currentView = rootView ?? UIApplication.lx.currentViewController?.view

        currentView?.addSubview(self)

        content.lx.centerX = SCREEN_WIDTH_TO_WIDTH * 0.5
        switch yType {
        case .top: content.lx.y = -content.lx.height
        case .mid: fallthrough
        case .gradual: fallthrough
        case .midRotate:
            content.lx.y = (SCREEN_HEIGHT_TO_HEIGHT - content.lx.height) * 0.5 - offsetY
            content.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        case .bottom: content.lx.y = SCREEN_HEIGHT_TO_HEIGHT
        default: break
        }
        
        /// 开始动画
        startAnimation(callBack)
    }
}

extension SwiftMenuCenterView {
  
    /// 结束动画
    private func endAnimation(_ callBack: ((Bool) -> Void)? = nil) {
        self.backgroundColor = UIColor.black.withAlphaComponent(viewOpaque)
        UIView.animate(withDuration: animateDuration, animations: {
            guard let content = self.content else {
                return
            }
        
            self.backgroundColor = UIColor.black.withAlphaComponent(0)
            switch self.yType {
            case .bottom: fallthrough
            case .top: content.transform = CGAffineTransform.identity
            case .mid: content.transform = CGAffineTransform(scaleX: self.xyScale, y: self.xyScale)
            case .midRotate: content.transform = CGAffineTransform(scaleX: self.xyScale, y: self.xyScale).rotated(by: CGFloat(Double.pi))
            case .gradual: content.alpha = self.xyScale
            default: break
            }
        }) {(isFinish) -> () in
            self.removeFromSuperview()
            callBack?(isFinish)
        }
    }
    
    /// 开始动画
    private func startAnimation(_ callBack: ((Bool) -> Void)? = nil) {
        guard let content = self.content else {
            return
        }
       
        self.backgroundColor = UIColor.black.withAlphaComponent(0)
        switch yType {
        case .bottom: fallthrough
        case .top: content.transform = CGAffineTransform.identity
        case .mid: content.transform = CGAffineTransform(scaleX: xyScale, y: xyScale)
        case .gradual: content.alpha = xyScale
        case .midRotate: content.transform = CGAffineTransform(scaleX: xyScale, y: xyScale).rotated(by: CGFloat(Double.pi))
        default: break
        }
        
        UIView.animate(withDuration:animateDuration) {
            guard let content = self.content else {
                return
            }
            self.backgroundColor = UIColor.black.withAlphaComponent(self.viewOpaque)
            switch self.yType {
            case .bottom: content.transform = CGAffineTransform(translationX: 0, y: -(SCREEN_HEIGHT_TO_HEIGHT + content.lx.height) * 0.5)
            case .top: content.transform = CGAffineTransform(translationX: 0, y: (SCREEN_HEIGHT_TO_HEIGHT + content.lx.height) * 0.5)
            case .mid: content.transform = CGAffineTransform.identity
            case .gradual: content.alpha = 1
            case .midRotate: content.transform = CGAffineTransform(scaleX: 1, y: 1).rotated(by: CGFloat(Double.pi * 2))
            default: break
            }
        } completion: { (isFinish) in
            callBack?(isFinish)
        }
    }
}
