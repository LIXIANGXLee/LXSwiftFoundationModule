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
    
    /// 协议扩展类型
    associatedtype T
    
    /// 类型扩展属性
    static var lx: LXSwiftBasics<T>.Type { get set }
    
    /// 实例扩展属性
    var lx: LXSwiftBasics<T> { get set }
    
}

/// 扩展协议的计算属性
public extension LXSwiftCompatible {
    
    /// 为了解决结构变异的方法问题，对静态计算属性集进行了扩展
    static var lx: LXSwiftBasics<Self>.Type {
        set {
            
            /// 对于结构体修改属性时加"mutating" 类型后起作用可以写改struct的属性值
        }
        
        get {
            LXSwiftBasics<Self>.self
        }
    }
    
    /// 为了解决结构变异中的方法问题，对实例计算属性集进行了扩展
    var lx: LXSwiftBasics<Self> {
        set {
            
            /// 对于结构体实例修改属性时加"mutating" 类型后起作用可以写改struct的属性值
        }
        
        get {
            LXSwiftBasics<Self>(self)
        }
    }
}

protocol LXSwiftPropertyCompatible {
  
    /// 协议扩展类型
    associatedtype T
    
    /// 类别扩展
    typealias SwiftCallBack = ((T) -> ())
    
    /// 定义闭包类型的计算属性
    var swiftCallBack: SwiftCallBack? { get set }
}

/// view 遵守的协议
public protocol LXViewSetup: AnyObject {
    func setupUI()
    func setupViewModel()
}

/// 任意类型协议
public protocol LXSwiftCellCompatible: AnyObject {
    static var reusableSwiftIdentifier: String { get }
}

/// 默认实现协议扩展
public extension LXSwiftCellCompatible {
    static var reusableSwiftIdentifier: String {
        return "\(self)"
    }
}

/// 定义圆角背景色协议
public protocol LXCustomRoundbackground: AnyObject {
    
    /// 获取view的计算属性
    var associatedView: UIView { get }
    
    /// 设置背景色和圆角
    func roundSwiftBackground(roundingCorners: UIRectCorner, cornerRadius: CGFloat, backgroundColor: UIColor)
}

extension LXCustomRoundbackground where Self: UIView {
    
    /// 默认实现计算属性
    public var associatedView: UIView { return self }
}

/// 状态栏颜色 协议
protocol LXSwiftLightStatusBarProtocol { }
