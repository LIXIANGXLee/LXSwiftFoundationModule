//
//  LXSwiftImgView.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

@objc(LXObjcImgView)
@objcMembers open class LXSwiftImgView: UIImageView {
   
    /// 回调函数别名
    public typealias ImgViewCallBack = ((_ imgView: LXSwiftImgView?) -> ())

    open var imgViewCallBack: LXSwiftImgView.ImgViewCallBack?
    
    /// 是否允许交互
    open var isInteractionEnabled: Bool = false {
        didSet { isUserInteractionEnabled = isInteractionEnabled }
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(swiftImgViewAction(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 私有函数扩展
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
