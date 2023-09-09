//
//  SwiftBasics.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// 扩展系统方法或属性。建议扩展lxswiftbasics
public struct SwiftBasics<Base> {
    
    /// 存储属性参数
    public var base: Base
    
    /// 使用基本对象创建扩展，所有swift类扩展类都是基于LXSwiftBasics做扩展，为了就是命名空间的问题，也是为了避免跟其他框架扩展名相同等问题
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
      
        self.base = base
    }
}




