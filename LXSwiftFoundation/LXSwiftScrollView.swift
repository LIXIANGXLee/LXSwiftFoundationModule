//
//  LXScrollView.swift
//  LXFitManager
//
//  Created by Mac on 2020/6/17.
//

import UIKit

open class LXSwiftScrollView: UIScrollView,LXSwiftUICompatible {
    public var swiftModel: Any?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
           if #available(iOS 11.0, *) {
              contentInsetAdjustmentBehavior = .never
           }else {
              translatesAutoresizingMaskIntoConstraints = false
           }
           setupUI()
           setupViewModel()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LXSwiftScrollView: LXViewSetup {
 
    open func setupUI() { }
    open func setupViewModel() {}

}
