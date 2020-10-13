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
    
    /// current view isVisible
    public var isVisible: Bool {
        return base.isViewLoaded && (base.view.window != nil)
    }
    
    /// presented root
    public var aboveViewController: UIViewController? {
        var aboveController = UIApplication.shared.delegate?.window??.rootViewController
        while aboveController?.presentedViewController != nil {
            aboveController = aboveController?.presentedViewController
        }
        return aboveController
    }
    
    /// dismiss
    public func dismissViewController() {
        if base.navigationController != nil {
            base.navigationController?.dismiss(animated: true, completion: nil)
        }else{
            base.dismiss(animated: true, completion: nil)
        }
    }
}
