//
//  LXSwiftButton.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// 添加按钮水平布局和按钮垂直布局
@objc(LXObjcButton)
@objcMembers open class LXSwiftButton: UIButton {
    
    /// 方便携带的参数 有的时候可能想自定义一些参数，做为传参作用
    open var swiftModel: Any?
    
    /// 回调函数别名
    public typealias ButtonCallBack = ((_ contentRect: CGRect) -> (CGRect))
    open var titleCallBack: ButtonCallBack?
    open var imageCallBack: ButtonCallBack?
    
    open override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return self.imageCallBack?(contentRect) ?? contentRect
    }
    
    open override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return self.titleCallBack?(contentRect) ?? contentRect
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        imageView?.contentMode = .scaleAspectFit
        titleLabel?.textAlignment = .center
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center
        adjustsImageWhenHighlighted = false
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: -  Extending properties for LXSwiftButtonView
extension LXSwiftBasics where Base: LXSwiftButton {
 
    /// 设置标题的cgrect和图像的cgrect
    public func setHandle(titleCallBack: LXSwiftButton.ButtonCallBack?,
                          imageCallBack: LXSwiftButton.ButtonCallBack?) {
        base.titleCallBack = titleCallBack
        base.imageCallBack = imageCallBack
    }
}
