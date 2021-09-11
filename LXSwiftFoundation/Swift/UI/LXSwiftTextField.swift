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
   
    public typealias TextCallBack = (String) -> Void
    /// 配置文本框的输入位置和左右间距
    open var textRectInsert: UIEdgeInsets?
    
    /// 回调属性
    open var textCallBack: LXSwiftTextView.TextCallBack?
   
    /// 配置文本可输入最长文本长度
    open var maxTextLength: Int?

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
        }else{ return newBounds }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        NotificationCenter.default.addObserver(self, selector:#selector(textDidChange), name: UITextField.textDidChangeNotification, object: self)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit { NotificationCenter.lx_removeObserver(self) }
}

// MARK: - public method
extension LXSwiftTextField {
    
    /// 公共方法回调
    open func setHandle(_ textCallBack: LXSwiftTextView.TextCallBack?) { self.textCallBack = textCallBack }
    
    /// 设置文本最大长度
    @objc open func setMaxTextLength(_ length: Int) { self.maxTextLength = length }
    
    /// 配置文本框的输入位置和左右间距
    @objc open func textRectInsert(_ edgeInsets: UIEdgeInsets) { self.textRectInsert = edgeInsets }

}

//MARK: -  private methods 
extension LXSwiftTextField {
    
    /// 文本改变调用
    @objc func textDidChange() {
        if let maxLength = self.maxTextLength, let count = text?.count {
            if count > maxLength { text = text?.lx.substring(to: maxLength) }
        }
        self.textCallBack?(text ?? "")
    }
}
