//
//  Swift+NotificationCenter.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2021/9/29.
//  Copyright © 2017 李响. All rights reserved.
//

// MARK: - 关联对象键
private var _notificationTokensKey: UInt8 = 0

/// NotificationCenter 的扩展方法集合（闭包版本）
/// 提供便捷的通知观察方法，并自动管理观察者生命周期
extension SwiftBasics where Base: NotificationCenter {
    
    /// 观察者令牌容器
    /// 在宿主对象释放时自动移除所有注册的通知观察者
    private final class NotificationTokenBox {
        var tokens: [NSObjectProtocol] = []
        
        deinit {
            // 自动移除所有观察者
            tokens.forEach(NotificationCenter.default.removeObserver)
        }
    }
    
    // MARK: - 应用状态通知
    
    /// 观察应用激活通知
    /// - 当应用从后台进入激活状态时触发（如启动完成、从后台返回）
    /// - Parameters:
    ///   - observer: 关联生命周期的对象（通常传入 self）
    ///   - queue: 回调执行队列（默认主队列）
    ///   - handler: 通知触发回调
    public func observeDidBecomeActive(
        observer: AnyObject,
        queue: OperationQueue? = .main,
        closure: @escaping (Notification) -> Void
    ) {
        registerNotification(
            name: UIApplication.didBecomeActiveNotification,
            observer: observer,
            queue: queue,
            closure: closure
        )
    }
    
    /// 观察应用即将进入后台通知
    /// - 当应用即将离开激活状态时触发（如按下 Home 键、切换应用）
    /// - Parameters:
    ///   - observer: 关联生命周期的对象（通常传入 self）
    ///   - queue: 回调执行队列（默认主队列）
    ///   - handler: 通知触发回调
    public func observeWillResignActive(
        observer: AnyObject,
        queue: OperationQueue? = .main,
        closure: @escaping (Notification) -> Void
    ) {
        registerNotification(
            name: UIApplication.willResignActiveNotification,
            observer: observer,
            queue: queue,
            closure: closure
        )
    }
    
    // MARK: - 键盘通知
    
    /// 观察键盘即将显示通知
    public func observeKeyboardWillShow(
        observer: AnyObject,
        queue: OperationQueue? = .main,
        closure: @escaping (Notification) -> Void
    ) {
        registerNotification(
            name: UIResponder.keyboardWillShowNotification,
            observer: observer,
            queue: queue,
            closure: closure
        )
    }
    
    /// 观察键盘显示完成通知
    public func observeKeyboardDidShow(
        observer: AnyObject,
        queue: OperationQueue? = .main,
        closure: @escaping (Notification) -> Void
    ) {
        registerNotification(
            name: UIResponder.keyboardDidShowNotification,  // 修正了错误的常量名
            observer: observer,
            queue: queue,
            closure: closure
        )
    }
    
    /// 观察键盘即将隐藏通知
    public func observeKeyboardWillHide(
        observer: AnyObject,
        queue: OperationQueue? = .main,
        closure: @escaping (Notification) -> Void
    ) {
        registerNotification(
            name: UIResponder.keyboardWillHideNotification,  // 修正了错误的常量名
            observer: observer,
            queue: queue,
            closure: closure
        )
    }
    
    /// 观察键盘隐藏完成通知
    public func observeKeyboardDidHide(
        observer: AnyObject,
        queue: OperationQueue? = .main,
        closure: @escaping (Notification) -> Void
    ) {
        registerNotification(
            name: UIResponder.keyboardDidHideNotification,  // 修正了错误的常量名
            observer: observer,
            queue: queue,
            closure: closure
        )
    }
    
    // MARK: - 私有方法
    
    /// 统一注册通知方法
    private func registerNotification(
        name: Notification.Name,
        observer: AnyObject,
        queue: OperationQueue?,
        closure: @escaping (Notification) -> Void
    ) {
        let token = base.addObserver(
            forName: name,
            object: nil,
            queue: queue,
            using: closure
        )
        storeToken(token, for: observer)
    }
    
    /// 存储观察令牌并关联生命周期
    /// - 当宿主对象释放时自动移除所有观察者
    private func storeToken(_ token: NSObjectProtocol, for observer: AnyObject) {
        // 从关联对象获取或创建存储容器
        let box: NotificationTokenBox = {
            if let existing = objc_getAssociatedObject(observer, &_notificationTokensKey) as? NotificationTokenBox {
                return existing
            }
            let newBox = NotificationTokenBox()
            objc_setAssociatedObject(
                observer,
                &_notificationTokensKey,
                newBox,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            return newBox
        }()
        
        // 存储令牌
        box.tokens.append(token)
    }
}
