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
    
    /// 防连点击在1s内，时间可自行设置，有的业务场景如果连续点击多次可能会出现问题，所以有了放连点击处理
    public func preventDoubleHit(_ hitTime: Double = 1) { base.hitDouble(hitTime) }
    
    /// 添加点击事件回调(注意：只能添加一处事件，多次添加会被覆盖，直取最后一次事件监听，如果想多处需要监听，库里提供oc方法方案)调用 lx_addBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block 方法就OK了，但建议还是一处监听为好，避免业务复杂处理起来出bug

    public func addTarget(for controlEvents: UIControl.Event = .touchUpInside, callBack: @escaping ((Any) -> ())) {
        base.callBack = callBack
        base.addTarget(base, action: #selector(base.swiftAction(_:)), for: controlEvents)
    }
    
    @available(*, deprecated, message:"Use addTarget(for controlEvents:,callBack:)")
    public func setHandle(buttonCallBack: ((_ button: UIButton) -> ())?) {
        addTarget { (objc) in if let btn = objc as? UIButton { buttonCallBack?(btn) } }
    }
    
    /// 移除Target事件，移除的是单事件Target，配合addTarget(for controlEvents: UIControl.Event = .touchUpInside, callBack: @escaping ((Any) -> ()))使用，如果用oclx_addBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block方法的话，可以配合lx_removeAllBlocks移除方法使用
    public func removeTarget() {
        base.removeTarget(base, action: nil, for: .allEvents)
        lx_removeAssociatedObjects(base)
    }
}

private var hitTimerKey: Void?
private var controlCallBackKey: Void?
extension UIControl  {
    
    fileprivate var hitTime: Double? {
        get { lx_getAssociatedObject(self, &hitTimerKey) }
        set { lx_setRetainedAssociatedObject(self, &hitTimerKey, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    /// 设置放连点击的时间间隔
    fileprivate func hitDouble(_ hitTime: Double) {
        self.hitTime = hitTime
        self.addTarget(self, action: #selector(swiftHitDouble(_:)), for: .touchUpInside)
    }
    
    /// 防连点击事件响应
    @objc fileprivate func swiftHitDouble(_ base: UIControl)  {
        base.isUserInteractionEnabled = false
        DispatchQueue.lx.delay(with: (hitTime ?? 1.0)) { base.isUserInteractionEnabled = true }
    }
    
    /// 保存事件到runtime
    fileprivate var callBack: ((Any) -> ())? {
        get { lx_getAssociatedObject(self, &controlCallBackKey) }
        set { lx_setRetainedAssociatedObject(self, &controlCallBackKey, newValue) }
    }
    
    /// 响应事件
    @objc fileprivate func swiftAction(_ objc: Any) { callBack?(objc) }
}

