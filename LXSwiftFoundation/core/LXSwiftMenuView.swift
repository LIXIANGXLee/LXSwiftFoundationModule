//
//  LXSwiftMenuView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2021/9/4.
//

import UIKit

@objc(LXObjcMenuViewDelegate)
public protocol LXSwiftMenuViewDelegate: AnyObject { }

@objcMembers internal class LXSwiftInnerScrollView: UIScrollView, LXSwiftMenuViewDelegate {
    
    internal var touchBgDismissClosure: (() -> Void)?
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isScrollEnabled = true
        isPagingEnabled = false
    }
    
    required internal init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override internal func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        let view = self.hitTest(point, with: event)
        if view is LXSwiftMenuViewDelegate { touchBgDismissClosure?() }
    }
}

@objc(LXObjcMenuView)
@objcMembers open class LXSwiftMenuView: LXSwiftView {
    
    /// 动画时常
    open var animateDuration: TimeInterval = 0.25
  
    /// view的透明度
    open var viewOpaque: CGFloat = 0.7

    /// 点击背景色时dismiss掉弹窗
    open var isTouchBgDismiss: Bool = true
    
    internal private(set) lazy var scrollView: LXSwiftInnerScrollView = {
        let scrollView = LXSwiftInnerScrollView()
        return scrollView
    }()
    
    /// 内容view
    open var content: UIView?
  
    /// 结束动画时的回调，可以在此事件中处理结束动画后的一些事物
    open var dismissCallBack: (() -> Void)?
    
    /// 关掉当前窗口
    open func dismiss() { dismissCallBack?() }
    
    open override func setupUI() {
        let rect = CGRect(x: 0,
                          y: 0,
                          width: SCREEN_WIDTH_TO_WIDTH,
                          height: SCREEN_HEIGHT_TO_HEIGHT)
        self.frame = rect
        self.scrollView.frame = rect
        addSubview(scrollView)
        
        scrollView.touchBgDismissClosure = { [weak self] in
            guard let `self` = self else { return }
            if self.isTouchBgDismiss { self.dismiss() }
        }
    }
    
    /// 系统点击方法
//    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let point = touches.first?.location(in: self) else { return }
//        let view = self.hitTest(point, with: event)
//        if view is LXSwiftMenuViewDelegate && isTouchBgDismiss { dismiss() }
//    }
}
