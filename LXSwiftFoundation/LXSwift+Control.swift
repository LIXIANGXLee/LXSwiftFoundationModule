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
        base.preventDoubleHit(hitTime)
    }
}

private var hitTimerKey: Void?
extension UIControl  {
    private var hitTime: Double {
        set {
            objc_setAssociatedObject(self, &hitTimerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &hitTimerKey) as! Double
        }
    }
    
    internal func preventDoubleHit(_ hitTime: Double) {
        self.hitTime = hitTime
        addTarget(self, action: #selector(c_preventDoubleHit), for: .touchUpInside)
    }
    
    @objc internal func c_preventDoubleHit(_ base: UIControl)  {
        base.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + hitTime) { base.isUserInteractionEnabled = true }
    }
}
