//
//  LXSwiftTextField.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/9/28.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

@objc(LXObjcTextField)
@objcMembers open class LXSwiftTextField: UITextField {
  
    /// 配置文本框的输入位置和左右间距
    open var textRectInsert: UIEdgeInsets?
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        if let textRectInsert = textRectInsert {
            return bounds.inset(by: textRectInsert)
        }else{
            return super.textRect(forBounds: bounds)
        }
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let newBounds = super.textRect(forBounds: bounds)
        if let textRectInsert = textRectInsert {
            return newBounds.inset(by: textRectInsert)
        }else{
            return newBounds
        }
    }
    
    deinit { NotificationCenter.default.removeObserver(self) }
}
