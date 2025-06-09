//
//  SwiftUIProtocol.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2021/9/4.
//

import UIKit

@objc(LXObjcUIProtocol)
public protocol SwiftUICompatible: AnyObject {
    /// 配置界面元素（子类需重写实现）
   @objc func setupUI()
    
    /// 配置视图模型（子类需重写实现）
   @objc func setupViewModel()

}

@objc(LXObjcTraitProtocol)
public protocol SwiftTraitCompatible: AnyObject {
    /// 界面样式变化回调（需要时在子类中重写）
    /// - Parameter style: 新的界面样式
    func updateTraitCollectionDidChange(_ style: SwiftUserInterfaceStyle)
    
    /// 颜色外观变化回调（需要刷新CGColor时在子类中重写）
    func updateHasDifferentColorAppearance()
}

/// 任意类型协议
public protocol SwiftCellCompatible: AnyObject {
    static var reusableIdentifier: String { get }
}

/// 默认实现协议扩展
public extension SwiftCellCompatible where Self: UIView {
    static var reusableIdentifier: String {
        String(describing: Self.self)
    }
}


// 定义可销毁对象的协议
public protocol SwiftDisposable {
    func dispose()
}
