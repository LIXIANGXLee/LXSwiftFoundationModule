//
//  LXSwift+ViewController.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

extension UIViewController: LXSwiftCompatible { }

//MARK: -  Extending properties for UIViewController
extension LXSwiftBasics where Base: UIViewController {
    
    /// 状态栏颜色
    public var statusBarStyle: UIStatusBarStyle {
        var lightContent: Bool = false
        if let _ = base as? LXSwiftLightStatusBarProtocol {
            lightContent = true
        }
        if #available(iOS 13.0, *) {
            return lightContent ? .lightContent : .darkContent
        } else {
            return .default
        }
    }

    /// 当前视图是否可见
    public var isVisible: Bool { base.isViewLoaded && (base.view.window != nil) }
    
    /// 当前视图控制器
    public var visibleViewController: UIViewController? { UIApplication.lx.visibleViewController }
    
    /// 模态 presented root
    public var presentViewController: UIViewController? { UIApplication.lx.presentViewController }
    
    /// 控制器 dismiss 销毁
    public func dismissViewController() {
        if base.navigationController != nil {
            base.navigationController?.dismiss(animated: true, completion: nil)
        } else {
            base.dismiss(animated: true, completion: nil)
        }
    }
}
