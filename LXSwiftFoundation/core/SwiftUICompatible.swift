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
    static var reusableIdentifier: String { get }
}

/// 默认实现协议扩展
public extension SwiftCellCompatible where Self: UIView {
    static var reusableIdentifier: String {
        String(describing: Self.self)
    }
}

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
