//
//  LXSwift+Device.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

extension UIDevice: LXSwiftCompatible { }

//MARK: -  Extending methods  for UIDevice is ipad or iphone
extension LXSwiftBasics where Base: UIDevice {
    
    /// is ipad
    public static var isPad: Bool {
        if #available(iOS 13.0, *) {
            return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
        }else{
            return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
        }
    }
    
    /// is iphone
    public static var isPhone: Bool {
        if #available(iOS 13.0, *) {
            return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
        }else{
             return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone
        }
    }
}


