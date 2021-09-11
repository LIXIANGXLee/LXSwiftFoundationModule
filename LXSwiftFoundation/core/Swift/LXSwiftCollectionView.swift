//
//  LXCollectionView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2018/4/23.
//  Copyright © 2018 李响. All rights reserved.
//

import UIKit

@objc(LXObjcCollectionView)
@objcMembers open class LXSwiftCollectionView: UICollectionView {
    
    public typealias RecognizeSimultaneously = ((UIGestureRecognizer, UIGestureRecognizer) -> Bool)
    public typealias ShouldBegin = ((UIGestureRecognizer) -> Bool)

    open var shouldRecognizeSimultaneously: RecognizeSimultaneously?
    open var shouldBegin: ShouldBegin?

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
    
    /// 您是否支持多事件传递
    @objc(setObjcShouldRecognizeSimultaneously:)
    open func setShouldRecognizeSimultaneously(_ callBack: RecognizeSimultaneously?) { self.shouldRecognizeSimultaneously = callBack }
    
    /// 是否允许开始手势
    @objc(setObjcShouldBegin:)
    open func setShouldBegin(_ callBack: ShouldBegin?) { self.shouldBegin = callBack }
}

public extension UICollectionView {

    func registSwiftCell<T: UICollectionViewCell>(_ cell: T.Type) where T: LXSwiftCellCompatible { self.register(cell, forCellWithReuseIdentifier: cell.reusableSwiftIdentifier) }

    func dequeueSwiftReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: LXSwiftCellCompatible { self.dequeueReusableCell(withReuseIdentifier: T.reusableSwiftIdentifier, for: indexPath) as! T }
}

//MARK: - UIGestureRecognizerDelegate
extension LXSwiftCollectionView: UIGestureRecognizerDelegate {
    
    /// 您是否支持多事件传递代理
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool { shouldRecognizeSimultaneously?(gestureRecognizer, otherGestureRecognizer) ?? false }
    
    /// 是否允许开始手势
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool { shouldBegin?(gestureRecognizer) ?? super.gestureRecognizerShouldBegin(gestureRecognizer) }
}

@objcMembers open class LXSwiftCollectionViewCell: UICollectionViewCell, LXSwiftCellCompatible {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupViewModel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LXSwiftCollectionView: LXSwiftUIProtocol {
    @objc open func setupUI() { }
    @objc open func setupViewModel() { }
}

extension LXSwiftCollectionViewCell: LXSwiftUIProtocol {
    @objc open func setupUI() { }
    @objc open func setupViewModel() { }
}
