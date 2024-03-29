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

//MARK: -  Extending method for UIFont
extension SwiftBasics where Base: DispatchQueue {
    
    /// 异步任务 主线程回调执行任务(主线程回调任务可不传，默认是nil)
    public static func async(with task: @escaping DispatchQueue.SwiftCallTask, mainTask: DispatchQueue.SwiftCallTask? = nil) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: task)
        DispatchQueue.global().async(execute: item)
        if let main = mainTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
        return item
    }
    
    /// 主线程执行任务
    @discardableResult
    public static func asyncMain(with task: @escaping DispatchQueue.SwiftCallTask) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: task)
        DispatchQueue.main.async(execute: item)
        return item
    }
    
    /// 异步延时任务 主线程回调执行任务(主线程回调任务可不传，默认是nil)
    @discardableResult
    public static func asyncDelay(with seconds: TimeInterval, task: @escaping DispatchQueue.SwiftCallTask, mainTask: DispatchQueue.SwiftCallTask? = nil) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: task)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + seconds, execute: item)
        if let main = mainTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
        return item
    }
    
    /// 延时后主线程执行任务
    @discardableResult
    public static func delay(with seconds: TimeInterval, mainTask: @escaping DispatchQueue.SwiftCallTask) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: mainTask)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds, execute: item)
        return item
    }
    
    /// 延时后主线程执行任务 (自定义线程类型，例如：DispatchQueue.main主线程、DispatchQueue.global()全局线程等等)
    public func asyncAfter(with delay: TimeInterval, _ callBack: @escaping () -> Void) {
        base.asyncAfter(deadline: .now() + delay, execute: callBack)
    }
    
    /// 延时后主线程执行任务 (自定义线程类型，例如：DispatchQueue.main主线程、DispatchQueue.global()全局线程等等)
    @available(*, deprecated, message:"Use asyncAfter(with delay:,_ callBack:)")
    public func after(with delay: TimeInterval, execute closure: @escaping () -> Void) {
        asyncAfter(with: delay, closure)
        
    }

    /// 在主线程执行任务
    public static func asyncSafeMain(_ execute: @escaping () -> ()) {
        if isMainThread {
            execute()
        } else {
            DispatchQueue.main.async(execute: execute)
        }
    }
    
    /// 是否为主线成
    public static var isMainThread: Bool {
        Thread.current.isMainThread
    }
    
    /// 子线程执行任务
    public static func asyncSafeGlobal(_ execute: @escaping () -> ()) {
        DispatchQueue.global(qos: .default).async(execute: execute)
    }

}
