//
//  Swift+Control.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

// MARK: - UIControl 扩展方法
/// 为 UIControl 及其子类（如 UIButton）提供便捷的扩展方法
extension SwiftBasics where Base: UIControl {
    
    /// 防止控件重复点击
    /// - Parameter time: 点击间隔时间（秒），默认为 0.8 秒
    /// - 说明:
    ///   1. 点击后控件会暂时禁用交互，防止重复触发事件
    ///   2. 该方法确保只会添加一次防重逻辑，多次调用不会重复添加
    ///   3. 默认针对 .touchUpInside 事件生效
    public func preventDoubleHit(forHitTime time: Double = 0.8) {
        // 使用关联对象确保只设置一次防重逻辑
        guard base.preventDoubleHitKey == nil else { return }
        base.preventDoubleHitKey = true
        base.preventDoubleHit(forHitTime: time)
    }

    /// 添加控件事件回调（推荐方式）
    /// - Parameters:
    ///   - events: 要监听的事件类型，默认为 .touchUpInside
    ///   - closure: 事件触发时执行的回调闭包
    /// - 说明:
    ///   1. 使用闭包替代传统的 target-action 模式
    ///   2. 支持同时监听多种事件类型
    ///   3. 自动管理内存，无需手动移除
    public func addTarget(forControlEvents events: UIControl.Event = .touchUpInside, closure: @escaping ((Any) -> ())) {
        base.swiftAddTarget(forControlEvents: events, closure: closure)
    }
    
    /// 设置按钮点击回调（已废弃）
    /// - Parameter buttonCallBack: 按钮点击回调闭包
    /// - 说明:
    ///   1. 此方法已废弃，请使用 addTarget(forControlEvents:closure:) 替代
    ///   2. 仅适用于 UIButton 类型控件
    @available(*, deprecated, message: "Use addTarget(forControlEvents:closure:) instead")
    public func setHandle(buttonCallBack: ((_ button: UIButton) -> ())?) {
        addTarget { (objc) in
            if let btn = objc as? UIButton {
                buttonCallBack?(btn)
            }
        }
    }
    
    /// 移除所有通过闭包添加的事件回调
    /// - 说明:
    ///   1. 清除所有通过 swiftAddTarget 添加的事件监听
    ///   2. 不会影响通过传统 addTarget 方法添加的事件
    public func removeAllTargets() {
        base.swiftRemoveAllTargets()
    }
}

// MARK: - UIControl 私有扩展
private var _swiftControlTargetKey: Void?
private var _preventDoubleHitKey: Void?

extension UIControl {
    
    // MARK: 关联对象 Key
    /// 防重点击关联对象标识（Bool 类型）
    fileprivate var preventDoubleHitKey: Bool? {
        get { objc_getAssociatedObject(self, &_preventDoubleHitKey) as? Bool }
        set { objc_setAssociatedObject(self, &_preventDoubleHitKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    /// 实现防重点击核心逻辑
    fileprivate func preventDoubleHit(forHitTime time: Double) {
        // 添加点击事件监听（仅 .touchUpInside 事件）
        swiftAddTarget(forControlEvents: .touchUpInside) { [weak self] _ in
            guard let self = self else { return }
            
            // 立即禁用交互，防止重复点击
            self.isUserInteractionEnabled = false
            
            // 延迟恢复交互能力
            DispatchQueue.lx.delay(with: time) {
                self.isUserInteractionEnabled = true
            }
        }
    }
    
    // MARK: 事件回调管理
    /// 内部方法：添加闭包形式的事件回调
    fileprivate func swiftAddTarget(forControlEvents events: UIControl.Event = .touchUpInside, closure: @escaping ((Any) -> ())) {
        // 创建目标对象（封装闭包）
        let target = SwiftControlTarget(closure: closure, forControlEvents: events)
        
        // 注册目标-动作方法
        self.addTarget(target, action: #selector(target.invokeTarget(_:)), for: events)
        
        // 存储目标对象（强引用）
        swiftAllControlTargets?.add(target)
    }

    /// 内部方法：移除所有闭包形式的事件回调
    fileprivate func swiftRemoveAllTargets() {
        // 遍历所有目标对象
        swiftAllControlTargets?.forEach { target in
            // 从控件移除目标-动作
            if let target = target as? SwiftControlTarget {
                self.removeTarget(target, action: nil, for: target.events)
            }
        }
        
        // 清空存储池
        swiftAllControlTargets?.removeAllObjects()
    }
    
    /// 内部属性：存储所有事件回调目标对象
    fileprivate var swiftAllControlTargets: NSMutableArray? {
        get {
            // 从关联对象获取目标数组
            if let targets = objc_getAssociatedObject(self, &_swiftControlTargetKey) as? NSMutableArray {
                return targets
            }
            
            // 首次访问时创建存储数组
            let targets = NSMutableArray()
            objc_setAssociatedObject(self, &_swiftControlTargetKey, targets, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return targets
        }
    }
}

// MARK: - 事件回调目标类
/// 闭包回调包装器（私有类）
fileprivate final class SwiftControlTarget {
    /// 存储事件触发的回调闭包
    let closure: (Any) -> Void
    
    /// 关联的事件类型
    let events: UIControl.Event
    
    /// 初始化方法
    init(closure: @escaping (Any) -> Void, forControlEvents events: UIControl.Event) {
        self.closure = closure
        self.events = events
    }
    
    /// 事件触发时调用的方法
    @objc func invokeTarget(_ sender: Any) {
        closure(sender)
    }
}
