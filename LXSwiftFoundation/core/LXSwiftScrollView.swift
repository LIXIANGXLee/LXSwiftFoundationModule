//
//  LXScrollView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2018/4/23.
//  Copyright © 2018 李响. All rights reserved.
//

import UIKit

@objc(LXObjcScrollView)
@objcMembers open class LXSwiftScrollView: UIScrollView {
    
    public typealias RecognizeSimultaneously = ((UIGestureRecognizer, UIGestureRecognizer) -> Bool)
    public typealias ShouldBegin =  ((UIGestureRecognizer) -> Bool?)

    open var shouldRecognizeSimultaneously: RecognizeSimultaneously?
    open var shouldBegin: ShouldBegin?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        } else {
            translatesAutoresizingMaskIntoConstraints = false
        }
        setupUI()
        setupViewModel()
    }
    
    /// 您是否支持多事件传递
    @objc(setObjcShouldRecognizeSimultaneously:)
    open func setShouldRecognizeSimultaneously(_ callBack: RecognizeSimultaneously?) { self.shouldRecognizeSimultaneously = callBack }
    
    /// 是否允许开始手势
    open func setShouldBegin(_ callBack: ShouldBegin?) { self.shouldBegin = callBack }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UIGestureRecognizerDelegate
extension LXSwiftScrollView: UIGestureRecognizerDelegate {
   
    /// 您是否支持多事件传递代理
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool { shouldRecognizeSimultaneously?(gestureRecognizer, otherGestureRecognizer) ?? false }
    
    /// 是否允许开始手势
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool { shouldBegin?(gestureRecognizer) ?? super.gestureRecognizerShouldBegin(gestureRecognizer) }
}

extension LXSwiftScrollView: LXSwiftUIProtocol {
    @objc open func setupUI() { }
    @objc open func setupViewModel() { }
}
