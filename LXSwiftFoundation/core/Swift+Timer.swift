//
//  Swift+Timer.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/8/3.
//

import UIKit

//MARK: -  Extending methods for NSNumber
extension SwiftBasics where Base: Timer {
    
    @discardableResult
    public func scheduledTimer(with Interval: TimeInterval, repeats: Bool = true, block: @escaping (Timer) -> Void) -> Timer {
        let timer = Timer.scheduledTimer(timeInterval: Interval, target: base, selector: #selector(base._execBlock(timer:)), userInfo: block, repeats: repeats)
        RunLoop.current.add(timer, forMode: .common)
        return timer
    }
    
    @discardableResult
    public func timer(with Interval: TimeInterval, repeats: Bool = true, block: @escaping (Timer) -> ()) -> Timer {
        let timer = Timer(timeInterval: Interval, target: base, selector:  #selector(base._execBlock(timer:)), userInfo: block, repeats: repeats)
        RunLoop.current.add(timer, forMode: .common)
        return timer
    }    
}
 
