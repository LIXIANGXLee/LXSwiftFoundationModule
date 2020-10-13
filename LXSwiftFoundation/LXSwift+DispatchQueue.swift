//
//  LXSwift+DispatchQueue.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// Task callback function
public typealias LXSwiftCallTask = () -> Void

extension DispatchQueue: LXSwiftCompatible {
    /// Global collection
    internal static var onceTracker = Set<String>()
    
}

//MARK: -  Extending method for UIFont
extension LXSwiftBasics where Base: DispatchQueue {
    
    ///Double negation to prevent concurrent access
    ///
    /// - Parameter token: A string used to determine whether it is unique
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
    /// - Parameter task: Asynchronous callback function
    public static func async(_ task: @escaping LXSwiftCallTask) {
        _async(task)
    }
    
    ///Asynchronous task
    ///
    /// - Parameter task: Asynchronous callback function
    /// - Parameter mainTask: Main thread callback function
    public static func async(_ task: @escaping LXSwiftCallTask,
                             _ mainTask: @escaping LXSwiftCallTask) {
        _async(task, mainTask)
    }
    
    ///Asynchronous task
    ///- parameter seconds: time to delay
    ///- parameter block: asynchronous callback function
    @discardableResult
    public func delay(_ seconds: Double,
                      _ block: @escaping LXSwiftCallTask) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: block)
        base.asyncAfter(deadline: DispatchTime.now() + seconds,
                        execute: item)
        return item
    }
    
    ///Asynchronous task
    ///- parameter seconds: time to delay
    ///- parameter task: asynchronous callback function
    @discardableResult
    public func asyncDelay(_ seconds: Double,
                           _ task: @escaping LXSwiftCallTask) -> DispatchWorkItem {
        return _asyncDelay(seconds, task)
    }
    
    ///Asynchronous task
    ///- parameter seconds: time to delay
    ///- parameter task: asynchronous callback function
    ///- parameter maintask: asynchronous callback function
    @discardableResult
    public func asyncDelay(_ seconds: Double,
                           _ task: @escaping LXSwiftCallTask,
                           _ mainTask: @escaping LXSwiftCallTask) -> DispatchWorkItem {
        return _asyncDelay(seconds, task, mainTask)
    }
    
    ///Asynchronous task private method
    private static func _async(_ task: @escaping LXSwiftCallTask,
                               _ mainTask: LXSwiftCallTask? = nil) {
        let item = DispatchWorkItem(block: task)
        DispatchQueue.global().async(execute: item)
        if let main = mainTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
    }
    
    ///Private method of asynchronous delay task
    private func _asyncDelay(_ seconds: Double,
                             _ task: @escaping LXSwiftCallTask,
                             _ mainTask: LXSwiftCallTask? = nil) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: task)
        base.asyncAfter(deadline: DispatchTime.now() + seconds,
                        execute: item)
        if let main = mainTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
        return item
    }
}
