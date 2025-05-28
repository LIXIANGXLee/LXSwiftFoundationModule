//
//  Swift+Control.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

// MARK: - UIControl 扩展方法
extension SwiftBasics where Base: UIControl {
    
    /// 防止按钮重复点击
    /// - Parameter time: 点击间隔时间，默认为 0.8 秒
    /// - 说明: 该方法会在点击后暂时禁用交互，防止在指定时间内重复触发事件
    public func preventDoubleHit(forHitTime time: Double = 0.8) {
        base.preventDoubleHit(forHitTime: time)
    }

    /// 添加控件事件回调
    /// - Parameters:
    ///   - events: 触发的事件类型，默认为 .touchUpInside
    ///   - closure: 事件触发时执行的回调闭包
    /// - 说明: 该方法使用闭包替代传统的 target-action 模式，使用更简洁
    public func addTarget(forControlEvents events: UIControl.Event = .touchUpInside, closure: @escaping ((Any) -> ())) {
        base.swiftAddTarget(forControlEvents: events, closure: closure)
    }
    
    /// 设置按钮点击回调 (已废弃)
    /// - Parameter buttonCallBack: 按钮点击回调闭包
    /// - 说明: 该方法已废弃，建议使用 addTarget(forControlEvents:closure:) 替代
    @available(*, deprecated, message: "Use addTarget(forControlEvents events:, closure:)")
    public func setHandle(buttonCallBack: ((_ button: UIButton) -> ())?) {
        addTarget { (objc) in
            if let btn = objc as? UIButton {
                buttonCallBack?(btn)
            }
        }
    }
    
    /// 移除所有已添加的事件回调
    /// - 说明: 该方法会清除通过 swiftAddTarget 添加的所有事件回调
    public func removeAllTargets() {
        base.swiftRemoveAllTargets()
    }
}

// MARK: - UIControl 私有扩展
private var _swiftControlTargetKey: Void?
extension UIControl {
    
    /// 实现防止重复点击功能
    fileprivate func preventDoubleHit(forHitTime time: Double) {
        swiftAddTarget { (control) in
            // 点击后立即禁用交互
            let view = control as? UIView
            view?.isUserInteractionEnabled = false
            
            // 延迟恢复交互
            DispatchQueue.lx.delay(with: time) {
                view?.isUserInteractionEnabled = true
            }
        }
    }

    /// 内部方法 - 添加控件事件回调
    fileprivate func swiftAddTarget(forControlEvents events: UIControl.Event = .touchUpInside, closure: @escaping ((Any) -> ())) {
        // 创建目标对象
        let target = SwiftControlTarget(closure: closure, forControlEvents: events)
        
        // 添加目标-动作
        self.addTarget(target, action: #selector(target.invokeTarget(_:)), for: events)
        
        // 存储目标对象以便后续管理
        swiftAllControlTargets?.add(target)
    }

    /// 内部方法 - 移除所有事件回调
    fileprivate func swiftRemoveAllTargets() {
        // 遍历所有目标对象并移除
        swiftAllControlTargets?.enumerateObjects({ objc, _, _ in
            self.removeTarget(objc, action: nil, for: .allEvents)
        })
        
        // 清空存储的目标对象
        swiftAllControlTargets?.removeAllObjects()
    }
    
    /// 内部属性 - 存储所有事件回调目标对象
    /// - 说明: 使用关联对象存储目标对象数组，保证生命周期
    fileprivate var swiftAllControlTargets: NSMutableArray? {
        get {
            var targets = objc_getAssociatedObject(self, &_swiftControlTargetKey) as? NSMutableArray
            if targets == nil {
                targets = NSMutableArray()
                objc_setAssociatedObject(self, &_swiftControlTargetKey, targets, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return targets
        }
    }
}

// MARK: - 事件回调目标类
/// 私有类 - 用于封装闭包回调
fileprivate final class SwiftControlTarget {
    /// 存储回调闭包
    var closure: ((Any) -> ())
    /// 关联的事件类型
    var events: UIControl.Event
    
    /// 初始化方法
    init(closure: @escaping (Any) -> Void, forControlEvents events: UIControl.Event) {
        self.closure = closure
        self.events = events
    }
    
    /// 目标动作方法
    @objc func invokeTarget(_ objc: Any) {
        self.closure(objc)
    }
}
