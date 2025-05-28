//
//  Swift+DispatchQueue.swift
//  LXSwiftFoundation
//
//  Created by XL on 20127/9/24.
//  Copyright © 2017 李响. All rights reserved.
//

import UIKit

//MARK: -  Extending method for UIFont
extension SwiftBasics where Base: DispatchQueue {
  
    /// 双重否定以防止并发访问 只执行一次任务
    public func once(token: String, _ callBack: () -> Void) {
        if DispatchQueue.onceTracker.contains(token) == false {
            objc_sync_enter(base)
            if DispatchQueue.onceTracker.contains(token) == false {
                DispatchQueue.onceTracker.insert(token)
                callBack()
            }
            objc_sync_exit(base)
        }
    }
    
    /// 双重否定以防止并发访问 只执行一次任务
    @available(*, deprecated, message:"Use once(token: String, _ callBack:() -> Void)")
    public func once(token: String, closure: () -> Void) {
        once(token: token, closure)
    }
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
