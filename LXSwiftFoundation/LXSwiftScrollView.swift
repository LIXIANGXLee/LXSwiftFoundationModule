//
//  LXScrollView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/6/17.
//

import UIKit

open class LXSwiftScrollView: UIScrollView {
    
    public typealias RecognizeSimultaneously = ((UIGestureRecognizer,
                                                 UIGestureRecognizer) -> Bool)
    public typealias ShouldBegin =  ((UIGestureRecognizer) -> Bool?)

    public var shouldRecognizeSimultaneously: RecognizeSimultaneously?
    public var shouldBegin: ShouldBegin?

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
    
    open func setShouldRecognizeSimultaneously(_ callBack: RecognizeSimultaneously?) {
        self.shouldRecognizeSimultaneously = callBack
    }
    
    open func setShouldBegin(_ callBack: ShouldBegin?) {
        self.shouldBegin = callBack
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UIGestureRecognizerDelegate
extension LXSwiftScrollView: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer)
    -> Bool {
        let outResult = shouldRecognizeSimultaneously?(gestureRecognizer,
                                                       otherGestureRecognizer)
        return outResult ?? false
    }
    
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer)
    -> Bool {
        let outResult = shouldBegin?(gestureRecognizer)
        return outResult ??
            super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
}

extension LXSwiftScrollView: LXViewSetup {
    @objc open func setupUI() { }
    @objc open func setupViewModel() { }
}
