//
//  LXSwift+UIApplication.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2019/4/29.
//

import UIKit


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
    public static var visiblePresentViewController: UIViewController? {
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
            if let window = LXApplication.connectedScenes
                   .filter({$0.activationState == .foregroundActive})
                   .map({$0 as? UIWindowScene})
                   .compactMap({$0})
                   .first?.windows
                   .filter({$0.isKeyWindow}).first {
                   return window
            }else {
                return LXApplication.delegate?.window ?? LXApplication.windows.first
            }
        } else {
               return LXApplication.delegate?.window ?? LXApplication.windows.first
        }
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
                LXApplication.open(u, options: [:], completionHandler: completionHandler)
            } else {
                LXApplication.openURL(u)
            }
        }
    }
    
    /// 判断是否能打开url
    public static func isCanOpen(_ url: URL?) -> Bool {
        
       guard let u = url else { return false }
       return LXApplication.canOpenURL(u)
    }
}
