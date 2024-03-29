//
//  LXSwift+Switch.swift
//  LXSwiftFoundationModule
//
//  Created by XL on 2020/10/11.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

//MARK: -  Extending properties and methods for UISwitch
extension LXSwiftBasics where Base : UISwitch {
    
    public func setHandle(switchCallBack: ((_ isOn: Bool) -> ())?){
        base.swiftCallBack = switchCallBack
        base.addTarget(base, action: #selector(base.swiftSwitchAction(_:)),for: .valueChanged)
    }   
}

private var switchCallBackKey: Void?
extension UISwitch: LXSwiftPropertyCompatible {
    typealias T = Bool
    var swiftCallBack: SwiftCallBack? {
        get { return lx_getAssociatedObject(self, &switchCallBackKey) }
        set { lx_setRetainedAssociatedObject(self, &switchCallBackKey, newValue) }
    }
    
    @objc func swiftSwitchAction(_ event: UISwitch) {
        self.swiftCallBack?(event.isOn)
    }
}
