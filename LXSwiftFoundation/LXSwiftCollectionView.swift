//
//  LXCollectionView.swift
//  LXFoundationManager
//
//  Created by Mac on 2020/4/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

open class LXSwiftCollectionView: UICollectionView, LXSwiftUICompatible {
   
    public var swiftModel: Any?
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
}

extension LXSwiftCollectionView: LXViewSetup {
   open func setupUI() { }
   open func setupViewModel() {}

}

open class LXSwiftCollectionViewCell: UICollectionViewCell, LXSwiftUICompatible {
    public var swiftModel: Any?
    
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
