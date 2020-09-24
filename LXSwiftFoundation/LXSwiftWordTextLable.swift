//
//  LXWordTextLable.swift
//  LXFoundationManager
//
//  Created by Mac on 2020/5/1.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import LXFitManager

///用来区分背景色的唯一标识
private let linkBgTag = 12344321
@objc public protocol LXWordTextLableDelegate: AnyObject {
    @objc optional func lxWordTextLable(_ textView: LXSwiftWordTextLable, didSelect text: String)
    @objc optional func lxWordTextLable(_ textView: LXSwiftWordTextLable, longPress text: String)
}

// MARK: - 模型类
struct TextLink {
    var text: String
    var rang: NSRange
    var rects: [CGRect]
}

public struct LXSwiftWordTextLableConfig {
    
    public var bgColor: UIColor
    public var bgRadius: CGFloat
    
    public init(bgRadius: CGFloat = 6, bgColor: UIColor = UIColor.black.withAlphaComponent(0.1)) {
        self.bgColor = bgColor
        self.bgRadius = bgRadius
    }
}

// MARK: - 文本类
open class LXSwiftWordTextLable: UIView {
    
    // MARK: private 属性
    //代理属性
    public weak var delegate: LXWordTextLableDelegate?
    //存储TextLink的数组
    private lazy var links: [TextLink] = [TextLink]()
     //配置信息
    private var config: LXSwiftWordTextLableConfig
    
    //文本展示
    fileprivate lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: LXFit.fitInt(5), bottom: 0, right: LXFit.fitInt(-5))
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
     //单机
    fileprivate lazy var tagGesture: UITapGestureRecognizer = {
        let tagGesture = UITapGestureRecognizer(target: self, action: #selector(gestureTag(gesture:)))
        tagGesture.numberOfTouchesRequired = 1
        return tagGesture
    }()
    
    //长按
    fileprivate lazy var longGesture: UILongPressGestureRecognizer = {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(gestureLong(gesture:)))
        longGesture.minimumPressDuration = 0.8
        return longGesture
    }()
    
    // MARK: public
    
    ///外部调用 观察存储属性 设置尺寸   注意 ⚠️ 请在  attributedText 之前设置viewFrame尺寸
    public var viewFrame: CGRect? {
        didSet {
            guard let frame = viewFrame else { return }
            self.frame = frame
            textView.frame = bounds
        }
    }
    
    ///外部调用 观察存储属性  注意 ⚠️ 请先设置 viewFrame尺寸 在设置 attributedText
   public var attributedText: NSAttributedString? {
        didSet {
           guard let attr = self.attributedText else { return }
            
            textView.attributedText = attr

            attr.enumerateAttributes(in: NSRange(location: 0, length: attr.length), options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (objct, range, stop) in
                guard let textM = objct[NSAttributedString.Key(textLinkConst)] as? String else {return}
                textView.selectedRange = range
                guard let r = textView.selectedTextRange else { return }
                let rselectionRects = textView.selectionRects(for: r)

                var rects: [CGRect] = [CGRect]()
                for selectionRect in rselectionRects{
                    if selectionRect.rect.width == 0 || selectionRect.rect.height == 0 { continue }
                    rects.append(selectionRect.rect)
                }
                links.append(TextLink(text: textM, rang: range, rects: rects))
            }
        }
    }
    
      // MARK: system 函数
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


// MARK: private 函数
extension LXSwiftWordTextLable {
    
    ///长按响应
    @objc private func gestureLong(gesture: UIGestureRecognizer) {
                
        if gesture.state ==  UIGestureRecognizer.State.began {
            delegate?.lxWordTextLable?(self, longPress: self.attributedText?.string ?? "")
        }
    }
    
    /// 点击链接响应
    @objc private func gestureTag(gesture: UITapGestureRecognizer) {
        
        //预防连点击
        gesture.view?.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            gesture.view?.isUserInteractionEnabled = true
            //延迟后移除背景
            self.removeAllLinkBackground()
        }
        
        if gesture.state == .ended {
            let point = gesture.location(in: gesture.view)
            let link = linkWithPoint(point: point)
            if let l = link {
                //设置选中链接背景
                showLinkBackground(link: l)
                //点击链接 通知外界
                delegate?.lxWordTextLable?(self, didSelect: l.text)
            }
        }
 
    }
    
    /// 根据点击点获取链接
    private func linkWithPoint(point: CGPoint) -> TextLink? {
        for link in links {
            for rect in link.rects {
                if rect.contains(point) {
                    return link
                }
            }
        }
        return nil
    }
    
    ///显示点击的背景
    private func showLinkBackground(link: TextLink) {
        for rect in link.rects {
            let bgView = UIView(frame: rect)
            bgView.tag = linkBgTag
            bgView.lx.setCornerRadius(LXFit.fitFloat(config.bgRadius), clips: true)
            bgView.backgroundColor = config.bgColor
            insertSubview(bgView, belowSubview: textView)
        }
    }
    
    /// 几秒后移除点击显示的背景
   @objc fileprivate func removeAllLinkBackground() {
        for view in subviews {
            if view.tag == linkBgTag {
                view.removeFromSuperview()
            }
        }
    }
}


