//
//  SwiftWindow.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/4/22.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// 屏幕宽度
public let SCREEN_WIDTH_TO_WIDTH = SwiftWindow.screenWidth

/// 屏幕高度
public let SCREEN_HEIGHT_TO_HEIGHT = SwiftWindow.screenHeight

/// 底部刘海
public let SCREEN_HEIGHT_TO_TOUCHBARHEIGHT = SwiftWindow.touchBarHeight

/// 顶部刘海
public let SCREEN_HEIGHT_TO_STATUSHEIGHT = SwiftWindow.statusBarHeight

/// tabbar高度
public let SCREEN_HEIGHT_TO_TABBARHEIGHT = SwiftWindow.tabBarHeight

/// 导航栏高度
public let SCREEN_HEIGHT_TO_NAVBARHEIGHT = SwiftWindow.navBarHeight

/// 标准iphone6适配宽度
public func SCALE_IP6_WIDTH_TO_WIDTH(_ distance: CGFloat) -> CGFloat {
    distance * (SCREEN_WIDTH_TO_WIDTH / 375.0)
}

/// 标准iphone6适配高度
public func SCALE_IP6_HEIGHT_TO_HEIGHT(_ distance: CGFloat) -> CGFloat {
    distance * (SCREEN_HEIGHT_TO_HEIGHT / 667.0)
}

/// 标准ipad129适配宽度
public func SCALE_IPAD129_WIDTH_TO_WIDTH(_ distance: CGFloat) -> CGFloat {
    distance * (SCREEN_WIDTH_TO_WIDTH / 1024.0)
}

/// 标准ipad129适配高度
public func SCALE_IPAD129_HEIGHT_TO_HEIGHT(_ distance: CGFloat) -> CGFloat {
    distance * (SCREEN_HEIGHT_TO_HEIGHT / 1366.0)
}

/// 居中运算
public func SCALE_GET_CENTER_WIDTH_AND_WIDTH(_ parent: CGFloat, _ child: CGFloat) -> CGFloat {
    (parent - child) / 2.0
}

/// DEBU模式下日志打印简单封装，打印日志快捷函数 
public func LXXXLog(_ msg: Any, _ file: String = #file, _ fn: String = #function, _ line: Int = #line) {
    SwiftWindow.log(msg, file, fn, line)
}

// MARK: - LXSwftApp const
/// define app const
@objc(LXObjcWindow)
@objcMembers public final class SwiftWindow: NSObject {

    ///判断是否为iphone5（排除iphone4以外）Judge whether the mobile phone is iPhone 5
    public static var isIphone5 = screenWidth == 320.0

    /// 屏幕尺寸 gets bounds
    public static let bounds = UIScreen.main.bounds
    
    /// 屏幕宽度 Gets the width of the screen
    public static let screenWidth = CGFloat(bounds.width)
    
    /// 屏幕高度 Gets the height of the screen
    public static let screenHeight = CGFloat(bounds.height)

    /// 状态栏高度
    public static let statusBarHeight: CGFloat = getStatusBarHeight
    
    /// 屏幕底部刘海高度
    public static let touchBarHeight: CGFloat = getTouchBarHeight
        
    /// 导航栏高度
    public static let navBarHeight: CGFloat = statusBarHeight + 44
    
    /// 底部刘海高度
    public static let tabBarHeight: CGFloat = touchBarHeight + 49
    
    /// 系统版本号(swift调用version，oc代码调用version_objc)
    @objc(version_objc)
    public static let version = UIDevice.current.systemVersion
    
    /// 屏幕比例
    public static let screenScale = UIScreen.main.scale

    /// 适配比例 宽是375为基数
    public static let scaleIphone = SwiftWindow.screenWidth / CGFloat(375.0)
    
    @available(iOS 13.0, *)
    public static var windowScenes: [UIWindowScene] {
        UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene}).compactMap({$0})
    }
    
    /// 获取跟root窗口
    public static var rootWindow: UIWindow? {
        var window: UIWindow?
        if #available(iOS 13.0, *) {
            outer: for s in windowScenes {
                for w in s.windows where w.isMember(of: UIWindow.self) {
                    window = w
                    break outer
                }
            }
        }
        return window ?? UIApplication.shared.windows.first
    }
    
    /// 获取最外层窗口 需要判断不是UIRemoteKeyboardWindow才行，否则在ipad会存在问题，可能成为虚拟窗口，也可以理解为透明的窗口，会影响其他present的窗口逻辑
    public static var lastWindow: UIWindow? {
        var window: UIWindow?
        if #available(iOS 13.0, *) {
            for s in windowScenes.reversed() {
                window = getLastWindow(ofRemoteKeyboardWindow: s.windows)
                if (window != nil) {
                    break
                }
            }
        }
            
        return window ?? getLastWindow(ofRemoteKeyboardWindow: UIApplication.shared.windows)
    }
    
/// 获取真正的最外层窗口，就是所有窗口的最外层窗口，ipad可能会存在问题，UIRemoteKeyboardWindow在ipad某个版本，关闭后可能是透明窗口，或者为隐藏窗口，会影响present后的窗口弹出问题
    public static var lastWindowInAllWindows: UIWindow? {
        var window: UIWindow?
        if #available(iOS 13.0, *) {
            for s in windowScenes.reversed() {
                window = getLastWindow(ofAllWindows: s.windows)
                if (window != nil) {
                    break
                }
            }
        }
        return window ?? getLastWindow(ofAllWindows: UIApplication.shared.windows)
    }
}

extension SwiftWindow {
    
    /// 获取最后窗口排出UIRemoteKeyboardWindow虚拟窗口，ipad会有问题
    private static func getLastWindow(ofRemoteKeyboardWindow windows: [UIWindow]) -> UIWindow? {
        var window: UIWindow?
        for w in windows.reversed() {
            if let c = NSClassFromString("UIRemoteKeyboardWindow"),
               !w.isMember(of: c.self), !w.isHidden {
                window = w
                break
            }
        }
        
        return window
    }
    
    /// 获取所有窗口的最后一个窗口window，此处window包含UIRemoteKeyboardWindow窗口
    private static func getLastWindow(ofAllWindows windows: [UIWindow]) -> UIWindow? {
        var window: UIWindow?
        for w in windows.reversed() where w.isMember(of: UIWindow.self) {
            if !w.isHidden {
                window = w
                break
            }
        }
        
        return window
    }
    
    /// 获取状态栏高度
    private static var getStatusBarHeight: CGFloat {
        var statusH = UIApplication.shared.statusBarFrame.height
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
    private static var getTouchBarHeight: CGFloat {
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
