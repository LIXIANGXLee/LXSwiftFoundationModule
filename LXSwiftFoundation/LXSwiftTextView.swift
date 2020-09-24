//
//  LXTextView.swift
//  LXFoundationManager
//
//  Created by XL on 2020/4/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import LXFitManager

///回调
public typealias LXSwiftTextCallBack = (String) -> Void

// MARK: - TextView 文案处理类
open class LXSwiftTextView: UITextView {

    ///输入字符串回调
    public var textCallBack: LXSwiftTextCallBack?
    
    ///默认文案
    public var placehoder: String = "" {
        didSet {
            placehoderLabel.text = placehoder
            setNeedsLayout()
        }
    }
    
    ///默认文案颜色
    public var placehoderColor: UIColor = UIColor.lightGray {
        didSet {
            placehoderLabel.textColor = placehoderColor
        }
    }

    ///显示文案的label
    fileprivate var placehoderLabel: UILabel!
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //销毁
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //布局
    open override func layoutSubviews() {
        super.layoutSubviews()
        let labelX = LXFit.fitInt(5)
        let labelY = LXFit.fitInt(8)
        
        let size = self.placehoder.lx.size(font: placehoderLabel.font, width: self.frame.width - CGFloat(labelX * 2))
        placehoderLabel.frame = CGRect(origin: CGPoint(x: labelX, y: labelY), size: size)
    }
}

extension LXSwiftTextView {
    
    fileprivate func setUI() {
        
        placehoderLabel = UILabel()
        placehoderLabel.font = UIFont.systemFont(ofSize: 14).fitFont
        placehoderLabel.numberOfLines = 0
        placehoderLabel.backgroundColor = UIColor.clear
        addSubview(placehoderLabel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
    }
    
    @objc fileprivate func textDidChange() {
        placehoderLabel.isHidden = self.hasText
        textCallBack?(self.text)
    }
    
    open override var font: UIFont? {
        didSet {
            guard let f = font else { return }
            placehoderLabel.font = f
            setNeedsLayout()
        }
    }
    
    open override var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    open override var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }
}

