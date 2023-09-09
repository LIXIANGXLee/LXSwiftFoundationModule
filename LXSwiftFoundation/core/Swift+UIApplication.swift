//
//  Swift+UIApplication.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2019/4/29.
//

import UIKit

extension SwiftBasics where Base: UIApplication {

    /// 获取跟窗口
    public static var rootWindow: UIWindow? {
        SwiftWindow.rootWindow
    }
    
    /// 获取最外层窗口 需要判断不是UIRemoteKeyboardWindow才行，否则在ipad会存在问题
    public static var lastWindow: UIWindow? {
        SwiftWindow.lastWindow
    }
    
    /// 获取真正的最外层窗口，就是所有窗口的最外层窗口，ipad可能会存在问题，UIRemoteKeyboardWindow在ipad某个版本，关闭后可能是透明窗口，或者为隐藏窗口，会影响present后的窗口弹出问题
    public static var lastWindowInAllWindows: UIWindow? {
        SwiftWindow.lastWindowInAllWindows
    }
    
    /// root跟控制器
    public static var rootViewController: UIViewController? { rootWindow?.rootViewController
    }
    
    /// 当前显示的控制器(最外层的控制器，也就是最外层window的跟控制器)
    public static var currentViewController: UIViewController? {
        lastWindow?.rootViewController
    }
    
    /// 获取root的导航控制器
    public static var rootNavViewController: UINavigationController? {
        let rootVC = rootViewController
        if let navVC = rootVC as? UINavigationController {
            return navVC
        } else if let tabBar = rootVC as? UITabBarController {
            return tabBar.children[tabBar.selectedIndex] as? UINavigationController
        } else {
            return nil
        }
    }

    /// 获取present 控制器
    public static var presentViewController: UIViewController? {
        var aboveController = rootViewController
        while aboveController?.presentedViewController != nil {
            aboveController = aboveController?.presentedViewController
        }
        return aboveController
    }
  
    /// 获取当前view对应的控制器
    public static func currentViewController(ofView view: UIView) -> UIViewController? {
        
        var responder: UIResponder? = view.next
        while responder != nil {
            if (responder?.isKind(of: UIViewController.self) ?? false) {
                return responder as? UIViewController
            }
            
            responder = responder?.next
        }
        
        return nil
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
                UIApplication.shared.open(u, options: [:], completionHandler: completionHandler)
            } else {
                UIApplication.shared.openURL(u)
            }
        }
    }
    
    /// 判断是否能打开url
    public static func isCanOpen(_ url: URL?) -> Bool {
       guard let u = url else {
           return false
       }
       return UIApplication.shared.canOpenURL(u)
    }
}
