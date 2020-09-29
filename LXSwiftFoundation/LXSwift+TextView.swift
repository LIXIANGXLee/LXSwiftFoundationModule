//
//  LXSwift+TextView.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/29.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit


//MARK: -  Extending properties and methods for LXSwiftTextView
extension LXSwiftBasics where Base : LXSwiftTextView {

    /// public method call back
    public func setHandle(_ textCallBack: LXSwiftTextView.TextCallBack?) {
        base.textCallBack = textCallBack
    }
    
    /// set placeholder and color
    public func set(with placeholder: String?,color: UIColor = UIColor.lx.color(hex: "999999")!) {
        
        base.placehoderLabel.text = placeholder
        base.placehoderLabel.textColor = color
        base.setNeedsLayout()
    }
    
     /// set placeholder and color
     public func updateUI() {
         base.textDidChange()
     }
    
     /// remove observer
     public func removeObserver() {
        NotificationCenter.default.removeObserver(base)
     }
    
    /// 配置文本可输入最长文本长度
    public var maxLength: Int? {
        get{ return base.maxTextLength }
        set{
           guard let newValue = newValue, newValue > 0 else { return }
           base.maxTextLength = newValue
         }
     }
}
