//
//  LXSwift+UIApplication.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/4/29.
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
        var root = UIApplication.shared.delegate?.window??.rootViewController
        if root == nil {
            root = UIApplication.shared.keyWindow?.rootViewController
        }
        return root
    }
    
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
      
    /// 打开url
    public static func openUrl(_ urlStr: String,
                        completionHandler: ((Bool) -> Void)? = nil) {
        if let url = URL(string: urlStr) {
            openUrl(url,
                    completionHandler: completionHandler)
        }
    }
    
    public static func openUrl(_ url: URL,
                        completionHandler: ((Bool) -> Void)? = nil) {
        if isCanOpen(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: completionHandler)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    /// 判断是否能打开url
    public static func isCanOpen(_ url: URL) -> Bool {
       return UIApplication.shared.canOpenURL(url)
    }
}
