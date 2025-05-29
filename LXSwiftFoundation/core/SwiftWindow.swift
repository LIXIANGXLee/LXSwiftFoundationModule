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
            // 使用 lazy 延迟加载优化性能：避免立即处理所有场景
            // flatMap 将多个场景的窗口数组合并成单个数组
            window = windowScenes.lazy.flatMap { $0.windows }.first {
                // 关键检测：精确匹配 UIWindow 基类（排除自定义子类窗口）
                // 确保获取的是系统原生的窗口对象
                $0.isMember(of: UIWindow.self)
            }
        }
        
        // 如果 window == nil的话，则回退方案：使用传统窗口获取方式
        // 兼容旧版系统：使用传统窗口获取方式
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
    
    
    /// 在给定的窗口数组中查找最后一个符合条件的窗口
    /// 条件：1. 非远程键盘窗口 2. 窗口未隐藏
    /// - Parameter windows: 待筛选的窗口数组
    /// - Returns: 符合条件的最后一个窗口（原始数组顺序），若不存在则返回 nil
    private static func findValidWindow(in windows: [UIWindow]) -> UIWindow? {
        // 尝试获取远程键盘窗口类
        // 使用安全转换确保类型匹配，若类不存在则直接处理可见窗口
        guard let keyboardClass = NSClassFromString("UIRemoteKeyboardWindow") as? UIWindow.Type else {
            // 当远程键盘类不存在时（如旧系统版本）
            // 直接返回最后一个可见窗口（无需过滤键盘类型）
            return windows.reversed().first { !$0.isHidden }
        }

        // 优化点：
        // 1. 反向遍历：从窗口层级顶部开始查找（UIWindow 数组通常按层级排序）
        // 2. 惰性求值：使用 lazy 避免创建临时数组，提升大数组处理性能
        // 3. 复合条件：同时满足非隐藏且非远程键盘类型
        return windows.reversed().lazy.first {
            !$0.isHidden && !$0.isMember(of: keyboardClass)
        
        }
    }
    /// 获取当前状态栏高度（兼容所有iOS版本）
    public static var statusBarHeight: CGFloat {
        var height: CGFloat = 0
        
        // MARK: - 首选方案（iOS13+ 场景化窗口方案）
        // 在iOS13及以上系统中，通过窗口场景的状态栏管理器获取高度
        if #available(iOS 13.0, *) {
            // 注意：当应用有多个场景时，rootWindow可能关联当前活动场景
            height = rootWindow?.windowScene?
                .statusBarManager?
                .statusBarFrame.height ?? 0
        }
        
        // 如果已通过场景化方案获取到有效高度，直接返回
        guard height <= 0 else { return height }
        
        // MARK: - 备用方案（全版本兼容降级方案）
        // 获取全局状态栏框架尺寸（此方法在iOS13+已废弃但仍可用）
        let statusFrame = UIApplication.shared.statusBarFrame
        
        // 在iOS11+系统中优先使用安全区域顶部间距
        // 原因：某些特殊状态（如通话/热点）下安全区域更能反映实际状态栏高度
        if #available(iOS 11.0, *) {
            // 安全区域策略：当主窗口安全区域顶部值有效时优先采用
            // 注意：在状态栏隐藏时safeAreaInsets.top可能为0，此时回退到statusFrame
            height = rootWindow?.safeAreaInsets.top ?? statusFrame.height
        } else {
            // iOS11以下系统直接使用状态栏框架高度
            height = statusFrame.height
        }
        
        // MARK: - 终极保底策略
        // 若所有方案均失效（通常发生在早期启动阶段或模拟器异常）
        // 返回传统默认状态栏高度：20pt（非刘海屏标准高度）
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
