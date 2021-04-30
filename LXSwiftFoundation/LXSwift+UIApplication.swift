//
//  LXSwift+UIApplication.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/4/29.
//

import UIKit

extension UIApplication: LXSwiftCompatible { }

extension LXSwiftBasics where Base: UIApplication {
    
    static var visibleViewController: UIViewController? {
        return UIApplication.lx.getVisibleViewController(from:
                            UIApplication.shared.keyWindow?.rootViewController)
    }

    static func getVisibleViewController(from vc: UIViewController?) -> UIViewController? {
        if let nav = vc as? UINavigationController {
            return getVisibleViewController(from: nav.visibleViewController)
        } else if let tab = vc as? UITabBarController {
            return getVisibleViewController(from: tab.selectedViewController)
        } else if let pvc = vc?.presentedViewController {
            return getVisibleViewController(from: pvc)
        }
        return vc
    }
}
