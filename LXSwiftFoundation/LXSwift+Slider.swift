//
//  LXSwift+Slider.swift
//  LXFitManager
//
//  Created by XL on 2020/10/12.
//

import UIKit

//MARK: -  Extending properties and methods for UISlider
extension LXSwiftBasics where Base : UISlider {
    
    public func setHandle(sliderCallBack: ((Float?) -> ())?){
        base.swiftCallBack = sliderCallBack
        base.addTarget(base, action: #selector(base.sliderSwitchAction(_:)), for: .touchUpInside)
    }
}

private var sliderCallBackKey: Void?
extension UISlider: LXSwiftPropertyCompatible {
    typealias T = Float
    var swiftCallBack: SwiftCallBack? {
        get { return lx_getAssociatedObject(self, &sliderCallBackKey) }
        set { lx_setRetainedAssociatedObject(self, &sliderCallBackKey, newValue) }
    }
    
    @objc func sliderSwitchAction(_ event: UISlider) {
        self.swiftCallBack?(event.value)
    }
    
}
