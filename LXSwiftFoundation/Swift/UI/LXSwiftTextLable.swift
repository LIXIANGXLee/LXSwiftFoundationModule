//
//  LXTextLable.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/5/1.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

///用于区分背景色的唯一标识符
private let linkBgTag = 1234994321
@objc public protocol LXTextLableDelegate: AnyObject {
    
    /// 点击长链接时回调
    @objc optional func lxTextLable(_ textView: LXSwiftTextLable, didSelect text: String)
    
    /// 长按时回调（回调字符串是全部内容）
    @objc optional func lxTextLable(_ textView: LXSwiftTextLable, longPress text: String)
}

public struct LXSwiftTextLableConfig {
    
    public var bgColor: UIColor
    public var bgRadius: CGFloat
    
    public init(bgRadius: CGFloat = 6, bgColor: UIColor = UIColor.black.withAlphaComponent(0.1)) {
        self.bgColor = bgColor
        self.bgRadius = bgRadius
    }
}

// MARK: - LXSwiftTextLable
open class LXSwiftTextLable: UIView {
    struct TextLink {
        var text: String
        var rang: NSRange
        var rects: [CGRect]
    }
    
    public weak var delegate: LXTextLableDelegate?
    private lazy var links = [LXSwiftTextLable.TextLink]()
    private var config: LXSwiftTextLableConfig
    
    fileprivate lazy var textView: UITextView = {
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
    
    fileprivate lazy var tagGesture: UITapGestureRecognizer = {
        let tagGesture = UITapGestureRecognizer(target: self, action: #selector(gestureTag(gesture:)))
        tagGesture.numberOfTouchesRequired = 1
        return tagGesture
    }()
    
    fileprivate lazy var longGesture: UILongPressGestureRecognizer = {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(gestureLong(gesture:)))
        longGesture.minimumPressDuration = 0.8
        return longGesture
    }()

    /// 外部调用以观察存储属性设置大小注释⚠️请在AttributeText之前设置viewframe大小
    public var viewFrame: CGRect? {
        didSet {
            guard let frame = viewFrame else { return }
            self.frame = frame
            textView.frame = bounds
        }
    }
    
    /// 外部调用以观察存储属性富文本内容⚠️请在AttributeText之前设置viewframe大小
    public var attributedText: NSAttributedString? {
        didSet {
        guard let attr = self.attributedText else { return }
        
        textView.attributedText = attr
        attr.enumerateAttributes(in: NSRange(location: 0, length: attr.length), options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (objct, range, stop) in
                let t = objct[NSAttributedString.Key(LXSwiftRegex.textLinkConst)]
                guard let textM = t as? String else { return }
                textView.selectedRange = range
                guard let r = textView.selectedTextRange else { return }
                let rselectionRects = textView.selectionRects(for: r)
                var rects: [CGRect] = [CGRect]()
                for selectionRect in rselectionRects{
                    if selectionRect.rect.width == 0 || selectionRect.rect.height == 0 { continue }
                    rects.append(selectionRect.rect)
                }
                links.append(LXSwiftTextLable.TextLink(text: textM, rang: range, rects: rects))
            }
        }
    }
    
    // MARK: system method
    public init(config: LXSwiftTextLableConfig = LXSwiftTextLableConfig()){
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

// MARK: private method
extension LXSwiftTextLable {
    
    @objc private func gestureLong(gesture: UIGestureRecognizer) {
        if gesture.state ==  UIGestureRecognizer.State.began {
            delegate?.lxTextLable?(self, longPress: self.attributedText?.string ?? "")
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
                delegate?.lxTextLable?(self, didSelect: l.text)
            }
        }
    }
    
    private func linkWithPoint(point: CGPoint) -> LXSwiftTextLable.TextLink? {
        for link in links {
            for rect in link.rects {
                if rect.contains(point) { return link }
            }
        }
        return nil
    }
    
    private func showLinkBackground(link: LXSwiftTextLable.TextLink) {
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


