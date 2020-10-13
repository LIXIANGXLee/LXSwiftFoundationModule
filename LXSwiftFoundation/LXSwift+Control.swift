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
    public func preventDoubleHit() {
        base.preventDoubleHit()
    }
}

extension UIControl  {
    
    internal func preventDoubleHit() {
        addTarget(self, action: #selector(c_preventDoubleHit), for: .touchUpInside)
    }
    
    @objc internal func c_preventDoubleHit(_ base: UIControl)  {
        base.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) { base.isUserInteractionEnabled = true }
    }
}
