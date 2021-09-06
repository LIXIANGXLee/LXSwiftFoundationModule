//
//  LXSwift+imgView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2021/9/4.
//

import UIKit


//MARK: -  Extending properties and methods for UISwitch
extension LXSwiftBasics where Base: LXSwiftImgView {
    
    /// 设置方法回调的句柄
    public func setHandle(_ callBack: LXSwiftImgView.CallBack?) {
        base.callBack = callBack
    }
}
