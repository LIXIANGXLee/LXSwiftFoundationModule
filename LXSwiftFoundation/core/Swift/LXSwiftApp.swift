//
//  LXSwftApp.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/4/22.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// 屏幕宽度
public let SCREEN_WIDTH_TO_WIDTH = LXSwiftApp.screenW

/// 屏幕高度
public let SCREEN_HEIGHT_TO_HEIGHT = LXSwiftApp.screenH

/// 底部刘海
public let SCREEN_HEIGHT_TO_TOUCHBARHEIGHT = LXSwiftApp.touchBarH

/// 顶部刘海
public let SCREEN_HEIGHT_TO_STATUSHEIGHT = LXSwiftApp.statusBarH

/// tabbar高度
public let SCREEN_HEIGHT_TO_TABBARHEIGHT = LXSwiftApp.tabBarH

/// 导航栏高度
public let SCREEN_HEIGHT_TO_NAVBARHEIGHT = LXSwiftApp.navBarH

/// 标准iphone6适配宽度
public func SCALE_IP6_WIDTH_TO_WIDTH(_ distance: CGFloat) -> CGFloat {
    return LXSwiftApp.flat(distance * (SCREEN_WIDTH_TO_WIDTH / 375))
}

/// 标准iphone6适配高度
public func SCALE_IP6_HEIGHT_TO_HEIGHT(_ distance: CGFloat) -> CGFloat {
    return LXSwiftApp.flat(distance * (SCREEN_HEIGHT_TO_HEIGHT / 667))
}

/// 标准ipad129适配宽度
public func SCALE_IPAD129_WIDTH_TO_WIDTH(_ distance: CGFloat) -> CGFloat {
    return LXSwiftApp.flat(distance * (SCREEN_WIDTH_TO_WIDTH / 1024))
}

/// 标准ipad129适配高度
public func SCALE_IPAD129_HEIGHT_TO_HEIGHT(_ distance: CGFloat) -> CGFloat {
    return LXSwiftApp.flat(distance * (SCREEN_HEIGHT_TO_HEIGHT / 1366))
}

/// 居中运算
public func SCALE_GET_CENTER_WIDTH_AND_WIDTH(_ parent: CGFloat, _ child: CGFloat) -> CGFloat {
    return LXSwiftApp.flat((parent - child) / 2.0)
}

// MARK: - LXSwftApp const
/// define app const
@objc(LXObjcApp)
@objcMembers public final class LXSwiftApp: NSObject {
        
    ///判断是否为iphone5（排除iphone4以外）Judge whether the mobile phone is iPhone 5
    public static var isIphone5 = LXSwiftApp.screenW == 320.0

    /// 屏幕尺寸 gets bounds
    public static let bounds = UIScreen.main.bounds
    
    /// 屏幕宽度 Gets the width of the screen
    @objc(screenWidth)
    public static let screenW = CGFloat(bounds.width)
    
    /// 屏幕高度 Gets the height of the screen
    @objc(screenHeight)
    public static let screenH = CGFloat(bounds.height)

    /// 状态栏高度
    @objc(statusBarHeight)
    public static let statusBarH: CGFloat = statusBarHeight
    
    /// 屏幕底部刘海高度
    @objc(touchBarHeight)
    public static let touchBarH: CGFloat = touchBarHeight
        
    /// Gets the height of the Navigation bar
    @objc(navBarHeight)
    public static let navBarH: CGFloat = statusBarH + 44
    
    @objc(tabBarHeight)
    public static let tabBarH: CGFloat = touchBarH + 49
    
    /// 系统版本号(swift调用version，oc代码调用version_objc)
    @objc(version_objc)
    public static let version = UIDevice.current.systemVersion
    
    /// 屏幕比例
    public static let screenScale = UIScreen.main.scale

    /// 适配比例
    public static let scaleIphone = LXSwiftApp.screenW / CGFloat(375.0)
    
    /**
     *  当前设备的屏幕倍数，对传进来的 value 进行像素根据屏幕比例取整
     *  例如传进来 “2.1”，在 2x 倍数下会返回 2.5（0.5pt 对应 1px）在 3x 倍数下会返回 2.333（0.333pt 对应 1px）。
     */
    public static func flat(_ value: CGFloat) -> CGFloat {
        return ceil(value * LXSwiftApp.screenScale) / LXSwiftApp.screenScale
    }

    /// 获取跟窗口
    public static var rootWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            if let window = UIApplication.shared.connectedScenes
                   .filter({$0.activationState == .foregroundActive})
                   .map({$0 as? UIWindowScene})
                   .compactMap({$0})
                   .first?.windows
                   .filter({$0.isKeyWindow}).first {
                   return window
            }else {
                return UIApplication.shared.delegate?.window ?? UIApplication.shared.windows.first
            }
        } else {
               return UIApplication.shared.delegate?.window ?? UIApplication.shared.windows.first
        }
    }
    
    /// 获取状态栏高度
    private static var statusBarHeight: CGFloat {
        var statusH: CGFloat = UIApplication.shared.statusBarFrame.height
        if statusH == 0 {
            if #available(iOS 13.0, *) {
                statusH = rootWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

            }else if #available(iOS 11.0, *) {
                statusH = rootWindow?.safeAreaInsets.top ?? 0
            }else {
                return 20
            }
        }
        return statusH
    }
    
    /// 底部圆弧高度
    private static var touchBarHeight: CGFloat {
        var touchBarH: CGFloat = 0
        if #available(iOS 11.0, *) {
            touchBarH =
               rootWindow?.safeAreaInsets.bottom ?? 0
            if touchBarH == 0 && Int(statusBarH) > 20 {
                touchBarH = 34
            }
        }
        return touchBarH
    }
}
