//
//  Swift+Control.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

//MARK: -  Extending methods for UIControl
extension SwiftBasics where Base: UIControl {
    
    /// 防连点击在1s内，时间可自行设置，有的业务场景如果连续点击多次可能会出现问题，所以有了放连点击处理
    public func preventDoubleHit(forHitTime time: Double = 0.8) {
        base.preventDoubleHit(forHitTime: time)
    }

    /// 添加点击事件回调
    public func addTarget(forControlEvents events: UIControl.Event = .touchUpInside, closure: @escaping ((Any) -> ())) {
        base.swiftAddTarget(forControlEvents: events, closure: closure)
    }
    
    @available(*, deprecated, message:"Use addTarget(for controlEvents:,callBack:)")
    public func setHandle(buttonCallBack: ((_ button: UIButton) -> ())?) {
        addTarget { (objc) in
            if let btn = objc as? UIButton {
                buttonCallBack?(btn)
            }
        }
    }
    
    /// 移除当前所有Target事件
    public func removeAllTargets() {
        base.swiftRemoveAllTargets()
    }
}

private var _swiftControlTargetKey: Void?
extension UIControl  {
    
    /// 设置放连点击的时间间隔
    fileprivate func preventDoubleHit(forHitTime time: Double) {
        swiftAddTarget { (control) in
            let view = control as? UIView
            view?.isUserInteractionEnabled = false
            DispatchQueue.lx.delay(with: time) {
                view?.isUserInteractionEnabled = true
            }
        }
    }

    fileprivate func swiftAddTarget(forControlEvents events: UIControl.Event = .touchUpInside, closure: @escaping ((Any) -> ())) {
        let target = SwiftControlTarget(closure: closure, forControlEvents: events)
        self.addTarget(target, action: #selector(target.invokeTarget(_:)), for: events)
        
        /// 存储target
        swiftAllControlTargets?.add(target)
      
    }

    fileprivate func swiftRemoveAllTargets() {
        
        swiftAllControlTargets?.enumerateObjects({ objc, _, _ in
          
            self.removeTarget(objc, action: nil, for: .allEvents)
        })
        
        /// 移除targets
        swiftAllControlTargets?.removeAllObjects()
        
    }
    
    fileprivate var swiftAllControlTargets: NSMutableArray? {
        get {
           var targets = objc_getAssociatedObject(self, &_swiftControlTargetKey) as? NSMutableArray
            if (targets == nil) {
                targets = NSMutableArray()
                objc_setAssociatedObject(self, &_swiftControlTargetKey, targets, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return targets
        }
    }
}

fileprivate final class SwiftControlTarget {
    var closure: ((Any) -> ())
    var events: UIControl.Event
    
    init(closure: @escaping (Any) -> Void, forControlEvents events: UIControl.Event) {
        self.closure = closure
        self.events = events
    }
    
    @objc func invokeTarget(_ objc: Any) {
        self.closure(objc)
    }
}
