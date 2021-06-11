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
        return UIApplication.lx.getVisibleViewController(from:
                            UIApplication.shared.keyWindow?.rootViewController)
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
