//
//  SwiftTextLable.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/5/1.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

///用于区分背景色的唯一标识符
private let linkBgTag = 1992990313
@objc public protocol TextLableDelegate: AnyObject {
    
    /// 点击长链接时回调
    @objc optional func textLable(_ textView: SwiftTextLable, didSelect text: String)
    
    /// 长按时回调（回调字符串是全部内容）
    @objc optional func textLable(_ textView: SwiftTextLable, longPress text: String)
}

@objc(LXObjcTextLableConfig)
@objcMembers open class SwiftTextLableConfig: NSObject {
    
    open var bgColor: UIColor
    open var bgRadius: CGFloat
    
    public init(bgRadius: CGFloat = 6, bgColor: UIColor = UIColor.black.withAlphaComponent(0.1)) {
        self.bgColor = bgColor
        self.bgRadius = bgRadius
    }
}

// MARK: - LXSwiftTextLable
@objc(LXObjcTextLable)
@objcMembers open class SwiftTextLable: UIView {
    @objc open class TextLink: NSObject {
        open var text: String
        open var rang: NSRange
        open var rects: [CGRect]
        public init(text: String, rang: NSRange, rects:  [CGRect]) {
            self.text = text
            self.rang = rang
            self.rects = rects
        }
    }
    
    open weak var delegate: TextLableDelegate?
    private lazy var links = [SwiftTextLable.TextLink]()
    private var config: SwiftTextLableConfig
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 0,
                                       left:-textView.textContainer.lineFragmentPadding,
                                       bottom: 0,
                                       right:-textView.textContainer.lineFragmentPadding)
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
    private lazy var tagGesture: UITapGestureRecognizer = {
        let tagGesture = UITapGestureRecognizer(target: self, action: #selector(gestureTag(gesture:)))
        tagGesture.numberOfTouchesRequired = 1
        return tagGesture
    }()
    
    private lazy var longGesture: UILongPressGestureRecognizer = {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(gestureLong(gesture:)))
        longGesture.minimumPressDuration = 0.8
        return longGesture
    }()

    /// 外部调用以观察存储属性设置大小注释⚠️请在AttributeText之前设置viewframe大小
    open var viewFrame: CGRect? {
        didSet {
            guard let frame = viewFrame else {
                return
            }
            self.frame = frame
            textView.frame = bounds
        }
    }
    
    /// 外部调用以观察存储属性富文本内容⚠️请在AttributeText之前设置viewframe大小
    open var attributedText: NSAttributedString? {
        didSet {
        guard let attr = self.attributedText else {
            return
        }
        textView.attributedText = attr
        attr.enumerateAttributes(in: NSRange(location: 0, length: attr.length), options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (objct, range, stop) in
                let t = objct[NSAttributedString.Key(SwiftRegex.textLinkConst)]
                guard let textM = t as? String else {
                    return
                }
                textView.selectedRange = range
                guard let r = textView.selectedTextRange else {
                    return
                }
                let rselectionRects = textView.selectionRects(for: r)
                var rects: [CGRect] = [CGRect]()
                for selectionRect in rselectionRects{
                    if selectionRect.rect.width == 0 || selectionRect.rect.height == 0 {
                        continue
                    }
                    rects.append(selectionRect.rect)
                }
                links.append(SwiftTextLable.TextLink(text: textM, rang: range, rects: rects))
            }
        }
    }
    
    // MARK: system method
    public init(config: SwiftTextLableConfig = SwiftTextLableConfig()){
        self.config = config
        super.init(frame: CGRect.zero)
        addSubview(textView)
        addGestureRecognizer(longGesture)
        addGestureRecognizer(tagGesture)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - private method
extension SwiftTextLable {
    
    @objc private func gestureLong(gesture: UIGestureRecognizer) {
        if gesture.state ==  UIGestureRecognizer.State.began {
            delegate?.textLable?(self, longPress: self.attributedText?.string ?? "")
        }
    }
    
    @objc private func gestureTag(gesture: UITapGestureRecognizer) {
        gesture.view?.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            gesture.view?.isUserInteractionEnabled = true
            self.removeAllLinkBackground()
        }
        
        if gesture.state == .ended {
            let point = gesture.location(in: gesture.view)
            let link = linkWithPoint(point: point)
            if let l = link {
                showLinkBackground(link: l)
                delegate?.textLable?(self, didSelect: l.text)
            }
        }
    }
    
    private func linkWithPoint(point: CGPoint) -> SwiftTextLable.TextLink? {
        for link in links {
            for rect in link.rects {
                if rect.contains(point) {
                    return link
                }
            }
        }
        return nil
    }
    
    private func showLinkBackground(link: SwiftTextLable.TextLink) {
        for rect in link.rects {
            let bgView = UIView(frame: rect)
            bgView.tag = linkBgTag
            bgView.lx.setCornerRadius(radius: SCALE_IP6_WIDTH_TO_WIDTH(config.bgRadius), clips: true)
            bgView.backgroundColor = config.bgColor
            insertSubview(bgView, belowSubview: textView)
        }
    }
    
    @objc fileprivate func removeAllLinkBackground() {
        for view in subviews {
            if view.tag == linkBgTag {
                view.removeFromSuperview()
            }
        }
    }
}


