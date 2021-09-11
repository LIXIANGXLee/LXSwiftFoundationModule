//
//  LXSwiftUIProtocol.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2021/9/4.
//

import UIKit

@objc(LXObjcUIProtocol)
public protocol LXSwiftUIProtocol: AnyObject {
    func setupUI()
    func setupViewModel()
}

/// 任意类型协议
public protocol LXSwiftCellCompatible: AnyObject {
    static var reusableSwiftIdentifier: String { get }
}

/// 默认实现协议扩展
public extension LXSwiftCellCompatible {
    static var reusableSwiftIdentifier: String { "\(self)" }
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
