//
//  LXSwiftNavController.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2021/9/5.
//

import UIKit

open class LXSwiftNavController: UINavigationController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    ///重写系统方法
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
         if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
         }
         super.pushViewController(viewController, animated: true)
    }
}
