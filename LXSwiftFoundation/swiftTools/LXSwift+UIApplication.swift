//
//  LXSwift+UIApplication.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2019/4/29.
//

import UIKit


private let applicationShared = UIApplication.shared
extension UIApplication: LXSwiftCompatible { }

extension LXSwiftBasics where Base: UIApplication {
    
    /// 当前显示的控制器
    public static var visibleViewController: UIViewController? {
        return UIApplication.lx.getVisibleViewController(from: visibleRootViewController)
    }
    
    /// 获取当前的导航控制器
    public static var visibleNavRootViewController: UINavigationController? {
        let rootVC = visibleRootViewController
        if let navVC = rootVC as? UINavigationController {
            return navVC
        }else if let tabBar = rootVC as? UITabBarController {
            return tabBar.children[tabBar.selectedIndex] as? UINavigationController
        } else {
            return nil
        }
    }

    /// 获取present 控制器
    public static var presentViewController: UIViewController? {
        var aboveController = visibleRootViewController
        while aboveController?.presentedViewController != nil {
            aboveController = aboveController?.presentedViewController
        }
        return aboveController
    }
    
    /// root跟控制器
    public static var visibleRootViewController: UIViewController? {
        return rootWindow?.rootViewController
    }
    
    /// 当前显示的控制器
    public static func getVisibleViewController(from vc: UIViewController?) -> UIViewController? {
        if let nav = vc as? UINavigationController {
            return getVisibleViewController(from: nav.visibleViewController)
        } else if let tab = vc as? UITabBarController {
            return getVisibleViewController(from: tab.selectedViewController)
        } else if let pvc = vc?.presentedViewController {
            return getVisibleViewController(from: pvc)
        }
        return vc
    }

    /// 获取跟窗口
    public static var rootWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            if let window = applicationShared.connectedScenes
                   .filter({$0.activationState == .foregroundActive})
                   .map({$0 as? UIWindowScene})
                   .compactMap({$0})
                   .first?.windows
                   .filter({$0.isKeyWindow}).first {
                   return window
            }else {
                return applicationShared.delegate?.window ?? applicationShared.windows.first
            }
        } else {
               return applicationShared.delegate?.window ?? applicationShared.windows.first
        }
    }
    
    /// 获取最外层窗口 需要判断不是UIRemoteKeyboardWindow才行，否则在ipad会存在问题
    public static var lastWindow: UIWindow? {
        let windows = applicationShared.windows
        var window: UIWindow?
        for i in (0..<windows.count).reversed() {
            if let c = NSClassFromString("UIRemoteKeyboardWindow") {
                if !windows[i].isKind(of: c) {
                    window = windows[i]
                    break
                }
             }
        }
        return window
    }
    
    /// 打开url
    public static func openUrl(_ urlStr: String, completionHandler: ((Bool) -> Void)? = nil) {
        if let url = URL(string: urlStr) {
            openUrl(url, completionHandler: completionHandler)
        }
    }
    
    /// 打开url (特别注意：ios 10 以下版本没有回调)
    public static func openUrl(_ url: URL?, completionHandler: ((Bool) -> Void)? = nil) {
        
        guard let u = url else {
            completionHandler?(false)
            return
        }
        
        if isCanOpen(u) {
            if #available(iOS 10.0, *) {
                applicationShared.open(u, options: [:], completionHandler: completionHandler)
            } else {
                applicationShared.openURL(u)
            }
        }
    }
    
    /// 判断是否能打开url
    public static func isCanOpen(_ url: URL?) -> Bool {
        
       guard let u = url else { return false }
       return applicationShared.canOpenURL(u)
    }
}
