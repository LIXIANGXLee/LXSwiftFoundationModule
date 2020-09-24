//
//  LXSwftApp.swift
//  LXFoundationManager
//
//  Created by Mac on 2020/4/22.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

// MARK: - LXSwftApp 常用的全局变量

/// 定义一下app经常用到的全局常量
public struct LXSwiftApp {

   //根据高度来判断是否是带刘海的手机,也可以通过safaAreaInserts来判断
    public static let isIPhoneX = (LXSwiftApp.screenH == CGFloat(812) || LXSwiftApp.screenH == CGFloat(896)) ? true : false
    public static var isIphone5 = LXSwiftApp.screenW == 320
    public static var isIphone6 = LXSwiftApp.screenW == 375
    public static var isIphone6p = LXSwiftApp.screenW == 414
    //bounds
    public static let bounds = UIScreen.main.bounds
    //app屏幕宽度
    public static let screenW = CGFloat(UIScreen.main.bounds.width)
    //app屏幕高度
    public static let screenH = CGFloat(UIScreen.main.bounds.height)
    //app导航高度
    public static let navbarH = isIPhoneX ? CGFloat(88.0) : CGFloat(64.0)
    //tabbar高度
    public static let tabbarH = isIPhoneX ? CGFloat(49.0+34.0) : CGFloat(49.0)
    //状态栏高度
    public static let statusbarH = isIPhoneX ? CGFloat(44.0) : CGFloat(20.0)
    //tabBar 的刘海高度
    public static let touchBarH = isIPhoneX ? CGFloat(34.0) : CGFloat(0.0)
     // 系统版本号
    public static let version = UIDevice.current.systemVersion
    //屏幕相比iPhone6的宽度比例
    public static let scale = LXSwiftApp.screenW / CGFloat(375.0)
    
   
}
