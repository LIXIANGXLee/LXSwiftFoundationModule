//
//  LXSwiftImgView.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

@objcMembers open class LXSwiftImgView<T>: UIImageView {
   
    /// 方便携带的参数 有的时候可能想自定义一些参数，做为传参作用
    open var swiftModel: T?

    /// 回调函数别名
    public typealias CallBack = ((_ imgView: LXSwiftImgView?) -> ())

    /// 事件点击回调
    open var callBack: LXSwiftImgView.CallBack?
    
    /// 是否允许交互
    open var isInteractionEnabled: Bool = false { didSet { isUserInteractionEnabled = isInteractionEnabled } }
       
    public convenience init() { self.init(frame: CGRect.zero) }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(swiftImgViewAction(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// action call
    @objc private func swiftImgViewAction(_ gesture: UIGestureRecognizer) {
        gesture.view?.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            gesture.view?.isUserInteractionEnabled = true
        }
        self.callBack?(gesture.view as? LXSwiftImgView)
    }
}
