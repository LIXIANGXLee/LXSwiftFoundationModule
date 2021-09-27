//
//  LXViewController+Extension.swift
//  LXSwiftFoundationModule
//
//  Created by 李响 on 2021/9/24.
//  Copyright © 2021 李响. All rights reserved.
//

import UIKit

extension UIViewController {
    
    
    /// 判断当前控制器是否为一级界面
    public var isFirstLevelPage: Bool {
        return (self as? LXFirstLevelPage) != nil
    }
}
