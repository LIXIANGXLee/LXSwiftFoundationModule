//
//  LXSwiftGCDTimer.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

// MARK: - timer（GCD）
public struct LXSwiftGCDTimer: LXSwiftCompatible {
    
    public typealias TaskCallBack = (() -> Void)
    
    /// Timer set
    fileprivate static var timers = [String: DispatchSourceTimer]()
}

//MARK: -  Extending methods for Date
extension LXSwiftBasics where Base == LXSwiftGCDTimer {
  
    /// 开启定时器 （延迟定时器） 任务只执行一次
    ///
    /// - Parameters:
    ///   - identified: save identified
    public static func startDelay(_ timer: TimeInterval, identified: String?,
                                  task: LXSwiftGCDTimer.TaskCallBack?) {
        start(with: timer, timeInterval: 1, repeats: false,
              identified: identified,  task: task)
    }
    
    /// 开启定时器 （延迟定时器） 任务重复执行
    ///
    /// - Parameters:
    ///   - identified: save identified
    public static func startDelayRepeats(_ timer: TimeInterval, identified: String?,
                                         task: LXSwiftGCDTimer.TaskCallBack?) {
        start(with: timer, timeInterval: 1, repeats: true,
              identified: identified, task: task)
    }
    
    /// 开启定时器 倒计时
    ///
    /// - Parameters:
    ///   - totalTimeInterval  total time
    ///   - identified:  save identified
    public static func startCountDown(totalTimeInterval: TimeInterval = 60,
                                      identified: String?, task: ((Int)->())?){
        var total = totalTimeInterval
        start(with: 0, timeInterval: 1,
              repeats: true, identified: identified) {
            total -= 1
            if total <= 0 { cancel(with: identified) }
            task?(Int(total))
        }
    }
    
    /// 开始定时器
    ///
    /// - Parameters:
    ///   - identified:  save identified
    public static func start(with startTimer: TimeInterval = 0,
                             timeInterval: TimeInterval = 1,
                             repeats: Bool = true, identified: String?,
                             task: LXSwiftGCDTimer.TaskCallBack?){
        guard let iden = identified, startTimer >= 0,
              timeInterval >= 0, task != nil else { return }
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        timer.schedule(deadline: .now() + startTimer,
                       repeating: timeInterval)
        LXSwiftGCDTimer.timers[iden] = timer
        timer.setEventHandler(handler: {
            DispatchQueue.main.async { task?() }
            if !repeats && !timer.isCancelled{
                timer.cancel()
            }
        })
        //start timer
        timer.resume()
    }
    
    /// 取消定时器
    ///
    /// - Parameters:
    ///   - identified: save identified
    public static func cancel(with identified: String?) {
        guard let iden = identified else { return }
        if let timer = LXSwiftGCDTimer.timers[iden] {
            timer.cancel()
            LXSwiftGCDTimer.timers.removeValue(forKey: iden)
        }
    }
}
