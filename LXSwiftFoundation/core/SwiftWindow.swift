//
//  SwiftWindow.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/4/22.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// 屏幕宽度
public let SCREEN_WIDTH_TO_WIDTH = SwiftWindow.width

/// 屏幕高度
public let SCREEN_HEIGHT_TO_HEIGHT = SwiftWindow.height

/// 底部刘海
public let SCREEN_HEIGHT_TO_BOTTOMSAFEHEIGHT = SwiftWindow.bottomSafeHeight

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


// MARK: - LXObjcWindow const
/// define app const
@objc(LXObjcWindow)
@objcMembers public final class SwiftWindow: NSObject {

    /// 当前主屏幕的边界矩形（基于屏幕原始方向，不考虑界面旋转）
    /// - Note: 该尺寸反映屏幕的物理尺寸，而非应用界面的当前尺寸。在多窗口应用中请使用窗口尺寸。
    public static let bounds = UIScreen.main.bounds
    
    /// 主屏幕的物理宽度（基于屏幕原始方向）
    public static let width = bounds.width
    
    /// 主屏幕的物理高度（基于屏幕原始方向）
    public static let height = bounds.height
    
    // 系统导航栏标准高度（不含状态栏）
    private static let standardNavigationBarHeight: CGFloat = 44
   
    // 系统标签栏标准高度（不含安全区域）
    private static let standardTabBarHeight: CGFloat = 49

    /// 完整导航栏高度（状态栏 + 导航栏）
      /// - 说明: 在全面屏设备上约为88pt，传统设备上为64pt
      public static let navBarHeight: CGFloat = statusBarHeight + standardNavigationBarHeight
      
    /// 完整标签栏高度（底部安全区域 + 标签栏）
    /// - 说明: 在刘海屏设备上约为83pt，传统设备上为49pt
    /// - 注意: 当需要避免内容被底部刘海遮挡时，建议使用此高度
    public static let tabBarHeight: CGFloat = bottomSafeHeight + standardTabBarHeight
    
    @available(iOS 13.0, *)
    public static var windowScenes: [UIWindowScene] {
        // 获取所有处于前台且活跃状态的窗口场景
        UIApplication.shared.connectedScenes
            // 合并过滤和类型转换操作：
            // 1. 检查场景是否处于前台活跃状态
            // 2. 尝试将场景转换为 UIWindowScene 类型
            // 3. compactMap 自动过滤掉转换失败（nil）的结果
            .compactMap { scene in
                guard scene.activationState == .foregroundActive else {
                    return nil
                }
                return scene as? UIWindowScene
            }
    }
    
    /// 获取应用程序的根窗口（优先获取原生 UIWindow 类型的窗口）
    ///
    /// 注意：
    /// 1. iOS 13+ 从活跃场景中查找原生窗口
    /// 2. 早期系统版本使用共享应用的第一个窗口
    /// 3. 使用 isMember(of:) 确保获取的是 UIWindow 基类实例（非子类）
    public static var rootWindow: UIWindow? {
        var window: UIWindow?
        if #available(iOS 13.0, *) {
            // 扁平化处理所有场景的窗口，使用 lazy 优化性能
            window = windowScenes.lazy.flatMap { $0.windows }.first {
                // 精确匹配 UIWindow 基类实例（排除自定义子类窗口）
                $0.isMember(of: UIWindow.self)
            }
        }
        
        // 如果 window == nil的话，则回退方案：使用传统窗口获取方式
        return window ?? UIApplication.shared.windows.first

    }
    
    /// 获取最外层可见窗口（排除远程键盘窗口）
    ///
    /// 解决 iPad 上虚拟键盘窗口影响弹窗层级的问题
    ///
    /// 筛选策略：
    /// 1. iOS 13+：反向遍历活跃场景窗口
    /// 2. 早期系统：全局反向搜索
    public static var lastWindow: UIWindow? {
        // iOS 13+ 多场景处理
        var window: UIWindow?
        if #available(iOS 13.0, *) {
            for scene in windowScenes.reversed() {
                window = findValidWindow(in: scene.windows)
                if (window != nil) {
                    break
                }
            }
        }
        
        // 早期系统全局处理
        return window ?? findValidWindow(in: UIApplication.shared.windows)
    }
    
    
    /// 在给定的窗口数组中查找最后一个符合条件的窗口（非远程键盘窗口且未隐藏）
    /// - Parameter windows: 待筛选的窗口数组
    /// - Returns: 符合条件的最后一个窗口，若不存在则返回 nil
    private static func findValidWindow(in windows: [UIWindow]) -> UIWindow? {
        // 提前获取远程键盘窗口类（避免循环内重复获取）
        // 使用安全转换确保类型正确，若类不存在则返回最后一个可见窗口
        guard let keyboardClass = NSClassFromString("UIRemoteKeyboardWindow") as? UIWindow.Type else {
            return windows.reversed().first { !$0.isHidden }
        }

        // 使用反向遍历 + 惰性计算优化大数组性能
        // 找到第一个同时满足以下条件的窗口：
        // 1. 不是远程键盘窗口类型
        // 2. 窗口处于可见状态
        return windows.reversed().lazy.first {
            !$0.isHidden && !$0.isMember(of: keyboardClass)
        
        }
    }
    /// 系统状态栏高度（包含刘海屏适配）
    public static var statusBarHeight: CGFloat {
        var height: CGFloat = 0
        
        // iOS13+ 使用场景状态栏管理器
        if #available(iOS 13.0, *) {
            height = rootWindow?.windowScene?
                .statusBarManager?
                .statusBarFrame.height ?? 0
        }
        
        // 备用方案：从状态栏框架或安全区域获取
        guard height <= 0 else { return height }
        
        // 当无法通过场景获取时，降级处理方案
        let statusFrame = UIApplication.shared.statusBarFrame
        if #available(iOS 11.0, *) {
            height = rootWindow?.safeAreaInsets.top ?? statusFrame.height
        } else {
            height = statusFrame.height
        }
        
        // 最终保底值（默认状态栏高度）
        return height > 0 ? height : 20
    }
    
    /// 底部安全区域高度（用于兼容带 Home Indicator 的设备）
    public static var bottomSafeHeight: CGFloat {
        if #available(iOS 11.0, *) {
            return rootWindow?.safeAreaInsets.bottom ?? 0
        }
        return 0
    }
}
