//
//  LXCollectionView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/4/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

open class LXSwiftCollectionView: UICollectionView {
    
    public typealias RecognizeSimultaneously = ((UIGestureRecognizer, UIGestureRecognizer) -> Bool)
    public typealias ShouldBegin =  ((UIGestureRecognizer) -> Bool?)

    public var shouldRecognizeSimultaneously: RecognizeSimultaneously?
    public var shouldBegin: ShouldBegin?

    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = UIColor.white
        //适配iOS 11
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }else {
            translatesAutoresizingMaskIntoConstraints = false
        }
        setupUI()
        setupViewModel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setShouldRecognizeSimultaneously(_ callBack: RecognizeSimultaneously?) {
        self.shouldRecognizeSimultaneously = callBack
    }
    
    func setShouldBegin(_ callBack: ShouldBegin?) {
        self.shouldBegin = callBack
    }
}

public extension LXSwiftCollectionView {

    func registCell<T: UICollectionViewCell>(_ cell: T.Type) where T: LXSwiftCellCompatible {
        self.register(cell, forCellWithReuseIdentifier: cell.reusableIdentifier)
    }

    func dequeueGenericReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: LXSwiftCellCompatible {
        return self.dequeueReusableCell(withReuseIdentifier: T.reusableIdentifier, for: indexPath) as! T
    }
}

//MARK: - UIGestureRecognizerDelegate
extension LXSwiftCollectionView: UIGestureRecognizerDelegate {
    
    /// Do you support multiple event delivery delegate
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let outResult = shouldRecognizeSimultaneously?(gestureRecognizer, otherGestureRecognizer)
        return outResult ?? true
    }
    
    /// is can event
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let outResult = shouldBegin?(gestureRecognizer)
        return outResult ??
            super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
}

extension LXSwiftCollectionView: LXViewSetup {
    open func setupUI() { }
    open func setupViewModel() {}
    
}

open class LXSwiftCollectionViewCell<U>: UICollectionViewCell, LXSwiftCellCompatible {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupViewModel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LXSwiftCollectionViewCell: LXViewSetup {
    open func setupUI() {}
    open func setupViewModel() {}
    
}
