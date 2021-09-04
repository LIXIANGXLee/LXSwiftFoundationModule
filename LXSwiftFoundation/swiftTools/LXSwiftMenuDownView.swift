//
//  LXSwiftMenuDownView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2021/9/4.
//

import UIKit

@objc(LXObjcMenuDownView)
@objcMembers open class LXSwiftMenuDownView: LXSwiftMenuView {
  
    /// 距顶部间距
    open var topMargin: CGFloat = 10
    
    open override var content: UIView? {
        didSet {
            guard let content = content else {return}
            addSubview(content)
        }
    }

    open override func dismiss() {
        
        /// 结束动画
       endAnimation()
    }
}

extension LXSwiftMenuDownView {
   
    /// 显示视图，view是点击的view
   @objc open func show(from view: UIView, rootView: UIView? = nil) {

        guard let content = content else { return }

        if rootView != nil {
            rootView?.addSubview(self)
        }else{
            lx.presentView?.addSubview(self)
        }
        
        let rect = view.convert(view.bounds, to: rootView)
        content.layer.anchorPoint = CGPoint(x: 1, y: 0)
        content.lx_origin = CGPoint(x: rect.midX - content.lx_width, y: rect.maxY + topMargin)
    
        startAnimation()
    }
}


extension LXSwiftMenuDownView {
    
    /// 结束动画
    private func endAnimation() {
        backgroundColor = UIColor.black.withAlphaComponent(viewOpaque)
        self.content?.transform = CGAffineTransform.identity
        UIView.animate(withDuration: animateDuration, animations: {
            self.content?.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            self.backgroundColor = UIColor.black.withAlphaComponent(0)
        }) {(finished) -> () in
            self.removeFromSuperview()
        }
    }
   
    /// 开始动画
    private func startAnimation() {
        self.content?.transform = CGAffineTransform(scaleX: 0, y: 0)
        backgroundColor = UIColor.black.withAlphaComponent(0)
        UIView.animate(withDuration: animateDuration) { [weak self] in
            guard let `self` = self else { return }
            self.content?.transform = CGAffineTransform.identity
            self.backgroundColor = UIColor.black.withAlphaComponent(self.viewOpaque)
        }
    }
}
