//
//  LXScrollView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/6/17.
//

import UIKit

open class LXSwiftScrollView: UIScrollView,LXSwiftUICompatible {
    public var swiftModel: Any?
   
    /// 是否支持 多个事件传递
    public var isSopportRecognizeSimultaneous = false

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

//MARK: - UIGestureRecognizerDelegate
extension LXSwiftScrollView: UIGestureRecognizerDelegate {
  
    /// 多个事件传递 共存
     public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
         return isSopportRecognizeSimultaneous
     }
    
}

extension LXSwiftScrollView: LXViewSetup {
 
    open func setupUI() { }
    open func setupViewModel() {}

}
