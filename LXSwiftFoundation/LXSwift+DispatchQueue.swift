//
//  LXSwift+DispatchQueue.swift
//  LXSwiftFoundationModule
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// 任务回调函数
public typealias LXCallTask = () -> Void

extension DispatchQueue: LXCompatible {
    /// 全局集合
    internal static var onceTracker = Set<String>()
    
}

//MARK: -  Extending method for UIFont
extension LXSwiftBasics where Base: DispatchQueue {
    
    ///双重否定,防止出现并发访问情况
    ///
    /// - Parameter token: 用于判断是否唯一的字符串
    public func once(token: String, closure:() -> Void) {
        
        if DispatchQueue.onceTracker.contains(token) == false {
            objc_sync_enter(base)
            if DispatchQueue.onceTracker.contains(token) == false {
                DispatchQueue.onceTracker.insert(token)
                closure()
            }
            objc_sync_exit(base)
        }
    }
}

//MARK: -  Extending method for UIFont
extension LXSwiftBasics where Base: DispatchQueue {
    ///异步任务
    ///
    /// - Parameter task: 异步回调函数
    public static func async(_ task: @escaping LXCallTask) {
        _async(task)
    }
    
    ///异步任务
    ///
    /// - Parameter task: 异步回调函数
    /// - Parameter mainTask: 主线程回调函数
    public static func async(_ task: @escaping LXCallTask,
                             _ mainTask: @escaping LXCallTask) {
        _async(task, mainTask)
    }
    
    ///异步任务
    ///
    /// - Parameter seconds: 需要延时的时间
    /// - Parameter block: 异步回调函数
    @discardableResult
    public func delay(_ seconds: Double,
                             _ block: @escaping LXCallTask) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: block)
        base.asyncAfter(deadline: DispatchTime.now() + seconds,
                                      execute: item)
        return item
    }
    
    ///异步任务
    ///
    /// - Parameter seconds: 需要延时的时间
    /// - Parameter task: 异步回调函数
    @discardableResult
    public func asyncDelay(_ seconds: Double,
                                  _ task: @escaping LXCallTask) -> DispatchWorkItem {
        return _asyncDelay(seconds, task)
    }
    ///异步任务
    ///
    /// - Parameter seconds: 需要延时的时间
    /// - Parameter task: 异步回调函数
    /// - Parameter mainTask: 异步回调函数

    @discardableResult
    public func asyncDelay(_ seconds: Double,
                                  _ task: @escaping LXCallTask,
                                  _ mainTask: @escaping LXCallTask) -> DispatchWorkItem {
        return _asyncDelay(seconds, task, mainTask)
    }
    
    ///异步任务  私有方法
    private static func _async(_ task: @escaping LXCallTask,
                               _ mainTask: LXCallTask? = nil) {
        let item = DispatchWorkItem(block: task)
        DispatchQueue.global().async(execute: item)
        if let main = mainTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
    }
    
    ///异步延时任务 私有方法
    private func _asyncDelay(_ seconds: Double,
                                    _ task: @escaping LXCallTask,
                                    _ mainTask: LXCallTask? = nil) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: task)
        base.asyncAfter(deadline: DispatchTime.now() + seconds,
                                          execute: item)
        if let main = mainTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
        return item
    }
}
