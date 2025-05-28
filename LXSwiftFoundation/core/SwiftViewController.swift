//
//  LXSwiftViewController.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/4/23.
//  Copyright © 2020 李响. All rights reserved.
//
import UIKit


/// 基础视图控制器（兼容Objective-C），提供界面样式变化处理
@objc(LXObjcViewController)
@objcMembers open class SwiftViewController: UIViewController {
    
    // MARK: - 生命周期
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupViewModel()
    }
    
    // MARK: - 特性变化处理
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        handleTraitCollectionChanges(previousTraitCollection)
    }
}

// MARK: - 暗黑模式处理
private extension SwiftViewController {
    /// 处理所有特性变化
    func handleTraitCollectionChanges(_ previousTraitCollection: UITraitCollection?) {
        guard #available(iOS 13.0, *) else { return }
        
        handleInterfaceStyleChange()
        handleColorAppearanceChange(previousTraitCollection)
    }
    
    /// 处理界面样式变化（明/暗模式切换）
    @available(iOS 13.0, *)
    func handleInterfaceStyleChange() {
        guard let style = currentInterfaceStyle else { return }
        
        traitCollection.performAsCurrent { [weak self] in
            self?.updateTraitCollectionDidChange(style)
        }
    }
    
    /// 处理颜色外观变化（需刷新CGColor）
    @available(iOS 13.0, *)
    func handleColorAppearanceChange(_ previousTraitCollection: UITraitCollection?) {
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
        updateHasDifferentColorAppearance()
    }
    
    /// 当前界面样式（过滤unspecified情况）
    @available(iOS 13.0, *)
    var currentInterfaceStyle: SwiftUserInterfaceStyle? {
        switch traitCollection.userInterfaceStyle {
        case .dark: return .dark
        case .light: return .light
        default: return nil
        }
    }
}

// MARK: - 子类配置方法
extension SwiftViewController: SwiftUICompatible {
    /// 配置界面元素（子类必须重写，无需调用super）
    @objc open func setupUI() {
        // 示例：在此添加子视图、约束等
    }
    
    /// 配置视图模型（子类必须重写，无需调用super）
    @objc open func setupViewModel() {
        // 示例：在此绑定数据模型、监听事件等
    }
}

// MARK: - 样式变化回调
extension SwiftViewController: SwiftTraitCompatible { // 修正协议名称拼写
    /// 界面样式变化回调（子类按需重写）
    /// - Parameter style: 映射后的界面样式
    @objc open func updateTraitCollectionDidChange(_ style: SwiftUserInterfaceStyle) {
        // 示例：根据style更新界面颜色等
        // 注意：无需手动调用setNeedsDisplay，系统会自动触发绘制
    }
    
    /// 颜色外观变化回调（处理CGColor相关更新）
    @objc open func updateHasDifferentColorAppearance() {
        // 示例：更新CALayer的borderColor等CGColor属性
        // 注意：UIColor的CGColor可能在模式切换后失效，需在此重新获取
    }
}
