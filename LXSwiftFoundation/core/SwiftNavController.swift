//
//  SwiftNavController.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2021/9/5.
//

import UIKit

/// 自定义导航控制器，用于统一管理导航栏行为和全局样式
@objc(LXObjcNavController)
@objcMembers open class SwiftNavController: UINavigationController {

    // MARK: - Lifecycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // 设置导航控制器的默认背景颜色
        view.backgroundColor = UIColor.white
    }
    
    // MARK: - Navigation
    
    /// 重写导航控制器的推送视图控制器方法
    /// - Parameters:
    ///   - viewController: 要推入栈的视图控制器
    ///   - animated: 是否启用推送动画
    /// - Note:
    /// 1. 自动隐藏底部标签栏（当不是根视图控制器时）
    /// 2. 保留系统动画参数传递
    /// 3. 在视图控制器栈非空时自动隐藏底部栏
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // 当即将推入的不是根视图控制器时，隐藏底部标签栏
        if !viewControllers.isEmpty {
            viewController.hidesBottomBarWhenPushed = true
        }
        
        // 保持父类实现并传递原始动画参数
        super.pushViewController(viewController, animated: animated)
    }
}
