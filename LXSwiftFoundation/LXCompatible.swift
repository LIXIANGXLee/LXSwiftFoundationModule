//
//  LXCompatible.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// Define protocol
public protocol LXSwiftCompatible {
    
    /// Extended type
    associatedtype T
    
    /// LXSwiftBasics extensions.
    static var lx: LXSwiftBasics<T>.Type { get set }

    /// LXSwiftBasics extensions.
    var lx: LXSwiftBasics<T> { get set }
    
}

/// Extend calculation properties for protocol
public extension LXSwiftCompatible {
    
    /// In order to solve the problem of method in mutating struct, the static calculation property set is extended
    static var lx: LXSwiftBasics<Self>.Type {
        set {
             // this enables using LXSwiftBasics to "mutating" base type
        }
        
        get {
            LXSwiftBasics<Self>.self
        }
    }
    
    /// In order to solve the problem of method in mutating struct, the instance calculation property set is extended
    var lx: LXSwiftBasics<Self> {
        set {
            // this enables using LXSwiftBasics to "mutating" base type
        }
        
        get {
            LXSwiftBasics<Self>(self)
        }
    }
}

/// Define Property protocol
protocol LXSwiftPropertyCompatible {
  
    /// Extended type
    associatedtype T
    
    ///Alias for callback function
    typealias SwiftCallBack = ((T?) -> ())
    
    ///Define the calculated properties of the closure type
    var swiftCallBack: SwiftCallBack?  { get set }
}

/// cell protocol
public protocol LXSwiftCellCompatible: AnyObject {
    static var reusableSwiftIdentifier: String { get }
}
public extension LXSwiftCellCompatible {
    static var reusableSwiftIdentifier: String {
        return "\(self)"
    }
}
