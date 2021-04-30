//
//  LXTextView.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/4/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

// MARK: - TextView class
open class LXSwiftTextView: UITextView {
    
    public typealias TextCallBack = (String) -> Void
    public var textCallBack: LXSwiftTextView.TextCallBack?
    
    ///Label showing copywriting
    internal var placehoderLabel: UILabel!
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        placehoderLabel = UILabel()
        placehoderLabel.numberOfLines = 0
        placehoderLabel.backgroundColor = UIColor.clear
        addSubview(placehoderLabel)
        
        /// call after placehoderLabel
        font = UIFont.systemFont(ofSize: 14)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///Destruction
    deinit { NotificationCenter.default.removeObserver(self) }
    
    open override var font: UIFont? {
        didSet {
            guard let f = font else { return }
            placehoderLabel.font = f
            setNeedsLayout()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        let labelX = textContainer.lineFragmentPadding
        let labelY = CGFloat(8)
        let size = self.placehoderLabel.text?.lx.size(font: placehoderLabel.font,
                        width: self.frame.width - CGFloat(labelX * 2)) ?? CGSize.zero
        placehoderLabel.frame = CGRect(origin: CGPoint(x: labelX, y: labelY),
                                       size: size)
    }
}

// MARK: - private
private var maxTextLengthKey: Void?
extension LXSwiftTextView {
    
    /// can save maxTextLength
    internal var maxTextLength: Int? {
        get { return lx_getAssociatedObject(self,
                                            &maxTextLengthKey) }
        set { lx_setRetainedAssociatedObject(self,
                                             &maxTextLengthKey,
                                             newValue,.OBJC_ASSOCIATION_ASSIGN) }
    }
    
    /// 事件监听
    @objc internal func textDidChange() {
        placehoderLabel.isHidden = self.hasText
        
        if let maxLength = self.maxTextLength,
           (text?.count ?? 0) > maxLength {
            text = text?.lx.substring(to: maxLength)
        }else{
            textCallBack?(self.text)
        }
    }
}

