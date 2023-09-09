//
//  Swift+ViewController.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// 状态栏颜色 协议
protocol SwiftLightStatusBarProtocol { }

//MARK: -  Extending properties for UIViewController
extension SwiftBasics where Base: UIViewController {
    
    /// 状态栏颜色
    public var statusBarStyle: UIStatusBarStyle {
        var lightContent: Bool = false
        if let _ = base as? SwiftLightStatusBarProtocol {
            lightContent = true
        }
        if #available(iOS 13.0, *) {
            return lightContent ? .lightContent : .darkContent
        }
        return .default
    }

    /// 当前视图是否可见
    public var isVisible: Bool {
        base.isViewLoaded && (base.view.window != nil)
        
    }
     
    /// 控制器 dismiss销毁
    public func dismissViewController() {
        if base.navigationController != nil {
            base.navigationController?.dismiss(animated: true, completion: nil)
        } else {
            base.dismiss(animated: true, completion: nil)
        }
    }
}
