//
//  Untitled.swift
//  Pods
//
//  Created by xrj on 2025/5/30.
//

// MARK: - 关联对象键
 private var _tokensKey: UInt8 = 0

/// 为 NotificationCenter 提供的扩展方法集合（闭包版本）
/// 注意：Base 类型约束未实际使用，保留现有结构
extension SwiftBasics where Base: NotificationCenter {
   
    /// 辅助结构：存储观察者令牌
    private final class TokenBox {
        var tokens: [NSObjectProtocol] = []
        deinit {
            tokens.forEach(NotificationCenter.default.removeObserver)
        }
    }

    // MARK: - 应用状态观察
    
    /// 注册应用激活状态通知监听（闭包形式）
    /// - 当应用从后台进入激活状态时触发（如启动完成、从后台返回）
    ///
    /// - Parameters:
    ///   - observer: 关联令牌的生命周期对象（通常传入 self）
    ///   - queue: 回调执行的队列（默认主队列）
    ///   - handler: 通知触发时的回调闭包
    ///
    /// 使用示例：
    /// ```
    /// NotificationCenter.observeDidBecomeActive(observer: self) { [weak self] _ in
    ///     self?.handleActiveEvent()
    /// }
    /// ```
    public func observeDidBecomeActive(
        observer: AnyObject,
        queue: OperationQueue? = .main,
        handler: @escaping (Notification) -> Void
    ) {
        let token = base.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: queue,
            using: handler
        )
        storeToken(token, for: observer)
    }

    /// 注册应用即将进入后台通知监听（闭包形式）
    /// - 当应用即将离开激活状态时触发（如按下 Home 键、切换应用）
    ///
    /// - Parameters:
    ///   - observer: 关联令牌的生命周期对象（通常传入 self）
    ///   - queue: 回调执行的队列（默认主队列）
    ///   - handler: 通知触发时的回调闭包
    ///
    /// 使用示例：
    /// ```
    /// NotificationCenter.observeWillResignActive(observer: self) { [weak self] _ in
    ///     self?.prepareForBackground()
    /// }
    /// ```
    public func observeWillResignActive(
        observer: AnyObject,
        queue: OperationQueue? = .main,
        handler: @escaping (Notification) -> Void
    ) {
        let token = base.addObserver(
            forName: UIApplication.willResignActiveNotification,
            object: nil,
            queue: queue,
            using: handler
        )
        storeToken(token, for: observer)
    }

    // MARK: - 令牌管理
    
    /// 存储观察令牌并关联生命周期
    /// - 当宿主对象释放时自动移除所有观察者
    private func storeToken(_ token: NSObjectProtocol, for observer: AnyObject) {
        // 从关联对象获取或创建存储容器
        let box: TokenBox = {
            if let existing = objc_getAssociatedObject(observer, &_tokensKey) as? TokenBox {
                return existing
            }
            let newBox = TokenBox()
            objc_setAssociatedObject(
                observer,
                &_tokensKey,
                newBox,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            return newBox
        }()
        
        // 存储令牌
        box.tokens.append(token)
    }
}
