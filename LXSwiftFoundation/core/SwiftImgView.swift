//
//  SwiftImgView.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

open class SwiftImgView: UIImageView {
   
    /// 方便携带的参数 有的时候可能想自定义一些参数，做为传参作用
    public var swiftModel: Any?

    /// 回调函数别名
    public typealias TapClosure = ((SwiftImgView?) -> ())

    /// 事件点击回调
    open var tapClosure: SwiftImgView.TapClosure?
    
    /// 是否允许交互
    open var isInteractionEnabled: Bool = false {
        didSet {
            isUserInteractionEnabled = isInteractionEnabled
        }
    }
       
    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        lx.addTapGestureRecognizer { view in
            view?.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                view?.isUserInteractionEnabled = true
            }
            self.tapClosure?(view as? SwiftImgView)
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
