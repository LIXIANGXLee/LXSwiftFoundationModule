//
//  LXSwiftTextView.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/4/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

// MARK: - TextView class
@objc(LXObjcTextView)
@objcMembers open class LXSwiftTextView: UITextView {
    
    public typealias TextCallBack = (String) -> Void
    open var textCallBack: LXSwiftTextView.TextCallBack?
    
    /// 配置文本可输入最长文本长度
    open var maxTextLength: Int?

    /// 设置字体大小
    open override var font: UIFont? {
        didSet {
            guard let pFont = font else { return }
            if placeholderFont == nil { placehoderLabel.font = pFont }
            setNeedsLayout()
        }
    }
    
    /// 设置默认文案
    open var placeholder: String? {
        didSet {
            guard let text = placeholder else { return }
            placehoderLabel.text = text
            setNeedsLayout()
        }
    }
    
    /// 设置默认文案字体颜色
    open var placeholderColor: UIColor? {
        didSet {
            guard let color = placeholderColor else { return }
            placehoderLabel.textColor = color
            setNeedsLayout()
        }
    }
    
    /// 设置默认文案字体大小，如果不设置则跟输入文本字体大小一致
    open var placeholderFont: UIFont? {
        didSet {
            guard let font = placeholderFont else { return }
            placehoderLabel.font = font
            setNeedsLayout()
        }
    }
    
    /// 显示文案的标签
    private lazy var placehoderLabel: UILabel = {
        let placehoderLabel = UILabel()
        placehoderLabel.numberOfLines = 0
        placehoderLabel.backgroundColor = UIColor.clear
        placehoderLabel.textColor = UIColor.lx_color(withHexString: "999999")
        return placehoderLabel
    }()
    
    public override init(frame: CGRect, textContainer: NSTextContainer? = nil) {
        super.init(frame: frame, textContainer: textContainer)
        addSubview(placehoderLabel)
        
        /// call after placehoderLabel
        font = UIFont.systemFont(ofSize: 16)
        placehoderLabel.font = font

        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 移除通知
    deinit { NotificationCenter.lx_removeObserver(self) }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
     
        let labelX = textContainer.lineFragmentPadding
        let labelY = CGFloat(8)
        let size = self.placehoderLabel.text?.lx.size(font: self.placehoderLabel.font, width: self.frame.width - CGFloat(labelX * 2)) ?? CGSize.zero
        self.placehoderLabel.frame = CGRect(origin: CGPoint(x: labelX, y: labelY), size: size)
    }
}

// MARK: - public method
extension LXSwiftTextView {
   
    /// 外部调用方法
    @objc open func setHandle(_ textCallBack: LXSwiftTextView.TextCallBack?) { self.textCallBack = textCallBack }
    
    /// 设置文本最大长度
    @objc open func setMaxTextLength(_ length: Int) { self.maxTextLength = length }
    
    /// 在赋值text或attributestring之后调用updateUI
    /// 如果设置回调函数setHandle，请在设置updateTextUI之前调用，否则设置text和nsattributestring的属性时回调是不回调的，如果设置text和nsattributestring属性时回调，则必须在调用updateTextUI()之前设置setHandle函数
    @objc open func updateTextUI() { textDidChange() }
    
    /// 设置默认文案和文案字体颜色
    @objc open func setPlaceholder(_ text: String?, color: UIColor?) {
        placehoderLabel.text = text
        if let pColor = color { placehoderLabel.textColor = pColor }
        setNeedsLayout()
    }
}

// MARK: - private method
extension LXSwiftTextView {
    /// 事件监听
    @objc private func textDidChange() {
        placehoderLabel.isHidden = self.hasText
        if let maxLength = self.maxTextLength, let count = text?.count {
            if count > maxLength { text = text?.lx.substring(to: maxLength) }
        }
        textCallBack?(text ?? "")
    }
}
