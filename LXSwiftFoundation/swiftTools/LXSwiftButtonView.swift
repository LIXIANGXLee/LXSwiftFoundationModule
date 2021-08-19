//
//  LXSwiftButtonView.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/10/2.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// 添加按钮水平布局和按钮垂直布局
open class LXSwiftButtonView: LXSwiftButton {
    
    public typealias ButtonCallBack = ((_ contentRect: CGRect) -> (CGRect))
    public var titleCallBack: ButtonCallBack?
    public var imageCallBack: ButtonCallBack?
    
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
extension LXSwiftBasics where Base: LXSwiftButtonView {
 
    /// 设置标题的cgrect和图像的cgrect
    public func setHandle(titleCallBack: LXSwiftButtonView.ButtonCallBack?,
                          imageCallBack: LXSwiftButtonView.ButtonCallBack?) {
        base.titleCallBack = titleCallBack
        base.imageCallBack = imageCallBack
    }
}
