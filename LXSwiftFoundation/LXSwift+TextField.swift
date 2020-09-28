//
//  LXSwift+TextField.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/9/28.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit


//MARK: -  Extending properties for LXSwiftTextField
extension LXSwiftBasics where Base : LXSwiftTextField {
    
    /// 配置文本可输入最长文本长度
    public var maxLength: Int? {
        get{ return base.maxTextLength }
        set{
           guard let newValue = newValue, newValue > 0 else { return }
           base.maxTextLength = newValue
           NotificationCenter.default.addObserver(base,  selector:#selector(base.textFieldTextChange(notification:)),name: UITextField.textDidChangeNotification,object: base)
         }
     }
    
}

//MARK: -  Extending methods for LXSwiftTextField
extension LXSwiftBasics where Base : LXSwiftTextField {
    
    ///  set textField leftView
    public func setLeftView(_ view: UIView, mode: UITextField.ViewMode = .always) {
       base.leftView = view
       base.leftViewMode = mode
    }
   
    /// set textField rightView
    public func setRightView(_ view: UIView, mode: UITextField.ViewMode = .always) {
       base.rightView = view
       base.rightViewMode = mode
    }
    
    /// set placeholder and color
    public func set(with placeholder: String?,color: UIColor = UIColor.lx.color(hex: "999999")!) {
        guard let placeholder = placeholder else {  return  }
        let att = NSMutableAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
        base.attributedPlaceholder = att
    }
    
    /// remove observer
    public func removeObserver() {
        NotificationCenter.default.removeObserver(base)
    }
}


//MARK: -  Extending methods for LXSwiftTextField
private var maxTextLengthKey: Void?
extension LXSwiftTextField {
    
    /// can save maxTextLength
    internal var maxTextLength: Int {
       set {
          objc_setAssociatedObject(self, &maxTextLengthKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
        get {
          return objc_getAssociatedObject(self, &maxTextLengthKey) as! Int
        }
     }
     
     /// action
     @objc internal func textFieldTextChange(notification: Notification) {
        if let maxLength = self.lx.maxLength {
              if (text?.count ?? 0) > maxLength {
                text = text?.lx.substring(to: maxLength)
              }
          }
      }

}
