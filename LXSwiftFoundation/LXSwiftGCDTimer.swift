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
    
    ///Timer set
    fileprivate static var timers = [String:DispatchSourceTimer]()
    /// DispatchSemaphore
    fileprivate static let semaphore = DispatchSemaphore(value: 1)
    
}

//MARK: -  Extending methods for Date
extension LXSwiftBasics where Base == LXSwiftGCDTimer {
    /// start timer once
    ///
    /// - Parameters:
    ///   - identified: save identified
    public static func startDelay(_ timer: TimeInterval,
                                  identified: String?,
                                  task: LXSwiftGCDTimer.TaskCallBack?) {
        start(with: timer,
              timeInterval: 1,
              repeats: false,
              identified: identified,
              task: task)
    }
    
    /// start timer repeats
    ///
    /// - Parameters:
    ///   - identified: save identified
    public static func startDelayRepeats(_ timer: TimeInterval,
                                         identified: String?,
                                         task: LXSwiftGCDTimer.TaskCallBack?) {
        start(with: timer,
              timeInterval: 1,
              repeats: false,
              identified: identified,
              task: task)
    }
    
    /// start timer repeats
    ///
    /// - Parameters:
    ///   - totalTimeInterval  total time
    ///   - identified:  save identified
    public static func startCountDown(totalTimeInterval: TimeInterval = 60,
                                      identified: String?,
                                      task: ((Int)->())?){
        
        var total = totalTimeInterval
        start(with: 0,
              timeInterval: 1,
              repeats: true,
              identified: identified) {
            total -= 1
            if total <= 0 { cancel(with: identified)   }
            task?(Int(total))
        }
    }
    
    /// start timer repeats
    ///
    /// - Parameters:
    ///   - identified:  save identified
    public static func start(with startTimer: TimeInterval = 0,
                             timeInterval: TimeInterval = 1,
                             repeats: Bool = true,
                             identified: String?,
                             task: LXSwiftGCDTimer.TaskCallBack?){
        
        guard let iden = identified,
              startTimer >= 0,
              timeInterval >= 0,
              task != nil else { return }
        
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        timer.schedule(deadline: .now() + startTimer,
                       repeating: timeInterval)
        
        /// sync
        LXSwiftGCDTimer.semaphore.wait()
        defer { LXSwiftGCDTimer.semaphore.signal() }
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
    
    /// cancel timer repeats
    ///
    /// - Parameters:
    ///   - identified: save identified
    public static func cancel(with identified: String?) {
        
        guard let iden = identified else { return }
        LXSwiftGCDTimer.semaphore.wait()
        defer { LXSwiftGCDTimer.semaphore.signal() }
        
        if let timer = LXSwiftGCDTimer.timers[iden] {
            timer.cancel()
            LXSwiftGCDTimer.timers.removeValue(forKey: iden)
        }
    }
}
