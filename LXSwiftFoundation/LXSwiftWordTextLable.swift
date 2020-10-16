//
//  LXWordTextLable.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/5/1.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import LXFitManager

///A unique identifier used to distinguish the background color
private let linkBgTag = 12344321
@objc public protocol LXWordTextLableDelegate: AnyObject {
    @objc optional func lxWordTextLable(_ textView: LXSwiftWordTextLable, didSelect text: String)
    @objc optional func lxWordTextLable(_ textView: LXSwiftWordTextLable, longPress text: String)
}


public struct LXSwiftWordTextLableConfig {
    
    public var bgColor: UIColor
    public var bgRadius: CGFloat
    
    public init(bgRadius: CGFloat = 6, bgColor: UIColor = UIColor.black.withAlphaComponent(0.1)) {
        self.bgColor = bgColor
        self.bgRadius = bgRadius
    }
}

// MARK: - LXSwiftWordTextLable
open class LXSwiftWordTextLable: UIView {
    internal struct TextLink {
        var text: String
        var rang: NSRange
        var rects: [CGRect]
    }
    
    public weak var delegate: LXWordTextLableDelegate?
    private lazy var links = [LXSwiftWordTextLable.TextLink]()
    private var config: LXSwiftWordTextLableConfig
    
    fileprivate lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: LXFit.fitFloat(5), bottom: 0, right: LXFit.fitFloat(-5))
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
    
    ///External call to observe the storage property setting size note ⚠️ Please set viewframe size before attributedtext
    public var viewFrame: CGRect? {
        didSet {
            guard let frame = viewFrame else { return }
            self.frame = frame
            textView.frame = bounds
        }
    }
    
    ///External call to observe storage properties ⚠️ Please set viewframe size before setting attributedtext
    public var attributedText: NSAttributedString? {
        didSet {
            guard let attr = self.attributedText else { return }
            
            textView.attributedText = attr
            
            attr.enumerateAttributes(in: NSRange(location: 0, length: attr.length), options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (objct, range, stop) in
                guard let textM = objct[NSAttributedString.Key(LXSwiftWordRegex.textLinkConst)] as? String else {return}
                textView.selectedRange = range
                guard let r = textView.selectedTextRange else { return }
                let rselectionRects = textView.selectionRects(for: r)
                
                var rects: [CGRect] = [CGRect]()
                for selectionRect in rselectionRects{
                    if selectionRect.rect.width == 0 || selectionRect.rect.height == 0 { continue }
                    rects.append(selectionRect.rect)
                }
                links.append(LXSwiftWordTextLable.TextLink(text: textM, rang: range, rects: rects))
            }
        }
    }
    
    // MARK: system method
    public init(config: LXSwiftWordTextLableConfig = LXSwiftWordTextLableConfig())
    {
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
extension LXSwiftWordTextLable {
    
    @objc private func gestureLong(gesture: UIGestureRecognizer) {
        
        if gesture.state ==  UIGestureRecognizer.State.began {
            delegate?.lxWordTextLable?(self, longPress: self.attributedText?.string ?? "")
        }
    }
    
    /// Click on link response
    @objc private func gestureTag(gesture: UITapGestureRecognizer) {
        
        //Prevention of even click
        gesture.view?.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            gesture.view?.isUserInteractionEnabled = true
            //Remove background after delay
            self.removeAllLinkBackground()
        }
        
        if gesture.state == .ended {
            let point = gesture.location(in: gesture.view)
            let link = linkWithPoint(point: point)
            if let l = link {
                //Set selected link background
                showLinkBackground(link: l)
                //Click the link to inform the outside world
                delegate?.lxWordTextLable?(self, didSelect: l.text)
            }
        }
    }
    
    /// Get links based on click points
    private func linkWithPoint(point: CGPoint) -> LXSwiftWordTextLable.TextLink? {
        for link in links {
            for rect in link.rects {
                if rect.contains(point) { return link  }
            }
        }
        return nil
    }
    
    ///Displays the background of the click
    private func showLinkBackground(link: LXSwiftWordTextLable.TextLink) {
        for rect in link.rects {
            let bgView = UIView(frame: rect)
            bgView.tag = linkBgTag
            bgView.lx.setCornerRadius(LXFit.fitFloat(config.bgRadius), clips: true)
            bgView.backgroundColor = config.bgColor
            insertSubview(bgView, belowSubview: textView)
        }
    }
    
    /// After a few seconds, remove the background from the click display
    @objc fileprivate func removeAllLinkBackground() {
        for view in subviews {
            if view.tag == linkBgTag {
                view.removeFromSuperview()
            }
        }
    }
}


