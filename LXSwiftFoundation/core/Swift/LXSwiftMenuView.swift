//
//  LXSwiftMenuView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2021/9/4.
//

import UIKit

@objc(LXObjcMenuViewDelegate)
public protocol LXSwiftMenuViewDelegate: AnyObject { }

@objc(LXObjcMenuView)
@objcMembers open class LXSwiftMenuView: LXSwiftView, LXSwiftMenuViewDelegate {
    
    /// 动画时常
    open var animateDuration: TimeInterval = 0.25
  
    /// view的透明度
    open var viewOpaque: CGFloat = 0.7

    /// 点击背景色时dismiss掉弹窗
    open var isTouchBgDismiss: Bool = true
    
    /// 内容view
    open var content: UIView?
  
    /// 关掉当前窗口
    open func dismiss() { }
    
    open override func setupUI() {
        self.frame = CGRect(x: 0,
                            y: 0,
                            width: SCREEN_WIDTH_TO_WIDTH,
                            height: SCREEN_HEIGHT_TO_HEIGHT)

    }
    
    /// 系统点击方法
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {return}
        let view = self.hitTest(point, with: event)
        if view is LXSwiftMenuViewDelegate && isTouchBgDismiss { dismiss() }
    }
}
