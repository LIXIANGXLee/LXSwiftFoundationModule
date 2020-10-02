//
//  LXSwiftImgView.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

open class LXSwiftImgView: UIImageView, LXSwiftUICompatible {
       /// call back
    public typealias ImgViewCallBack = ((_ imgView: LXSwiftImgView?) -> ())
    public var swiftModel: Any?
    public var imgViewCallBack: LXSwiftImgView.ImgViewCallBack?

    /// 是否允许交互
    public var isInteractionEnabled: Bool = false {
        didSet { isUserInteractionEnabled = isInteractionEnabled }
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

/// private
extension LXSwiftImgView {
    
    /// set handle for method call back
    public func setHandle(_ imgViewCallBack: LXSwiftImgView.ImgViewCallBack?) {
        self.imgViewCallBack = imgViewCallBack
    }
    
    ///action call
    @objc private func swiftImgViewAction(_ gesture: UIGestureRecognizer) {
        self.imgViewCallBack?(gesture.view as? LXSwiftImgView)
    }
    
}
