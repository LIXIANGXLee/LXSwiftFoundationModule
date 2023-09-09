//
//  SwiftMenuUpView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2021/9/4.
//

import UIKit

@objc(LXObjcMenuUpView)
@objcMembers open class SwiftMenuUpView: SwiftMenuView {
  
    /// 内部属性 标记用的
    private var originY: CGFloat = 0

    open override var content: UIView? {
        didSet {
            guard let content = content else {
                return
            }
           
            scrollView.addSubview(content)
            content.gestureRecognizers?.forEach({ gesture in
                if gesture.isKind(of: UIPanGestureRecognizer.self) {
                    content.removeGestureRecognizer(gesture)
                }
            })
            
            /// 添加滑动手势
            let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
            content.addGestureRecognizer(pan)
        }
    }
        
    open override func dismiss() {

        /// 结束动画
        endAnimation { (_) in super.dismiss() }
    }
    
    /// 是否支持滑动手势 默认是false 不支持滑动手势
    open var isCanPanAction: Bool = false
      
    /// 子类可以重写 默认实现是向下滑动
    @objc open func panAction(_ pan: UIPanGestureRecognizer) {
        
        guard isCanPanAction,
              var content = content else {
            return
        }
        
        let offSet = pan.translation(in: pan.view)
        if offSet.y < 0 { return }
        
        switch pan.state {
        case .began:
            originY = content.lx.y
        case .changed:
            content.lx.y = originY + offSet.y
        default:
            let isDisiss = offSet.y > content.lx.height*0.5
            isDisiss ? dismiss() : resetStart()
        }
    }
}

extension SwiftMenuUpView {
   
    /// 显示视图
    open func show(_ rootView: UIView? = nil, callBack: ((Bool) -> Void)? = nil) {
      
        guard var content = content else {
            return
        }
        let currentView = rootView ?? UIApplication.lx.currentViewController?.view
        currentView?.addSubview(self)

        content.lx.y = SCREEN_HEIGHT_TO_HEIGHT
        
        /// 开始动画
        startAnimation(callBack)
    }
}

extension SwiftMenuUpView {
  
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
            guard var content = self.content else {
                return
            }
        
            self.backgroundColor = UIColor.black.withAlphaComponent(self.viewOpaque)
            content.lx.y = SCREEN_HEIGHT_TO_HEIGHT - content.lx.height
        } completion: { (isFinish) in
            callBack?(isFinish)
        }
    }
    
    /// 恢复开始
    private func resetStart() {
       
        UIView.animate(withDuration:animateDuration) {
            guard var content = self.content else { return }
          
            content.lx.y = SCREEN_HEIGHT_TO_HEIGHT - content.lx.height
        }
    }
}
