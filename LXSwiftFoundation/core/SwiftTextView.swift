//
//  SwiftTextView.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/4/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

// MARK: - TextView class
@objc(LXObjcTextView)
@objcMembers open class SwiftTextView: UITextView {
    
    // MARK: - 公开属性
    /// 文本变化回调闭包
    open var textHandler: ((String) -> Void)?
      
    /// 最大输入字符数（设置为nil时不限制）
    open var maxTextLength: Int?
      
    /// 占位符标签
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.textColor = .lx.color(hex: "999999")
        return label
    }()

    /// 设置字体大小
    open override var font: UIFont? {
        didSet {
            guard let font = font,
                    placeholderFont == nil else { return }
            placeholderLabel.font = font
            setNeedsLayout()
        }
    }
    
    /// 设置占位符文本
    open var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
            setNeedsLayout()
        }
    }
    
    /// 设置占位符文本颜色
    open var placeholderColor: UIColor? {
        didSet {
            guard let color = placeholderColor else {
                return
            }
            placeholderLabel.textColor = color
            setNeedsLayout()
        }
    }
    
    /// 设置占位符字体（如果未设置则使用输入框字体）
    open var placeholderFont: UIFont? {
        didSet {
            guard let font = placeholderFont else {
                return
            }
            placeholderLabel.font = font
            setNeedsLayout()
        }
    }
    
    // MARK: - 初始化方法
    public override init(frame: CGRect, textContainer: NSTextContainer? = nil) {
        super.init(frame: frame, textContainer: textContainer)
        configureBaseSettings()
        setupNotifications()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 生命周期管理
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 布局方法
    open override func layoutSubviews() {
        super.layoutSubviews()
        updatePlaceholderLayout()
    }
}

// MARK: - public method
extension SwiftTextView {
    
    /// 在赋值text或attributestring之后调用updateUI
    /// 如果设置回调函数setHandle，请在设置updateTextUI之前调用，否则设置text和nsattributestring的属性时回调是不回调的，如果设置text和nsattributestring属性时回调，则必须在调用updateTextUI()之前设置setHandle函数
    @objc open func updateTextUI() {
        textDidChange()
    }
    
    /// 设置默认文案和文案字体颜色
    @objc open func setPlaceholder(_ text: String?, color: UIColor?) {
        placeholderLabel.text = text
        if let pColor = color {
            placeholderLabel.textColor = pColor
        }
        setNeedsLayout()
    }
}

// MARK: - private method
extension SwiftTextView {
    
    
    private func configureBaseSettings() {
        // 跨版本背景色适配
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
        } else {
            backgroundColor = .white
        }

        addSubview(placeholderLabel)
        font = UIFont.systemFont(ofSize: 16)
        placeholderLabel.font = font
    }
    
    /// 初始化界面配置
   private func setupUI() {
        addSubview(placeholderLabel)
        font = UIFont.systemFont(ofSize: 16)
        placeholderLabel.font = font
    }
    
    /// 设置通知监听
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextView.textDidChangeNotification,
            object: self
        )
    }
    
    /// 更新占位符布局
    private func updatePlaceholderLayout() {
        let linePadding = textContainer.lineFragmentPadding
        let inset = textContainerInset
        let maxWidth = frame.width - linePadding * 2 - inset.left - inset.right
        
        let size = placeholderLabel.sizeThatFits(
            CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        
        placeholderLabel.frame = CGRect(
            x: linePadding + inset.left,
            y: inset.top,
            width: maxWidth,
            height: size.height
        )
    }
    
    /// 事件监听
    @objc private func textDidChange() {
        placeholderLabel.isHidden = self.hasText
  
        guard let maxLength = maxTextLength,
              let currentText = text else { return }
        
        if currentText.count > maxLength {
            // 使用 String 的 prefix 方法保证字符安全截取
            text = String(currentText.prefix(maxLength))
        }
        
        textHandler?(text ?? "")
    }
}
