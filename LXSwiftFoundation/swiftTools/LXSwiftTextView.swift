//
//  LXTextView.swift
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
    public var textCallBack: LXSwiftTextView.TextCallBack?
    
    /// 显示文案的标签
    var placehoderLabel: UILabel?
    public override init(frame: CGRect, textContainer: NSTextContainer? = nil) {
        super.init(frame: frame, textContainer: textContainer)
        placehoderLabel = UILabel()
        placehoderLabel?.numberOfLines = 0
        placehoderLabel?.backgroundColor = UIColor.clear
        if placehoderLabel != nil {
            addSubview(placehoderLabel!)
        }
        
        /// call after placehoderLabel
        font = UIFont.lx.font(withRegular: 14)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 移除通知
    deinit { NotificationCenter.lx_removeObserver(self) }
    
    /// 外部调用方法
    open func setHandle(_ textCallBack: LXSwiftTextView.TextCallBack?) {
        self.textCallBack = textCallBack
    }
    
    open override var font: UIFont? {
        didSet {
            guard let pFont = font else { return }
            placehoderLabel?.font = pFont
            setNeedsLayout()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard let label = self.placehoderLabel else { return }
     
        let labelX = textContainer.lineFragmentPadding
        let labelY = CGFloat(8)
   
        let size = label.text?.lx.size(font: label.font, width: self.frame.width - CGFloat(labelX * 2)) ?? CGSize.zero
        label.frame = CGRect(origin: CGPoint(x: labelX, y: labelY), size: size)
    }
}

// MARK: - private
private var maxTextLengthKey: Void?
extension LXSwiftTextView {
    
    /// 设置输入文本最大长度
    var maxTextLength: Int? {
        get { return lx_getAssociatedObject(self, &maxTextLengthKey) }
        set { lx_setRetainedAssociatedObject(self, &maxTextLengthKey, newValue,.OBJC_ASSOCIATION_ASSIGN) }
    }
    
    /// 事件监听
    @objc func textDidChange() {
        placehoderLabel?.isHidden = self.hasText
        
        if let maxLength = self.maxTextLength,
           (text?.count ?? 0) > maxLength {
            text = text?.lx.substring(to: maxLength)
        }else{
            textCallBack?(self.text)
        }
    }
}
