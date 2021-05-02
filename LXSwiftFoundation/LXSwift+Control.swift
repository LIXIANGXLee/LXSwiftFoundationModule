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
    
    // repeat tap in 1s
    public func preventDoubleHit(_ hitTime: Double = 1) {
        base.hitDouble(hitTime)
    }
}

private var hitTimerKey: Void?
extension UIControl  {
    
    private var hitTime: Double? {
        get { return lx_getAssociatedObject(self,
                                            &hitTimerKey) }
        set { lx_setRetainedAssociatedObject(self,
                                             &hitTimerKey,
                                             newValue,
                                             .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    internal func hitDouble(_ hitTime: Double) {
        self.hitTime = hitTime
        addTarget(self, action: #selector(c_hitDouble(_:)),
                  for: .touchUpInside)
    }
    
    @objc internal func c_hitDouble(_ base: UIControl)  {
        base.isUserInteractionEnabled = false
        DispatchQueue.main.lx.delay((hitTime ?? 1.0)) {
            base.isUserInteractionEnabled = true
        }
    }
}
