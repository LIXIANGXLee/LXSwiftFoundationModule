//
//  SwiftGCDTimer.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

// MARK: - GCD定时器管理类
/// 一个使用GCD实现的线程安全定时器管理工具，支持倒计时和重复任务。
@objc(LXObjcTimer)
@objcMembers public final class SwiftTimer: NSObject {
    
    /// 存储所有定时器的字典，键为定时器唯一标识符
    private static var timers = [String: DispatchSourceTimer]()
    
    /// 线程安全锁，确保对定时器字典的原子操作
    private static let lock = NSLock()
    
    // MARK: - 公开方法
    
    /// 启动GCD定时器
    /// - 参数:
    ///   - delaySeconds: 首次执行延迟时间（秒），默认0
    ///   - interval: 执行间隔时间（秒），默认1
    ///   - repeats: 是否重复执行，默认true
    ///   - identifier: 定时器唯一标识符
    ///   - task: 要执行的任务闭包
    public static func startTimer(with delaySeconds: TimeInterval = 0,
                                  interval: TimeInterval = 1,
                                  repeats: Bool = true,
                                  identifier: String?,
                                  handler: (() -> Void)?) {
        // 参数有效性检查
        guard let iden = identifier,
              delaySeconds >= 0,
              interval >= 0,
              handler != nil else {
            return
        }
        
        // 创建定时器队列（默认全局后台队列）
        let queue = DispatchQueue.global()
        
        // 线程安全操作
        lock.lock()
        // 移除已存在的同名定时器
        if let existingTimer = timers[iden] {
            existingTimer.cancel()
            timers.removeValue(forKey: iden)
        }
        lock.unlock()
        
        // 创建定时器
        let timer = DispatchSource.makeTimerSource(queue: queue)
        
        // 计算重复间隔（非重复任务设为0）
        let repeatingInterval = repeats ? interval : 0
        
        // 配置定时器触发时间
        timer.schedule(
            deadline: .now() + delaySeconds,
            repeating: repeatingInterval
        )
        
        // 存储定时器
        lock.lock()
        timers[iden] = timer
        lock.unlock()
        
        // 设置事件处理器
        timer.setEventHandler {
            // 主线程执行任务
            DispatchQueue.lx.asyncMain { handler?() }
            
            // 单次任务执行后自动移除
            if !repeats { cancel(with: iden) }
        }
        
        // 启动定时器
        timer.resume()
    }
    
    /// 启动倒计时定时器
    /// - 参数:
    ///   - maxInterval: 倒计时总时长（秒），默认60
    ///   - interval: 时间间隔（秒），默认1
    ///   - identifier: 定时器唯一标识符
    ///   - task: 倒计时回调（剩余秒数）
    public static func startCountDown(maxInterval: TimeInterval = 60,
                                     interval: TimeInterval = 1,
                                     identifier: String?,
                                     task: ((Int) -> Void)?) {
        // 参数有效性检查
        guard maxInterval >= 0,
              interval >= 0 else {
            return
        }
        
        var remainingTime = maxInterval
        
        startTimer(
            with: 0,
            interval: interval,
            repeats: true,
            identifier: identifier) {
            remainingTime -= interval
            let current = Int(max(remainingTime, 0))
            
            // 倒计时结束处理
            if remainingTime <= 0 {
                cancel(with: identifier)
            }
            
            task?(current)
        }
    }
    
    /// 取消指定定时器
    /// - 参数 identifier: 要取消的定时器标识符
    public static func cancel(with identifier: String?) {
        guard let iden = identifier else { return }
        
        lock.lock()
        defer { lock.unlock() }
        
        if let timer = timers[iden] {
            timer.cancel()
            timers.removeValue(forKey: iden)
        }
    }
    
    /// 取消所有定时器
    public static func cancelAllTimers() {
        lock.lock()
        defer { lock.unlock() }
        
        timers.values.forEach { $0.cancel() }
        timers.removeAll()
    }
}

