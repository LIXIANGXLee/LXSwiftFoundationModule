//
//  SwiftScrollView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2018/4/23.
//  Copyright © 2018 李响. All rights reserved.
//

import UIKit

@objc(LXObjcScrollView)
@objcMembers open class SwiftScrollView: UIScrollView {
    
    public typealias RecognizeSimultaneously = ((UIGestureRecognizer, UIGestureRecognizer) -> Bool)
    public typealias ShouldBegin =  ((UIGestureRecognizer) -> Bool?)

    open var shouldRecognizeSimultaneously: RecognizeSimultaneously?
    open var shouldBegin: ShouldBegin?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        // 跨版本背景色适配
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
        } else {
            backgroundColor = .white
        }

        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        } else {
            translatesAutoresizingMaskIntoConstraints = false
        }
        setupUI()
        setupViewModel()
    }
    
    /// 您是否支持多事件传递
    @objc(setObjcShouldRecognizeSimultaneously:)
    open func setShouldRecognizeSimultaneously(_ callBack: RecognizeSimultaneously?) {
        self.shouldRecognizeSimultaneously = callBack
    }
    
    /// 是否允许开始手势
    open func setShouldBegin(_ callBack: ShouldBegin?) {
        self.shouldBegin = callBack
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UIGestureRecognizerDelegate
extension SwiftScrollView: UIGestureRecognizerDelegate {
   
    /// 您是否支持多事件传递代理
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        shouldRecognizeSimultaneously?(gestureRecognizer, otherGestureRecognizer) ?? false
    }
    
    /// 是否允许开始手势
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        shouldBegin?(gestureRecognizer) ?? super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
}

// MARK: - 子类配置方法
extension SwiftScrollView: SwiftUICompatible {
    /// 配置界面元素（子类必须重写，无需调用super）
    @objc open func setupUI() {
        // 示例：在此添加子视图、约束等
    }
    
    /// 配置视图模型（子类必须重写，无需调用super）
    @objc open func setupViewModel() {
        // 示例：在此绑定数据模型、监听事件等
    }
}
