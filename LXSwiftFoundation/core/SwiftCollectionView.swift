//
//  CollectionView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2018/4/23.
//  Copyright © 2018 李响. All rights reserved.
//

import UIKit

@objc(LXObjcCollectionView)
@objcMembers open class SwiftCollectionView: UICollectionView {
    
    public typealias RecognizeSimultaneously = ((UIGestureRecognizer, UIGestureRecognizer) -> Bool)
    public typealias ShouldBegin = ((UIGestureRecognizer) -> Bool?)

    open var shouldRecognizeSimultaneously: RecognizeSimultaneously?
    open var shouldBegin: ShouldBegin?

    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = UIColor.white
        //适配iOS 11
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        } else {
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
    open func setShouldRecognizeSimultaneously(_ callBack: RecognizeSimultaneously?) {
        self.shouldRecognizeSimultaneously = callBack
    }
    
    /// 是否允许开始手势
    open func setShouldBegin(_ callBack: ShouldBegin?) {
        self.shouldBegin = callBack
    }
}

public extension UICollectionView {

    func registSwiftCell<T: UICollectionViewCell>(cellType: T.Type) where T: SwiftCellCompatible {
      
        self.register(cellType.self, forCellWithReuseIdentifier: cellType.reusableIdentifier)
    }
    
    func registerSwifView<T: UICollectionReusableView>(supplementaryViewType: T.Type, ofKind elementKind: String) where T: SwiftCellCompatible {
        
        register(supplementaryViewType.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: supplementaryViewType.reusableIdentifier)
    }
    
    func dequeueSwiftReusableCell<T: UICollectionViewCell>(indexPath: IndexPath, as cellType: T.Type = T.self) -> T where T: SwiftCellCompatible {
      
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reusableIdentifier, for: indexPath) as? T else {
            preconditionFailure("Failed to dequeue a cell with identifier \(cellType.reusableIdentifier) matching type \(cellType.self). " + "Check that you registered the cell beforehand")
        }
        
        return cell
    }
    
    func dequeueSwiftReusableSupplementaryView<T: UICollectionReusableView>(ofKind elementkind: String, indexPath: IndexPath, as viewType: T.Type = T.self) -> T where T: SwiftCellCompatible {
        
        guard let view = dequeueReusableSupplementaryView(ofKind: elementkind, withReuseIdentifier: viewType.reusableIdentifier, for: indexPath) as? T else {
            preconditionFailure("Failed to dequeue a supplementary view with identifier \(viewType.reusableIdentifier) matching type \(viewType.self). " + "Check that you registered the supplementary view beforehand")
        }
        return view
    }
    
    
}

//MARK: - UIGestureRecognizerDelegate
extension SwiftCollectionView: UIGestureRecognizerDelegate {
    
    /// 您是否支持多事件传递代理
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        shouldRecognizeSimultaneously?(gestureRecognizer, otherGestureRecognizer) ?? false
    }
    
    /// 是否允许开始手势
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        shouldBegin?(gestureRecognizer) ?? super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
}

@objcMembers open class SwiftCollectionViewCell: UICollectionViewCell {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupViewModel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SwiftCollectionViewCell: SwiftCellCompatible { }
 
