//
//  LXScrollView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/6/17.
//

import UIKit

open class LXSwiftScrollView: UIScrollView,LXSwiftUICompatible {
    public var swiftModel: Any?
   
    /// Do you support multiple event delivery
    public var isSopportRecognizeSimultaneous = false

    public override init(frame: CGRect) {
        super.init(frame: frame)
           backgroundColor = UIColor.white

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

//MARK: - UIGestureRecognizerDelegate
extension LXSwiftScrollView: UIGestureRecognizerDelegate {
  
    ///Do you support multiple event delivery delegate
     public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
         return isSopportRecognizeSimultaneous
     }
    
}

extension LXSwiftScrollView: LXViewSetup {
 
    open func setupUI() { }
    open func setupViewModel() {}

}
