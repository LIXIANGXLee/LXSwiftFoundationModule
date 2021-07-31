//
//  LXSwiftImgView.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

open class LXSwiftImgView: UIImageView {
    /// call back
    public typealias ImgViewCallBack = ((_ imgView: LXSwiftImgView?) -> ())

    var imgViewCallBack: LXSwiftImgView.ImgViewCallBack?
    
    /// 是否允许交互
    public var isInteractionEnabled: Bool = false {
        didSet { isUserInteractionEnabled = isInteractionEnabled }
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(swiftImgViewAction(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// private
extension LXSwiftImgView {
    
    /// action call
    @objc private func swiftImgViewAction(_ gesture: UIGestureRecognizer) {
        gesture.view?.isUserInteractionEnabled = false
        DispatchQueue.lx.delay(with: 1) {
            gesture.view?.isUserInteractionEnabled = true
        }
        self.imgViewCallBack?(gesture.view as? LXSwiftImgView)
    }
}

//MARK: -  Extending properties and methods for UISwitch
extension LXSwiftBasics where Base: LXSwiftImgView {
    
    /// 设置方法回调的句柄
    public func setHandle(_ imgViewCallBack: LXSwiftImgView.ImgViewCallBack?) {
        base.imgViewCallBack = imgViewCallBack
    }
}
