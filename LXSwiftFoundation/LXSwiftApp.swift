//
//  LXSwftApp.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/4/22.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// 标准iphone6适配宽度
public func scale_ip6_width(_ distance: CGFloat) -> CGFloat {
    return LXSwiftApp.flat(distance * (LXSwiftApp.screenW / 375))
}

/// 标准iphone6适配高度
public func scale_ip6_height(_ distance: CGFloat) -> CGFloat {
    return LXSwiftApp.flat(distance * (LXSwiftApp.screenH / 667))
}

public func scale_ipad129_width(_ distance: CGFloat) -> CGFloat {
    return LXSwiftApp.flat(distance * (LXSwiftApp.screenW / 1024))
}

public func scale_ipad129_height(_ distance: CGFloat) -> CGFloat {
    return LXSwiftApp.flat(distance * (LXSwiftApp.screenH / 1366))
}

/// 居中运算
public func CGFloatGetCenter(_ parent: CGFloat,
                             _ child: CGFloat) -> CGFloat {
    return LXSwiftApp.flat((parent - child) / 2.0)
}

/// 屏幕宽高
public var SCREEN_WIDTH_APP = LXSwiftApp.screenW
public var SCREEN_HEIGHT_APP = LXSwiftApp.screenH

// MARK: - LXSwftApp const
/// define app const
public struct LXSwiftApp {
        
    ///判断是否为iphone5（排除iphone4以外）Judge whether the mobile phone is iPhone 5
    public static var isIphone5 = LXSwiftApp.screenW == 320.0

    /// 屏幕尺寸 gets bounds
    public static let bounds = UIScreen.main.bounds
    
    /// 屏幕宽度 Gets the width of the screen
    public static let screenW = CGFloat(UIScreen.main.bounds.width)
    
    /// 屏幕高度 Gets the height of the screen
    public static let screenH = CGFloat(UIScreen.main.bounds.height)

    /// 状态栏高度
    public static let statusbarH: CGFloat = statusBarHeight
    /// 屏幕底部刘海高度
    public static let touchBarH: CGFloat = touchBarHeight
        
    ///Gets the height of the Navigation bar
    public static let navbarH: CGFloat = statusbarH + 44
    public static let tabbarH: CGFloat = touchBarH + 49
    
    /// 系统版本号
    public static let version = UIDevice.current.systemVersion
    
    /// 屏幕比例
    public static let screen_scale = UIScreen.main.scale

    /// 适配比例
    public static let scale = LXSwiftApp.screenW / CGFloat(375.0)
    
    /// 获取状态栏高度
    private static var statusBarHeight: CGFloat {
        var statusH: CGFloat = UIApplication.shared.statusBarFrame.height
        if statusH == 0, #available(iOS 13.0, *) {
            statusH = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        }
        
        if  statusH == 0, #available(iOS 11.0, *)  {
            statusH = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        }
        
        return statusH
    }
    
    private static var touchBarHeight: CGFloat {
        var touchBarH: CGFloat = 0
        if #available(iOS 11.0, *) {
            touchBarH = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
            if touchBarH == 0 && Int(statusbarH) >= 44 {
                touchBarH = 34
            }
        }
        return touchBarH
    }
    
    /**
     *  基于当前设备的屏幕倍数，对传进来的 floatValue 进行像素取整。
     *  注意如果在 Core Graphic 绘图里使用时，要注意当前画布的倍数是否和设备屏幕倍数一致，
     *  若不一致，不可使用 flat() 函数，而应该用
     *  基于指定的倍数，对传进来的 floatValue进行像素取整。若指定倍数为0，则表示以当前设备的屏幕倍数为准。
     *  例如传进来 “2.1”，在 2x 倍数下会返回 2.5（0.5pt 对应 1px），
     *  在 3x 倍数下会返回 2.333（0.333pt 对应 1px）。
     */
    public static func flat(_ value: CGFloat) -> CGFloat {
        return ceil(value * LXSwiftApp.screen_scale) / LXSwiftApp.screen_scale
    }

}

