//
//  LXSwiftBasics.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

///扩展系统方法或属性。建议扩展lxswiftbasics
public struct LXSwiftBasics<Base> {
    
    /// Base object to extend.
    public var base: Base
    
    /// 使用基本对象创建扩展。
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
}




