//
//  LXSwift+Control.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

//MARK: -  Extending methods for UIControl
extension LXSwiftBasics where Base: UIControl {
    
    /// 防连点击在1s内，时间可自行设置
    public func preventDoubleHit(_ hitTime: Double = 1) {
        base.hitDouble(hitTime)
    }
}

private var hitTimerKey: Void?
extension UIControl  {
    
    private var hitTime: Double? {
        get { return lx_getAssociatedObject(self, &hitTimerKey) }
        set { lx_setRetainedAssociatedObject(self, &hitTimerKey, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    func hitDouble(_ hitTime: Double) {
        self.hitTime = hitTime
        addTarget(self, action: #selector(c_hitDouble(_:)), for: .touchUpInside)
    }
    
    @objc func c_hitDouble(_ base: UIControl)  {
        base.isUserInteractionEnabled = false
        DispatchQueue.lx.delay(with: (hitTime ?? 1.0)) {
            base.isUserInteractionEnabled = true
        }
    }
}
