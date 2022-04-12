//
//  LXSwiftMenuDownView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2021/9/4.
//

import UIKit

@objc(LXObjcMenuDownView)
@objcMembers open class LXSwiftMenuDownView: LXSwiftMenuView {
  
   @objc public enum MenuXType: Int {
        case left
        case mid
        case right
    }
    
    /// 距顶部间距
    open var topMargin: CGFloat = SCALE_IP6_WIDTH_TO_WIDTH(10)
    
    /// 布局位置，相对于传进来的按钮位置的布局摆放
    open var xType: LXSwiftMenuDownView.MenuXType = .right
    
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

extension LXSwiftMenuDownView {
   
    /// 显示视图，view是点击的view
    @objc open func show(from view: UIView, rootView: UIView? = nil, callBack: ((Bool) -> Void)? = nil) {

        guard var content = content else { return }
        if rootView != nil {
            rootView?.addSubview(self)
        } else {
            lx.presentView?.addSubview(self)
        }
        
        let rect = view.convert(view.bounds, to: rootView)
        var x: CGFloat = 0
        var point: CGPoint = CGPoint.zero
        switch xType {
        case .left:
            x = rect.minX - content.lx.width
            point = CGPoint(x: 1, y: 0)
        case .mid:
            x = rect.midX - content.lx.width
            point = CGPoint(x: 1, y: 0)
        case .right:
            x = rect.maxX - content.lx.width
            point = CGPoint(x: 1 - (rect.width * 0.5 / content.lx.width), y: 0)
        }
        content.layer.anchorPoint = point
        content.frame.origin = CGPoint(x: x, y: rect.maxY + topMargin)
    
        /// 开始动画
        startAnimation(callBack)
    }
}

extension LXSwiftMenuDownView {
    
    /// 结束动画
    private func endAnimation(_ callBack: ((Bool) -> Void)? = nil) {
        backgroundColor = UIColor.black.withAlphaComponent(viewOpaque)
        self.content?.transform = CGAffineTransform.identity
        UIView.animate(withDuration: animateDuration, animations: {
            self.content?.transform = CGAffineTransform(scaleX: self.xyScale, y: self.xyScale)
            self.backgroundColor = UIColor.black.withAlphaComponent(0)
        }) {(isFinish) -> () in
            self.removeFromSuperview()
            callBack?(isFinish)
        }
    }
   
    /// 开始动画
    private func startAnimation(_ callBack: ((Bool) -> Void)? = nil) {
        self.content?.transform = CGAffineTransform(scaleX: 0, y: 0)
        backgroundColor = UIColor.black.withAlphaComponent(0)
        UIView.animate(withDuration: animateDuration) {
            self.content?.transform = CGAffineTransform.identity
            self.backgroundColor = UIColor.black.withAlphaComponent(self.viewOpaque)
        } completion: { (isFinish) in
            callBack?(isFinish)
        }
    }
}
