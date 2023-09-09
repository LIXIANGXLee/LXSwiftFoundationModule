//
//  SwftApp.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/4/22.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// 屏幕宽度
public let SCREEN_WIDTH_TO_WIDTH = SwiftApp.screenW

/// 屏幕高度
public let SCREEN_HEIGHT_TO_HEIGHT = SwiftApp.screenH

/// 底部刘海
public let SCREEN_HEIGHT_TO_TOUCHBARHEIGHT = SwiftApp.touchBarH

/// 顶部刘海
public let SCREEN_HEIGHT_TO_STATUSHEIGHT = SwiftApp.statusBarH

/// tabbar高度
public let SCREEN_HEIGHT_TO_TABBARHEIGHT = SwiftApp.tabBarH

/// 导航栏高度
public let SCREEN_HEIGHT_TO_NAVBARHEIGHT = SwiftApp.navBarH

/// 标准iphone6适配宽度
public func SCALE_IP6_WIDTH_TO_WIDTH(_ distance: CGFloat) -> CGFloat {
    distance * (SCREEN_WIDTH_TO_WIDTH / 375)
}

/// 标准iphone6适配高度
public func SCALE_IP6_HEIGHT_TO_HEIGHT(_ distance: CGFloat) -> CGFloat {
    distance * (SCREEN_HEIGHT_TO_HEIGHT / 667)
}

/// 标准ipad129适配宽度
public func SCALE_IPAD129_WIDTH_TO_WIDTH(_ distance: CGFloat) -> CGFloat {
    distance * (SCREEN_WIDTH_TO_WIDTH / 1024)
}

/// 标准ipad129适配高度
public func SCALE_IPAD129_HEIGHT_TO_HEIGHT(_ distance: CGFloat) -> CGFloat {
    distance * (SCREEN_HEIGHT_TO_HEIGHT / 1366)
}

/// 居中运算
public func SCALE_GET_CENTER_WIDTH_AND_WIDTH(_ parent: CGFloat, _ child: CGFloat) -> CGFloat {
    (parent - child) / 2.0
}

/// DEBU模式下日志打印简单封装，打印日志快捷函数 
public func LXXXLog(_ msg: Any, _ file: String = #file, _ fn: String = #function, _ line: Int = #line) {
    SwiftApp.log(msg, file, fn, line)
}

private let applicationShared = UIApplication.shared
// MARK: - LXSwftApp const
/// define app const
@objc(LXObjcApp)
@objcMembers public final class SwiftApp: NSObject {

    ///判断是否为iphone5（排除iphone4以外）Judge whether the mobile phone is iPhone 5
    public static var isIphone5 = SwiftApp.screenW == 320.0

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
    public static let scaleIphone = SwiftApp.screenW / CGFloat(375.0)
    
    
    @available(iOS 13.0, *)
    public static var windowScenes: [UIWindowScene] {
        applicationShared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene}).compactMap({$0})
    }
    
    /// 获取跟窗口
    public static var rootWindow: UIWindow? {
        var window: UIWindow? = applicationShared.windows.first
        if #available(iOS 13.0, *) {
            for s in windowScenes {
                for w in s.windows where w.isMember(of: UIWindow.self) {
                    window = w
                    break
                }
            }
        }
        return window
    }
    
    /**
       定制化获取最外层窗口 需要判断不是UIRemoteKeyboardWindow才行，否则在ipad会存在问题，同时也排除了自定义的UIWindow的子类问题
     */
    public static var scheduledLastWindow: UIWindow? {
        var window: UIWindow?
        if #available(iOS 13.0, *) {
            for s in windowScenes {
                for w in s.windows.reversed() where w.isMember(of: UIWindow.self) {
                    if !w.isHidden {
                        window = w
                        break
                    }
                }
            }
        } else {
            for w in applicationShared.windows.reversed() where w.isMember(of: UIWindow.self) {
                if !w.isHidden {
                    window = w
                    break
                }
            }
        }
        return window
    }
    
    /// 获取最外层窗口 需要判断不是UIRemoteKeyboardWindow才行，否则在ipad会存在问题
    public static var lastWindow: UIWindow? {
        var window: UIWindow?
        if #available(iOS 13.0, *) {
            for s in windowScenes {
                for w in s.windows.reversed() {
                    if let c = NSClassFromString("UIRemoteKeyboardWindow"), !w.isMember(of: c.self), !w.isHidden  {
                        window = w
                        break
                    }
                }
            }
        } else {
            for w in applicationShared.windows.reversed() {
                if let c = NSClassFromString("UIRemoteKeyboardWindow"), !w.isMember(of: c.self), !w.isHidden  {
                    window = w
                    break
                }
            }
        }
        return window
    }
    
    /// 获取状态栏高度
    private static var statusBarHeight: CGFloat {
        var statusH = applicationShared.statusBarFrame.height
        if #available(iOS 13.0, *) {
            statusH = rootWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        }
        if statusH == 0 {
            if #available(iOS 11.0, *) {
                statusH = rootWindow?.safeAreaInsets.top ?? 20
            } else {
                statusH = 20
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
        }
        return touchBarH
    }
    
    /// 打印日志
    fileprivate static func log(_ msg: Any, _ file: String, _ fn: String, _ line: Int) {
        #if DEBUG
        print("「 DEBUG模式下打印日志： 」****** \((file as NSString).lastPathComponent) >> \(line) >> \(fn) >> \(msg) ******")
        #endif
    }
}
