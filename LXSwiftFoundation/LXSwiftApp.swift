//
//  LXSwftApp.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/4/22.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

// MARK: - LXSwftApp const
/// define app const
public struct LXSwiftApp {
    
    ///Judge whether the mobile phone is iPhone X 11 12 pro
    public static let isIPhoneX = (LXSwiftApp.screenH == CGFloat(812) || (LXSwiftApp.screenH == CGFloat(844)) || LXSwiftApp.screenH == CGFloat(896) || (LXSwiftApp.screenH == CGFloat(926))) ? true : false
    
    ///Judge whether the mobile phone is iPhone 5
    public static var isIphone5 = LXSwiftApp.screenW == 320.0
    
    ///Judge whether the mobile phone is iPhone 6
    public static var isIphone6 = LXSwiftApp.screenW == 375.0
    
    ///Judge whether the mobile phone is iPhone 6p
    public static var isIphone6p = LXSwiftApp.screenW == 414.0

    ///gets bounds
    public static let bounds = UIScreen.main.bounds
    
    ///Gets the width of the screen
    public static let screenW = CGFloat(UIScreen.main.bounds.width)
    
    ///Gets the height of the screen
    public static let screenH = CGFloat(UIScreen.main.bounds.height)
    
    
    ///Gets the height of the Navigation bar
    public static let navbarH = isIPhoneX ? CGFloat(88.0) : CGFloat(64.0)
    public static let tabbarH = isIPhoneX ? CGFloat(49.0+34.0) : CGFloat(49.0)
    
    ///status H
    public static let statusbarH = isIPhoneX ? CGFloat(44.0) : CGFloat(20.0)
    //tabBar h circle
    public static let touchBarH = isIPhoneX ? CGFloat(34.0) : CGFloat(0.0)
    
    
    /// system version
    public static let version = UIDevice.current.systemVersion
    ///app scale of  the screen
    public static let scale = LXSwiftApp.screenW / CGFloat(375.0)
    
    
}
