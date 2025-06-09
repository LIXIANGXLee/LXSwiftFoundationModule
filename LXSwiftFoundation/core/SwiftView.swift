//
//  SwiftView.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/4/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// 用户界面样式类型（兼容Objective-C）
/// 注意：与系统`UIUserInterfaceStyle`一一映射，确保样式转换正确
@objc(LXObjcUserInterfaceStyle)
public enum SwiftUserInterfaceStyle: Int {
    case dark
    case light
    case unspecified // 扩展以处理未指定情况
    
    /// 根据系统样式初始化（iOS12+）
    @available(iOS 12.0, *)
    public init(uiStyle: UIUserInterfaceStyle) {
        switch uiStyle {
        case .dark: self = .dark
        case .light: self = .light
        default: self = .unspecified // 包含.unspecified和未知情况
        }
    }
}

@objc(LXObjcView)
@objcMembers open class SwiftView: UIView {
    // MARK: - 公共属性
    
    /// 通用扩展参数容器（可用于传递自定义数据）
    /// 示例：`swiftImgView.swiftModel = YourCustomModel()`
    public var swiftModel: Any?
    
    /// 点击事件回调（自动处理弱引用）
    open var handler: ((_ view: SwiftView) -> Void)?
    
    /// 点击防抖时间间隔（默认 0.5 秒，更合理的时间）
    open var throttleInterval: TimeInterval = 0.5
    
    // MARK: - 生命周期
    
    deinit { lx.removeTapGesture() }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureBaseSettings()
        setupUI()
        setupViewModel()
    }
    
    required public init?(coder: NSCoder) {
        // 提供更友好的错误提示
        fatalError("init(coder:) 不支持，请使用代码布局方式初始化")
    }
    
    // MARK: - 视图配置
    private func configureBaseSettings() {
        // 跨版本背景色适配
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
        } else {
            backgroundColor = .white
        }
        lx.addTapGesture(completionHandler: tap(_:))

    }
    
    // MARK: - 深色模式处理
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
    
    // MARK: - 点击处理
    /// 处理点击事件
    @objc private func tap(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else { return }
        
        // 防抖处理：点击后临时禁用交互
        isUserInteractionEnabled = false
        defer {
            // 延迟恢复交互（确保即使提前释放也不会崩溃）
            DispatchQueue.lx.delay(throttleInterval) { [weak self] in
                self?.isUserInteractionEnabled = true
            }
        }
        
        // 执行回调（传递弱引用避免循环）
        handler?(self)
    }
}

// MARK: - 子类重写扩展
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

