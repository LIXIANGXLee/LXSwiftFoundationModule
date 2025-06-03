//
//  Swift+ViewController.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

//// 状态栏样式协议 - 遵循此协议的控制器将使用浅色状态栏
protocol SwiftLightStatusBarProtocol { }

// MARK: - UIViewController扩展
extension SwiftBasics where Base: UIViewController {
    
    /// 状态栏样式
    /// - 如果控制器遵循SwiftLightStatusBarProtocol则返回浅色样式
    /// - iOS 13+返回.darkContent或.lightContent，之前版本返回.default
    public var statusBarStyle: UIStatusBarStyle {
        let lightContent = (base is SwiftLightStatusBarProtocol)
        
        if #available(iOS 13.0, *) {
            return lightContent ? .lightContent : .darkContent
        }
        return .default
    }

    /// 判断当前视图控制器是否可见
    /// - 返回: true表示视图已加载且附加在窗口上
    public var isVisible: Bool {
        return base.isViewLoaded && base.view.window != nil
    }
     
    /// 关闭当前视图控制器
    /// - 自动判断是否有导航控制器并选择合适的关闭方式
    public func dismissViewController() {
        if let navController = base.navigationController {
            navController.dismiss(animated: true, completion: nil)
        } else {
            base.dismiss(animated: true, completion: nil)
        }
    }
}
