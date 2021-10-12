//
//  LXCommonProtocol.swift
//  LXSwiftFoundationModule
//
//  Created by 李响 on 2021/9/24.
//  Copyright © 2021 李响. All rights reserved.
//

import UIKit

/// 判断是否为一级页面的协议
public protocol LXFirstLevelPage { }

/// 子页面需要向外转发 自己的2个delegate
public protocol LXSubPageDelegate: NSObjectProtocol {
    
    func subPageDidScroll(_ scrollView: UIScrollView)
        
}
