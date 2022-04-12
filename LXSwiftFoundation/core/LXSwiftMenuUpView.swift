//
//  LXSwiftMenuUpView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2021/9/4.
//

import UIKit

@objc(LXObjcMenuUpView)
@objcMembers open class LXSwiftMenuUpView: LXSwiftMenuView {

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

extension LXSwiftMenuUpView {
   
    /// 显示视图
    open func show(_ rootView: UIView? = nil, callBack: ((Bool) -> Void)? = nil) {
      
        guard var content = content else { return }
        if rootView != nil {
            rootView?.addSubview(self)
        } else {
            lx.presentView?.addSubview(self)
        }
        content.lx.y = SCREEN_HEIGHT_TO_HEIGHT
        
        /// 开始动画
        startAnimation(callBack)
    }
}

extension LXSwiftMenuUpView {
  
    /// 结束动画
    private func endAnimation(_ callBack: ((Bool) -> Void)? = nil) {
        self.backgroundColor = UIColor.black.withAlphaComponent(viewOpaque)
        UIView.animate(withDuration: animateDuration, animations: {
            self.content?.lx.y = SCREEN_HEIGHT_TO_HEIGHT
            self.backgroundColor = UIColor.black.withAlphaComponent(0)
        }) {(isFinish) -> () in
            self.removeFromSuperview()
            callBack?(isFinish)
        }
    }
    
    /// 开始动画
    private func startAnimation(_ callBack: ((Bool) -> Void)? = nil) {
        self.backgroundColor = UIColor.black.withAlphaComponent(0)
        UIView.animate(withDuration:animateDuration) { 
            guard var content = self.content else { return }
            self.backgroundColor = UIColor.black.withAlphaComponent(self.viewOpaque)
            content.lx.y = SCREEN_HEIGHT_TO_HEIGHT - content.lx.height
        } completion: { (isFinish) in
            callBack?(isFinish)
        }
    }
}
