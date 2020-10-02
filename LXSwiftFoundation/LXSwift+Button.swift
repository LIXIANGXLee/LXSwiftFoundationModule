//
//  LXSwift+Button.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit


//MARK: -  Extending properties for UIButton
extension LXSwiftBasics where Base: UIButton {
    
    /// w for button
    public var bestWidth: CGFloat {
        return base.sizeThatFits(CGSize.zero).width
    }
    
    /// h  for button
    public var bestHeight: CGFloat {
       return base.sizeThatFits(CGSize.zero).height
    }

    ///Provides a convenient way to set the properties of uibutton
    ///
    /// - Parameters:
    ///- Font: set title font
    ///- titlecolor: set title color
    ///- Title: set title
    public func set(font: UIFont, titleColor: UIColor?) {
        base.titleLabel?.font = font
        guard let titleColor = titleColor else  { return }
        base.setTitleColor(titleColor, for: .normal)
    }
    
    ///Provides a convenient way to set the properties of uibutton
    ///
    /// - Parameters:
    ///- Title: set title
    ///- image: set image
    ///- state: set UIControl.State
    public func set(title: String?, image: UIImage?, state: UIControl.State = .normal) {
        if let title = title { base.setTitle(title, for: state) }
        if let image = image { base.setImage(image, for: state) }
    }
}

//MARK: -  Extending properties for UIButton
extension LXSwiftBasics where Base: LXSwiftButton {
   
    /// set handle for method call back
    public func setHandle(_ buttonCallBack: LXSwiftButton.ButtonCallBack?) {
        base.buttonCallBack = buttonCallBack
    }
}


