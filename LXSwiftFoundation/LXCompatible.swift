//
//  LXCompatible.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// Define protocol
public protocol LXSwiftCompatible { }

/// Extend calculation properties for protocol
public extension LXSwiftCompatible {
    
    /// In order to solve the problem of method in mutating struct, the static calculation property set is extended
    static var lx: LXSwiftBasics<Self>.Type {
        set { }
        get { LXSwiftBasics<Self>.self }
    }
    
    
    /// In order to solve the problem of method in mutating struct, the instance calculation property set is extended
    var lx: LXSwiftBasics<Self> {
        set { }
        get { LXSwiftBasics<Self>(self)}
    }
    
}

/// Define protocol
public protocol LXSwiftUICompatible {
    var swiftModel: Any? { get set }
}

