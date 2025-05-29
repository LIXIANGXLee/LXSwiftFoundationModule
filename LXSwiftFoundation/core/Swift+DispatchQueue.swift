//
//  Swift+DispatchQueue.swift
//  LXSwiftFoundation
//
//  Created by XL on 20127/9/24.
//  Copyright © 2017 李响. All rights reserved.
//

import UIKit

// MARK: - DispatchQueue 扩展方法
extension SwiftBasics where Base: DispatchQueue {
    
    /// 确保指定 token 的闭包在应用程序生命周期内只执行一次
    /// - 使用双重检查锁定机制保证线程安全
    /// - 参数：
    ///   - token: 唯一标识符（推荐使用反向域名格式：com.yourcompany.taskname）
    ///   - callBack: 需要执行一次的闭包
    public func once(token: String, _ callBack: () -> Void) {
        // 第一次无锁快速检查（性能优化）
        guard !DispatchQueue.onceTracker.contains(token) else { return }
        
        // 加锁确保线程安全
        DispatchQueue.lock.lock()
        defer { DispatchQueue.lock.unlock() }
        
        // 二次检查（防止等待锁期间其他线程已完成任务）
        guard !DispatchQueue.onceTracker.contains(token) else { return }
        
        // 标记 token 已执行
        DispatchQueue.onceTracker.insert(token)
        // 执行闭包
        callBack()
    }
    
    /// (已废弃) 确保指定 token 的闭包只执行一次
    /// - 推荐使用 once(token:callBack:) 替代
    @available(*, deprecated, message: "请使用 once(token:_:) 方法")
    public func once(token: String, closure: () -> Void) {
        once(token: token, closure)
    }
}

// 补充说明（在 DispatchQueue 扩展中定义）：
extension DispatchQueue {
    /// 用于保护 onceTracker 的锁
    fileprivate static let lock = NSLock()

    /// 用于存储已执行 token 的集合
    fileprivate static var onceTracker: Set<String> = {
        // 使用线程安全的懒加载初始化
        let queue = DispatchQueue(label: "com.dispatchqueue.oncetracker", attributes: .concurrent)
        var tracker: Set<String> = []
        return tracker
    }()
    
    // MARK: - 异步操作模板

}


extension SwiftBasics where Base: DispatchQueue {
    // MARK: - Type Alias
    public typealias SwiftCallTask = () -> Void
    
    // MARK: - Asynchronous Operations
    
    /// 异步执行任务并在完成后可选地在主线程回调
    /// - Parameters:
    ///   - task: 要在后台队列执行的闭包任务
    ///   - mainTask: 任务完成后在主线程执行的闭包（可选）
    /// - Returns: 可取消的 DispatchWorkItem 对象
    @discardableResult
    public static func async(
        with task: @escaping SwiftCallTask,
        mainTask: SwiftCallTask? = nil
    ) -> DispatchWorkItem {
        let workItem = DispatchWorkItem(block: task)
        DispatchQueue.global().async(execute: workItem)
        
        // 如果提供了主线程回调，则在任务完成后通知主队列
        if let mainTask = mainTask {
            workItem.notify(queue: .main, execute: mainTask)
        }
        
        return workItem
    }
    
    /// 在主队列异步执行任务
    /// - Parameter task: 要在主队列执行的闭包任务
    /// - Returns: 可取消的 DispatchWorkItem 对象
    @discardableResult
    public static func asyncMain(with task: @escaping SwiftCallTask) -> DispatchWorkItem {
        let workItem = DispatchWorkItem(block: task)
        DispatchQueue.main.async(execute: workItem)
        return workItem
    }
    
    /// 通用异步操作封装
    /// - Parameters:
    ///   - operation: 需要在后台线程执行的阻塞操作闭包。返回类型为泛型 T 的可选值。
    ///             注意：避免在闭包内进行UI更新操作，所有UI操作应在completion中处理。
    ///   - completion: 当操作执行完毕后的回调闭包，在主线程执行。接收 operation 的返回结果。
    ///             注意：该闭包可能捕获外部变量，需使用 `[weak self]` 避免循环引用。
    ///   - qos: 指定操作执行的服务质量（优先级），默认为用户交互级别
    public static func asyncOperation<T>(
        _ operation: @escaping () -> T?,
        completion: @escaping (_ result: T?) -> Void,
        qos: DispatchQoS.QoSClass = .userInitiated  // 添加可配置的优先级参数
    ) {
        // 创建专用串行队列（避免使用全局并发队列可能导致的线程爆炸问题）
        let asyncQueue = DispatchQueue(
            label: "com.swiftApp.asyncOperation",
            qos: DispatchQoS(qosClass: qos, relativePriority: 0)
        )
        
        asyncQueue.async {
            // 执行耗时操作，捕获可能发生的崩溃
            let result = operation()
           
            // 确保主线程安全回调
            DispatchQueue.main.async {
                // 添加调试标识（仅Debug模式生效）
                #if DEBUG
                if Thread.isMainThread {
                    SwiftLog.log("✅ 主线程回调已执行")
                } else {
                    SwiftLog.log("⚠️ 警告：未在主线程回调")
                }
                #endif
                completion(result)
            }
        }
    }
    
    // MARK: - Delayed Operations
    
    /// 异步延时执行任务并在完成后可选地在主线程回调
    /// - Parameters:
    ///   - seconds: 延迟时间（秒）
    ///   - task: 要在后台队列执行的闭包任务
    ///   - mainTask: 任务完成后在主线程执行的闭包（可选）
    /// - Returns: 可取消的 DispatchWorkItem 对象
    @discardableResult
    public static func asyncDelay(
        with seconds: TimeInterval,
        task: @escaping SwiftCallTask,
        mainTask: SwiftCallTask? = nil
    ) -> DispatchWorkItem {
        let workItem = DispatchWorkItem(block: task)
        DispatchQueue.global().asyncAfter(
            deadline: .now() + seconds,
            execute: workItem
        )
        
        if let mainTask = mainTask {
            workItem.notify(queue: .main, execute: mainTask)
        }
        
        return workItem
    }
    
    /// 延时后在主队列执行任务
    /// - Parameters:
    ///   - seconds: 延迟时间（秒）
    ///   - mainTask: 要在主队列执行的闭包任务
    /// - Returns: 可取消的 DispatchWorkItem 对象
    @discardableResult
    public static func delay(
        with seconds: TimeInterval,
        mainTask: @escaping SwiftCallTask
    ) -> DispatchWorkItem {
        let workItem = DispatchWorkItem(block: mainTask)
        DispatchQueue.main.asyncAfter(
            deadline: .now() + seconds,
            execute: workItem
        )
        return workItem
    }
    
    /// 在指定队列上延时执行任务
    /// - Parameters:
    ///   - delay: 延迟时间（秒）
    ///   - callBack: 要执行的闭包任务
    public func asyncAfter(
        with delay: TimeInterval,
        _ callBack: @escaping SwiftCallTask
    ) {
        base.asyncAfter(deadline: .now() + delay, execute: callBack)
    }
    
    // MARK: - Thread-Safe Operations
    
    /// 安全地在主线程执行任务（如果当前已在主线程则同步执行）
    /// - Parameter execute: 要执行的闭包任务
    public static func asyncSafeMain(_ execute: @escaping SwiftCallTask) {
        isMainThread ? execute() : DispatchQueue.main.async(execute: execute)
    }
    
    /// 在全局队列安全地执行任务
    /// - Parameter execute: 要执行的闭包任务
    public static func asyncSafeGlobal(_ execute: @escaping SwiftCallTask) {
        DispatchQueue.global(qos: .default).async(execute: execute)
    }
    
    // MARK: - Utility Properties
    
    /// 检查当前是否在主线程
    public static var isMainThread: Bool {
        Thread.current.isMainThread
    }
    
    // MARK: - Deprecated Methods
    
    /// 已废弃 - 使用 asyncAfter(with:_:) 替代
    @available(*, deprecated, message: "Use `asyncAfter(with:_:)` instead")
    public func after(
        with delay: TimeInterval,
        execute closure: @escaping SwiftCallTask
    ) {
        asyncAfter(with: delay, closure)
    }
}
