//
//  SwiftTextLable.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/5/1.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// 用于背景视图的唯一标识符（避免与其他视图冲突）
private let linkBackgroundTag = 1992990313

/// 文本标签代理协议
@objc public protocol TextLableDelegate: AnyObject {
    
    /// 点击链接时的回调
    @objc optional func textLable(_ textView: SwiftTextLable, didSelect text: String)
    
    /// 长按整个文本的回调
    @objc optional func textLable(_ textView: SwiftTextLable, longPress text: String)
}

/// 文本标签配置类
@objc(LXObjcTextLableConfig)
@objcMembers open class SwiftTextLableConfig: NSObject {
    
    /// 链接背景色
    open var bgColor: UIColor
    
    /// 链接背景圆角半径
    open var bgRadius: CGFloat
    
    /// 初始化配置
    public init(bgRadius: CGFloat = 6,
                bgColor: UIColor = UIColor.black.withAlphaComponent(0.1)) {
        self.bgColor = bgColor
        self.bgRadius = bgRadius
    }
}

// MARK: - 文本标签主类
@objc(LXObjcTextLable)
@objcMembers open class SwiftTextLable: UIView {
    
    /// 链接数据模型
    @objc open class TextLink: NSObject {
        open var text: String       // 链接文本
        open var rang: NSRange      // 在富文本中的位置
        open var rects: [CGRect]    // 在视图中的位置矩形（可能跨行）
        
        public init(text: String, rang: NSRange, rects: [CGRect]) {
            self.text = text
            self.rang = rang
            self.rects = rects
        }
    }
    
    // MARK: - 公开属性
    open weak var delegate: TextLableDelegate?
    
    // MARK: - 私有属性
    private var links = [TextLink]()        // 存储所有链接数据
    private let config: SwiftTextLableConfig // 配置对象
    
    /// 核心文本视图（用于计算链接位置）
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.isUserInteractionEnabled = false
        // 去除默认的内边距
        tv.textContainerInset = .zero
        tv.textContainer.lineFragmentPadding = 0
        tv.showsVerticalScrollIndicator = false
        tv.showsHorizontalScrollIndicator = false
        tv.backgroundColor = .clear
        return tv
    }()
    
    // MARK: - 手势
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTapGesture(_:))
        )
        gesture.numberOfTapsRequired = 1
        return gesture
    }()
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPressGesture(_:))
        )
        gesture.minimumPressDuration = 0.8 // 长按时间阈值
        return gesture
    }()

    // MARK: - 布局相关属性
    
    /// 视图尺寸（必须在设置富文本前设置）
    open var viewFrame: CGRect? {
        didSet {
            guard let frame = viewFrame else { return }
            self.frame = frame
            textView.frame = bounds
        }
    }
    
    /// 富文本内容（设置后会解析链接）
    open var attributedText: NSAttributedString? {
        didSet {
            guard let attr = attributedText else { return }
            
            // 重置之前的链接数据
            links.removeAll()
            textView.attributedText = attr
            
            // 遍历富文本查找链接
            let linkKey = NSAttributedString.Key(rawValue: SwiftRegex.textLinkAttributeKey)
            attr.enumerateAttribute(
                linkKey,
                in: NSRange(location: 0, length: attr.length),
                options: []
            ) { (value, range, _) in
                guard let linkText = value as? String else { return }
                
                // 获取链接在视图中的位置矩形
                textView.selectedRange = range
                guard let selectionRange = textView.selectedTextRange else { return }
                
                // 获取链接占据的所有矩形区域（可能跨行）
                let selectionRects = textView.selectionRects(for: selectionRange)
                var rects = [CGRect]()
                
                for selectionRect in selectionRects {
                    // 过滤无效矩形
                    guard !selectionRect.rect.isEmpty else { continue }
                    rects.append(selectionRect.rect)
                }
                
                // 存储链接数据
                links.append(TextLink(
                    text: linkText,
                    rang: range,
                    rects: rects
                ))
            }
        }
    }
    
    // MARK: - 初始化方法
    public init(config: SwiftTextLableConfig = SwiftTextLableConfig()) {
        self.config = config
        super.init(frame: .zero)
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) 不支持")
    }
    
    // MARK: - 界面设置
    private func setupUI() {
        addSubview(textView)
        addGestureRecognizer(tapGesture)
        addGestureRecognizer(longPressGesture)
    }
}

// MARK: - 手势处理
private extension SwiftTextLable {
    
    /// 处理长按手势
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        // 回调整个文本内容
        delegate?.textLable?(self, longPress: attributedText?.string ?? "")
    }
    
    /// 处理点击手势
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else { return }
        
        // 防止连续点击
        isUserInteractionEnabled = false
        defer {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isUserInteractionEnabled = true
                self.removeLinkHighlights()
            }
        }
        
        // 获取点击位置
        let point = gesture.location(in: self)
        
        // 查找点击的链接
        if let link = findLink(at: point) {
            highlightLink(link)
            delegate?.textLable?(self, didSelect: link.text)
        }
    }
    
    /// 在指定坐标查找链接
    private func findLink(at point: CGPoint) -> TextLink? {
        for link in links {
            // 检查点击位置是否在链接的任一矩形区域内
            if link.rects.contains(where: { $0.contains(point) }) {
                return link
            }
        }
        return nil
    }
    
    /// 高亮显示链接区域
    private func highlightLink(_ link: TextLink) {
        for rect in link.rects {
            let highlightView = UIView(frame: rect)
            highlightView.tag = linkBackgroundTag
            highlightView.backgroundColor = config.bgColor
            highlightView.layer.cornerRadius = config.bgRadius
            highlightView.layer.masksToBounds = true
            insertSubview(highlightView, belowSubview: textView)
        }
    }
    
    /// 移除所有链接高亮
    @objc private func removeLinkHighlights() {
        subviews.forEach {
            if $0.tag == linkBackgroundTag {
                $0.removeFromSuperview()
            }
        }
    }
}

