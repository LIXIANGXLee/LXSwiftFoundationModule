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
    
    /// 当前视图是否可见
    public var isVisible: Bool {
        return base.isViewLoaded && (base.view.window != nil)
    }
    
    /// 当前视图控制器
    public var visibleViewController: UIViewController? {
        return UIApplication.lx.visibleViewController
    }
    
    /// 模态 presented root
    public var aboveViewController: UIViewController? {
        return UIApplication.lx.visiblePresentViewController
    }
    
    /// 控制器 dismiss 销毁
    public func dismissViewController() {
        if base.navigationController != nil {
            base.navigationController?.dismiss(animated: true, completion: nil)
        }else{
            base.dismiss(animated: true, completion: nil)
        }
    }
}
