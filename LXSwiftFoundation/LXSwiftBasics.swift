//
//  LXSwiftBasics.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// Extend the system method or properties. It is recommended to extend lxswiftbasics
public struct LXSwiftBasics<Base> {
    
    /// Base object to extend.
    public let base: Base
    
    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
    
}




