//
//  SwiftMenuView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2021/9/4.
//

import UIKit

/// SwiftMenuView的代理协议（目前为空，可扩展）
@objc(LXObjcMenuViewDelegate)
public protocol SwiftMenuViewDelegate: AnyObject { }

// MARK: - 内部滚动视图
/// 用于实现背景点击消失功能的内部滚动视图
@objcMembers final class SwiftInnerScrollView: UIScrollView, SwiftMenuViewDelegate {
    
    // MARK: 属性
    /// 点击背景时的回调闭包
    var touchBgDismissClosure: (() -> Void)?
    
    // MARK: 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 视图配置
    private func configureView() {
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isScrollEnabled = true
        isPagingEnabled = false
    }
    
    // MARK: 触摸处理
    /// 处理背景触摸事件（非内容区域）
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        
        // 检查触摸点是否在背景上（非子视图）
        let touchedView = hitTest(point, with: event)
        if touchedView is SwiftMenuViewDelegate {
            touchBgDismissClosure?()
        }
    }
}

// MARK: - 菜单视图
/// 自定义弹窗菜单视图，支持背景点击消失
@objc(LXObjcMenuView)
@objcMembers open class SwiftMenuView: SwiftView {
    
    // MARK: 配置属性
    /// 动画持续时间（秒）
    open var animateDuration: TimeInterval = 0.25
  
    /// 背景视图透明度 (0.0~1.0)
    open var viewOpaque: CGFloat = 0.7

    /// 是否允许点击背景关闭弹窗
    open var isTouchBgDismiss: Bool = true
    
    /// 内容视图（需要自定义的内容区域）
    open var content: UIView? {
        didSet {
            guard let content = content else { return }
            scrollView.addSubview(content)
            // 这里可以添加内容视图的布局约束
        }
    }
  
    /// 弹窗关闭后的回调
    open var dismissCallBack: (() -> Void)?
    
    // MARK: 内部组件
    /// 核心滚动视图（承载背景点击功能）
    private(set) lazy var scrollView: SwiftInnerScrollView = {
        let view = SwiftInnerScrollView()
        view.touchBgDismissClosure = { [weak self] in
            guard let self = self, self.isTouchBgDismiss else { return }
            self.dismiss()
        }
        return view
    }()
    
    // MARK: 生命周期
    deinit {
        SwiftLog.log("SwiftMenuView deallocated")
    }
    
    // MARK: 视图初始化
    open override func setupUI() {
        // 设置全屏尺寸
        self.frame = UIScreen.main.bounds
        scrollView.frame = self.bounds
        
        addSubview(scrollView)
        backgroundColor = UIColor.black.withAlphaComponent(viewOpaque)
    }
    
    // MARK: 公开方法
    /// 关闭弹窗（带动画效果）
    open func dismiss() {
        UIView.animate(withDuration: animateDuration, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
            self.dismissCallBack?()
        }
    }
    
    /// 展示弹窗（添加到指定视图）
    open func show(in view: UIView) {
        alpha = 0
        view.addSubview(self)
        
        UIView.animate(withDuration: animateDuration) {
            self.alpha = 1
        }
    }
}
