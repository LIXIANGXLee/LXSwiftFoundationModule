//
//  LXSwift+SegmentedControl.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/10/12.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

//MARK: -  Extending properties and methods for UISegmentedControl
extension LXSwiftBasics where Base : UISegmentedControl {
    
    public func setHandle(segmentedControlCallBack: ((Int?) -> ())?){
        base.swiftCallBack = segmentedControlCallBack
        
        base.addTarget(base, action: #selector(base.segmentedControlAction(_:)), for: .valueChanged)
    }
}

private var segmentedControlCallBackKey: Void?
extension UISegmentedControl: LXSwiftPropertyCompatible {
    
    internal typealias T = Int
    internal var swiftCallBack: SwiftCallBack? {
        get { return getAssociatedObject(self, &segmentedControlCallBackKey) }
        set { setRetainedAssociatedObject(self, &segmentedControlCallBackKey, newValue) }
    }
    
    @objc internal func segmentedControlAction(_ event: UISegmentedControl) {
        self.swiftCallBack?(event.selectedSegmentIndex)
    }
    
}
