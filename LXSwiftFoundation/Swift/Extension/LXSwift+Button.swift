//
//  LXSwift+Button.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2021/9/4.
//

import UIKit

//MARK: -  Extending properties for LXSwiftButtonView
extension LXSwiftBasics where Base: LXSwiftButton {
 
    /// 设置标题的cgrect和图像的cgrect
    public func setHandle(titleCallBack: LXSwiftButton.ButtonCallBack?,
                          imageCallBack: LXSwiftButton.ButtonCallBack?) {
        base.titleCallBack = titleCallBack
        base.imageCallBack = imageCallBack
    }
}
