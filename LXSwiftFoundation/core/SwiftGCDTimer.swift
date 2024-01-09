//
//  SwiftGCDTimer.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

// MARK: - timer（GCD）
@objc(LXObjcGCDTimer)
@objcMembers public final class SwiftGCDTimer: NSObject {
    
    public typealias TaskCallBack = (() -> Void)
    fileprivate static var timers = [String: DispatchSourceTimer]()

    /// 开始GCD定时器
    public static func startTimer(with delaySeconds: TimeInterval = 0,
                                  interval: TimeInterval = 1,
                                  repeats: Bool = true,
                                  identified: String?,
                                  task: SwiftGCDTimer.TaskCallBack?) {
        
        guard let iden = identified, delaySeconds >= 0,
              interval >= 0, task != nil else {
            return
        }
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        timer.schedule(deadline: .now() + delaySeconds, repeating: interval)
        SwiftGCDTimer.timers[iden] = timer
        timer.setEventHandler(handler: {
            DispatchQueue.lx.asyncMain {
                task?()
            }
            if !repeats && !timer.isCancelled {
                timer.cancel()
            }
        })
        timer.resume()
    }
    
    /// 开启定时器 倒计时
    public static func startCountDown(maxInterval: TimeInterval = 60,
                                      interval: TimeInterval = 1,
                                      identified: String?,
                                      task: ((Int)->())?) {
        var total = maxInterval
        startTimer(with: 0, interval: interval, repeats: true, identified: identified) {
            total -= 1
            if total <= 0 {
                cancel(with: identified)
            }
            task?(Int(total))
        }
    }
    
    /// 取消GCD定时器
    public static func cancel(with identified: String?) {
        guard let iden = identified else {
            return
        }
        if let timer = SwiftGCDTimer.timers[iden] {
            timer.cancel()
            SwiftGCDTimer.timers.removeValue(forKey: iden)
        }
    }
}
