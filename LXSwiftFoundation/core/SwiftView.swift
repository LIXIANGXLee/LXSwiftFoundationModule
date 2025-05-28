//
//  SwiftView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/4/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// 用户界面样式类型（兼容Objective-C）
/// 注意：与系统`UIUserInterfaceStyle`映射，确保样式转换正确
@objc(LXObjcUserInterfaceStyle)
public enum SwiftUserInterfaceStyle: Int {
    case dark
    case light
    case unspecified // 扩展以处理未指定情况，根据需求调整
    
    /// 根据系统样式初始化
    @available(iOS 12.0, *)
    public init(uiStyle: UIUserInterfaceStyle) {
        switch uiStyle {
        case .dark: self = .dark
        case .light: self = .light
        case .unspecified: self = .unspecified
        @unknown default: self = .unspecified
        }
    }
}

@objc(LXObjcView)
@objcMembers open class SwiftView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        // 使用系统背景颜色适配深色模式
        backgroundColor = .white
        setupUI()
        setupViewModel()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) 不支持，请使用init(frame:)初始化")
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // 仅iOS13+处理样式变化
        if #available(iOS 13.0, *) {
            // 获取当前系统样式并正确映射
            let currentUIStyle = traitCollection.userInterfaceStyle
            let mappedStyle = SwiftUserInterfaceStyle(uiStyle: currentUIStyle)
            
            // 触发样式变化回调（移除performAsCurrent，避免不必要的上下文切换）
            updateTraitCollectionDidChange(mappedStyle)
            
            // 检查颜色外观变化
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                updateHasDifferentColorAppearance()
            }
        }
    }
}

// MARK: - 子类配置方法
extension SwiftView: SwiftUICompatible {
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
extension SwiftView: SwiftTraitCompatible { // 修正协议名称拼写
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
