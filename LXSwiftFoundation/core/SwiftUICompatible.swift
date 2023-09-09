//
//  SwiftUIProtocol.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2021/9/4.
//

import UIKit

@objc(LXObjcUIProtocol)
public protocol SwiftUICompatible: AnyObject {
    func setupUI()
    func setupViewModel()
}

/// 任意类型协议
public protocol SwiftCellCompatible: AnyObject {
    static var reusableSwiftIdentifier: String { get }
}

/// 默认实现协议扩展
public extension SwiftCellCompatible {
    static var reusableSwiftIdentifier: String { "\(self)" }
}

/// 定义圆角背景色协议
public protocol SwiftCustomRoundbackground: AnyObject {
    
    /// 获取view的计算属性
    var associatedView: UIView? { get }
    
    /// 设置背景色和圆角
    func roundSwiftBackground(roundingCorners: UIRectCorner, cornerRadius: CGFloat, backgroundColor: UIColor)
}

extension SwiftCustomRoundbackground where Self: UIView {
    
    /// 默认实现计算属性
    public var associatedView: UIView? { return self }
}

/// 遵守协议
extension UIView: SwiftCustomRoundbackground { }
public extension SwiftUICompatible {
    func setupUI() { }
    func setupViewModel() { }
}
extension SwiftView: SwiftUICompatible {
    @objc open func setupUI() { }
    @objc open func setupViewModel() { }
}
extension SwiftCollectionView: SwiftUICompatible {
    @objc open func setupUI() { }
    @objc open func setupViewModel() { }
}
extension SwiftCollectionViewCell: SwiftUICompatible {
    @objc open func setupUI() { }
    @objc open func setupViewModel() { }
}
extension SwiftScrollView: SwiftUICompatible {
    @objc open func setupUI() { }
    @objc open func setupViewModel() { }
}
extension SwiftTableView: SwiftUICompatible {
    @objc open func setupUI() { }
    @objc open func setupViewModel() { }
}
extension SwiftTableViewCell: SwiftUICompatible {
    @objc open func setupUI() { }
    @objc open func setupViewModel() { }
}
extension SwiftViewController: SwiftUICompatible {
    @objc open func setupUI() { }
    @objc open func setupViewModel() { }
}
