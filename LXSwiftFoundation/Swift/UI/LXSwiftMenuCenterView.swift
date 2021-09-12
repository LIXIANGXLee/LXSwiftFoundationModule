//
//  LXSwiftMenuCenterView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2021/9/12.
//

import UIKit

@objc(LXObjcMenuCenterView)
@objcMembers open class LXSwiftMenuCenterView: LXSwiftMenuView {
    
    @objc public enum MenuYType: Int {
         case bottom
         case top
         case mid
         case midRotate
     }
     
     /// 距顶部间距
    open var topMargin: CGFloat = SCALE_IP6_WIDTH_TO_WIDTH(10)
     
     /// 布局位置，相对于传进来的按钮位置的布局摆放
    open var yType: LXSwiftMenuCenterView.MenuYType = .top
    
    /// 默认缩放倍数，有缩放效果时用，内部属性
    fileprivate let xyScale: CGFloat = 0.01
    
    open override var content: UIView? {
        didSet {
            guard let content = content else { return }
            addSubview(content)
        }
    }
        
    open override func dismiss() {
        
        /// 结束动画
        endAnimation { (_) in super.dismiss() }
    }
}

extension LXSwiftMenuCenterView {
   
    /// 显示视图
    open func show(_ rootView: UIView? = nil, callBack: ((Bool) -> Void)? = nil) {
      
        guard let content = content else { return }
        if rootView != nil {
            rootView?.addSubview(self)
        } else {
            lx.presentView?.addSubview(self)
        }

        content.lx_center_x = SCREEN_WIDTH_TO_WIDTH * 0.5
        switch yType {
        case .top: content.lx_y = -content.lx_height
        case .mid: fallthrough
        case .midRotate: content.lx_y = (SCREEN_HEIGHT_TO_HEIGHT - content.lx_height) * 0.5
        case .bottom: content.lx_y = SCREEN_HEIGHT_TO_HEIGHT
        default: break
        }
        
        /// 开始动画
        startAnimation(callBack)
    }
}

extension LXSwiftMenuCenterView {
  
    /// 结束动画
    private func endAnimation(_ callBack: ((Bool) -> Void)? = nil) {
        self.backgroundColor = UIColor.black.withAlphaComponent(viewOpaque)
        UIView.animate(withDuration: animateDuration, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0)
            switch self.yType {
            case .bottom: fallthrough
            case .top: self.content?.transform = CGAffineTransform.identity
            case .mid: self.content?.transform = CGAffineTransform(scaleX: self.xyScale, y: self.xyScale)
            case .midRotate:
                let transform = CGAffineTransform(scaleX: self.xyScale, y: self.xyScale)
                self.content?.transform = transform.rotated(by: CGFloat(Double.pi))
            default: break
            }
        }) {(isFinish) -> () in
            self.removeFromSuperview()
            callBack?(isFinish)
        }
    }
    
    /// 开始动画
    private func startAnimation(_ callBack: ((Bool) -> Void)? = nil) {
        self.backgroundColor = UIColor.black.withAlphaComponent(0)
        switch yType {
        case .bottom: fallthrough
        case .top: content?.transform = CGAffineTransform.identity
        case .mid: content?.transform = CGAffineTransform(scaleX: xyScale, y: xyScale)
        case .midRotate: content?.transform = CGAffineTransform(scaleX: xyScale, y: xyScale).rotated(by: CGFloat(Double.pi))
        default: break
        }
        
        UIView.animate(withDuration:animateDuration) {
            guard let content = self.content else { return }
            self.backgroundColor = UIColor.black.withAlphaComponent(self.viewOpaque)
            switch self.yType {
            case .bottom: content.transform = CGAffineTransform(translationX: 0, y: -(SCREEN_HEIGHT_TO_HEIGHT + content.lx_height) * 0.5)
            case .top: content.transform = CGAffineTransform(translationX: 0, y: (SCREEN_HEIGHT_TO_HEIGHT + content.lx_height) * 0.5)
            case .mid: content.transform = CGAffineTransform.identity
            case .midRotate: content.transform = CGAffineTransform(scaleX: 1, y: 1).rotated(by: CGFloat(Double.pi * 2))
            default: break
            }
        } completion: { (isFinish) in
            callBack?(isFinish)
        }
    }
}
