//
//  LXSwift+DispatchQueue.swift
//  LXSwiftFoundation
//
//  Created by XL on 20127/9/24.
//  Copyright © 2017 李响. All rights reserved.
//

import UIKit

extension DispatchQueue: LXSwiftCompatible {
  
    /// Task callback function
    public typealias LXSwiftCallTask = (() -> Void)

    /// Global collection
    static var onceTracker = Set<String>()
}

//MARK: -  Extending method for UIFont
extension LXSwiftBasics where Base: DispatchQueue {
  
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
    public func once(token: String, closure: () -> Void) { once(token: token, closure) }
}

//MARK: -  Extending method for UIFont
extension LXSwiftBasics where Base: DispatchQueue {
    
    /// 异步任务 主线程回调执行任务(主线程回调任务可不传，默认是nil)
    public static func async(with task: @escaping DispatchQueue.LXSwiftCallTask, mainTask: DispatchQueue.LXSwiftCallTask? = nil) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: task)
        DispatchQueue.global().async(execute: item)
        if let main = mainTask { item.notify(queue: DispatchQueue.main, execute: main) }
        return item
    }
    
    /// 主线程执行任务
    @discardableResult
    public static func asyncMain(with task: @escaping DispatchQueue.LXSwiftCallTask) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: task)
        DispatchQueue.main.async(execute: item)
        return item
    }
    
    /// 异步延时任务 主线程回调执行任务(主线程回调任务可不传，默认是nil)
    @discardableResult
    public static func asyncDelay(with seconds: TimeInterval, task: @escaping DispatchQueue.LXSwiftCallTask, mainTask: DispatchQueue.LXSwiftCallTask? = nil) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: task)
        let s = DispatchTime.now() + seconds
        DispatchQueue.global().asyncAfter(deadline: s, execute: item)
        if let main = mainTask { item.notify(queue: DispatchQueue.main, execute: main) }
        return item
    }
    
    /// 延时后主线程执行任务
    @discardableResult
    public static func delay(with seconds: TimeInterval, mainTask: @escaping DispatchQueue.LXSwiftCallTask) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: mainTask)
        let s = DispatchTime.now() + seconds
        DispatchQueue.main.asyncAfter(deadline: s, execute: item)
        return item
    }
    
    /// 延时后主线程执行任务 (自定义线程类型，例如：DispatchQueue.main主线程、DispatchQueue.global()全局线程等等)
    public func asyncAfter(with delay: TimeInterval, _ callBack: @escaping () -> Void) {  base.asyncAfter(deadline: .now() + delay, execute: callBack) }
    
    /// 延时后主线程执行任务 (自定义线程类型，例如：DispatchQueue.main主线程、DispatchQueue.global()全局线程等等)
    @available(*, deprecated, message:"Use asyncAfter(with delay:,_ callBack:)")
    public func after(with delay: TimeInterval, execute closure: @escaping () -> Void) { asyncAfter(with: delay, closure) }

}
