//
//  SwiftTextLable.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/5/1.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

// MARK: - 文本标签主类
@objc(LXObjcTextLable)
@objcMembers open class SwiftTextLable: UIView {
    
    private let _tag = -1
    
    /// 链接数据模型
    @objcMembers open class TextLink: NSObject {
        open var text: String       // 链接文本
        open var rang: NSRange      // 在富文本中的位置
        open var rects: [CGRect]    // 在视图中的位置矩形（可能跨行）
        
        public init(text: String, rang: NSRange, rects: [CGRect]) {
            self.text = text
            self.rang = rang
            self.rects = rects
        }
    }
    
    /// 链接背景色
    open var linkBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.1)
    
    /// 链接背景圆角半径
    open var linkBackgroundRadius: CGFloat = SCALE_IP6_WIDTH_TO_WIDTH(6)
    
    /// 点击链接时的回调
    open var tapHandler: ((String) -> Void)?
    
    /// 长按整个文本的回调
    open var longPressHandler: ((String) -> Void)?

    // MARK: - 私有属性
    private var links = [TextLink]()        // 存储所有链接数据
    
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
            action: #selector(tapGesture(_:))
        )
        gesture.numberOfTapsRequired = 1
        return gesture
    }()
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(longPressGesture(_:))
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
            assert(viewFrame != nil, "viewFrame must not be empty")

            guard let attr = attributedText else { return }
            
            // 重置之前的链接数据
            links.removeAll()
            textView.attributedText = attr
            
            // 遍历富文本查找链接
            let linkKey = NSAttributedString.Key(rawValue: SwiftRegexType.textLinkAttributeKey)
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
                links.append(TextLink(text: linkText, rang: range, rects: rects))
            }
        }
    }
    
    
    // MARK: - 初始化方法
    public init() {
  
        super.init(frame: .zero)
             
        configureBaseSettings()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) 不支持")
    }
    
    // MARK: - 界面设置
    private func configureBaseSettings() {
        // 跨版本背景色适配
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
        } else {
            backgroundColor = .white
        }

        addSubview(textView)
        addGestureRecognizer(tapGesture)
        addGestureRecognizer(longPressGesture)
    }
}

// MARK: - 手势处理
private extension SwiftTextLable {
    
    /// 处理长按手势
    @objc func longPressGesture(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        // 回调整个文本内容
        longPressHandler?(attributedText?.string ?? "")
    }
    
    /// 处理点击手势
    @objc func tapGesture(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else { return }
        
        // 防止连续点击
        isUserInteractionEnabled = false
        defer {
            DispatchQueue.lx.delay(1) { [weak self] in
                self?.isUserInteractionEnabled = true
                self?.removeLinkHighlights()
            }
        }
        
        // 获取点击位置
        let point = gesture.location(in: self)
        
        // 查找点击的链接
        if let link = findLink(at: point) {
            highlightLink(link)
            tapHandler?(link.text)
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
            highlightView.tag = _tag
            highlightView.backgroundColor = linkBackgroundColor
            highlightView.layer.cornerRadius = linkBackgroundRadius
            highlightView.layer.masksToBounds = true
            insertSubview(highlightView, belowSubview: textView)
        }
    }
    
    /// 移除所有链接高亮
    @objc private func removeLinkHighlights() {
        subviews.forEach {
            if $0.tag == _tag {
                $0.removeFromSuperview()
            }
        }
    }
}

