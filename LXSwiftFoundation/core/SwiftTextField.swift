//
//  SwiftTextField.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/9/28.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// 自定义文本框控件，支持文本边距、最大长度限制和文本变化回调
/// - Note: 通过 @objc 暴露给 Objective-C 代码使用
@objc(LXObjcTextField)
@objcMembers open class SwiftTextField: UITextField {
    
    // MARK: - 类型定义
    
    /// 文本变化回调类型别名
    public typealias TextCallBack = (String) -> Void
    
    // MARK: - 公开属性
    
    /// 文本输入区域的内边距设置（可选）
    open var textRectInset: UIEdgeInsets?
    
    /// 文本变化回调闭包
    open var textDidChangeCallback: TextCallBack?
    
    /// 最大文本长度限制（可选）
    open var maxTextLength: Int?
    
    // MARK: - 生命周期管理
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) 未实现，不支持 Storyboard/XIB 初始化")
    }
    
    deinit {
        // 安全移除通知监听
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 视图布局重写
    
    /// 重写文本显示区域
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return adjustedRect(for: bounds)
    }
    
    /// 重写编辑状态显示区域
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return adjustedRect(for: bounds)
    }
    
    // MARK: - 私有方法
    
    /// 公共初始化配置
    private func commonInit() {
        backgroundColor = .white
        addTextChangeObserver()
    }
    
    /// 添加文本变化监听
    private func addTextChangeObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTextDidChange),
            name: UITextField.textDidChangeNotification,
            object: self
        )
    }
    
    /// 计算调整后的文本区域
    private func adjustedRect(for bounds: CGRect) -> CGRect {
        guard let inset = textRectInset else {
            return super.textRect(forBounds: bounds)
        }
        return bounds.inset(by: inset)
    }
    
    /// 处理文本变化事件
    @objc private func handleTextDidChange() {
        enforceMaxLengthIfNeeded()
        notifyTextChange()
    }
    
    /// 执行最大长度限制
    private func enforceMaxLengthIfNeeded() {
        guard let maxLength = maxTextLength, let currentText = text else { return }
        
        if currentText.count > maxLength {
            // 使用 String 的 prefix 方法保证字符安全截取
            text = String(currentText.prefix(maxLength))
        }
    }
    
    /// 通知文本变化
    private func notifyTextChange() {
        textDidChangeCallback?(text ?? "")
    }
}

// MARK: - 公开接口扩展
extension SwiftTextField {
    
    /// 设置文本变化回调（替代直接访问属性）
    public func setTextChangeHandler(_ handler: TextCallBack?) {
        textDidChangeCallback = handler
    }
    
    /// 设置最大文本长度限制（兼容 Objective-C）
    @objc open func configureMaxLength(_ length: Int) {
        maxTextLength = length
    }
    
    /// 配置文本输入区域边距（兼容 Objective-C）
    @objc open func configureTextInset(_ insets: UIEdgeInsets) {
        textRectInset = insets
    }
}
