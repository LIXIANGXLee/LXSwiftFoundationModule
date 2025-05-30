//
//  Compatible.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import AVFoundation

/// Define protocol
public protocol SwiftCompatible {
    
    /// 协议扩展类型
    associatedtype T
    
    /// 类型扩展属性
    static var lx: SwiftBasics<T>.Type { get set }
    
    /// 实例扩展属性
    var lx: SwiftBasics<T> { get set }
    
}

/// 扩展协议的计算属性
public extension SwiftCompatible {
    
    /// 为了解决结构变异的方法问题，对静态计算属性集进行了扩展
    static var lx: SwiftBasics<Self>.Type {
        set {
            
            /// 对于结构体修改属性时加"mutating" 类型后起作用可以写改struct的属性值
        }
        
        get { SwiftBasics<Self>.self }
    }
    
    /// 为了解决结构变异中的方法问题，对实例计算属性集进行了扩展
    var lx: SwiftBasics<Self> {
        set {
            
            /// 对于结构体实例修改属性时加"mutating" 类型后起作用可以写改struct的属性值
        }
        
        get { SwiftBasics<Self>(self) }
    }
}

/// 遵守协议
extension UIView: SwiftCompatible { }
extension Array: SwiftCompatible { }
extension UIBezierPath: SwiftCompatible { }
extension Bundle: SwiftCompatible { }
extension CALayer: SwiftCompatible { }
extension UIColor: SwiftCompatible { }
extension NSAttributedString: SwiftCompatible{ }
extension NSNumber: SwiftCompatible { }
extension CGRect: SwiftCompatible { }
extension NSData: SwiftCompatible { }
extension Date: SwiftCompatible { }
extension UIDevice: SwiftCompatible { }
extension Dictionary: SwiftCompatible { }
extension UIEdgeInsets: SwiftCompatible { }
extension UIFont: SwiftCompatible { }
extension UIImage: SwiftCompatible { }
extension UIApplication: SwiftCompatible { }
extension URL: SwiftCompatible { }
extension UIViewController: SwiftCompatible { }
extension Data: SwiftCompatible { }
extension DispatchQueue: SwiftCompatible { }
extension CGFloat: SwiftCompatible { }
extension Double: SwiftCompatible { }
extension Int: SwiftCompatible { }
extension String: SwiftCompatible { }
extension AVAsset: SwiftCompatible { }
extension AVURLAsset: SwiftCompatible { }
extension NotificationCenter: SwiftCompatible { }

