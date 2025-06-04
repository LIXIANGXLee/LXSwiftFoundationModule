//
//  SwiftHyperlinksModalController.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2020/7/14.

///  内容可以带超链接的弹窗

import UIKit

/// 模态视图控制器，支持超链接文本和底部操作按钮
/// - Note: 继承自 SwiftModalController，提供标题、可滚动超链接文本和底部按钮的布局
@objc(LXObjcHyperlinksController)
@objcMembers open class SwiftHyperlinksController: SwiftModalController {

    // MARK: - 公开属性
    
    /// 超链接点击回调
    open var tapHandler: ((String) -> Void)?
    
    // MARK: - 私有属性
    
    /// 模态视图配置
    private var config = SwiftHyperlinksConfig()
    
    /// 底部按钮视图集合
    private var itemViews = [SwiftItemView]()
    
    /// 是否首次展示（暂未使用）
    private var isFirst: Bool = true
    
    // MARK: - UI组件
    
    /// 标题标签
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = config.titleColor
        label.font = config.titleFont
        label.numberOfLines = 0 // 允许多行显示
        return label
    }()
    
    /// 内容滚动视图
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = config.isContentMidViewScrollEnabled
        view.showsVerticalScrollIndicator = config.isshowsVerticalScrollIndicator
        return view
    }()
    
    /// 支持超链接的文本标签
    private lazy var textLabel: SwiftTextLable = {
        let label = SwiftTextLable()
        label.backgroundColor = UIColor.white
        label.linkBackgroundColor = config.selectBgColor
    
        // 弱引用避免循环引用
        label.tapHandler = { [weak self] text in
            self?.tapHandler?(text)
        }
        return label
    }()
    
    /// 分隔线视图
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = config.lineColor
        return view
    }()
    
    // MARK: - 生命周期方法
    
    /// 处理背景点击事件
    open override func backgroundViewTap() {
        super.backgroundViewTap()

        // 根据配置决定是否允许点击背景关闭
        if config.isDismissBackground { dismiss() }
    }
    
    // MARK: - 事件处理
    
    /// 底部按钮点击事件
    @objc private func itemViewClick(_ itemView: SwiftItemView) {
        // 执行按钮对应的回调
        itemView.item?.handdler?()
        // 关闭模态视图
        lx.dismissViewController()
    }
}

// MARK: - 功能扩展
extension SwiftHyperlinksController {
    
    // MARK: 文本处理工具
    
    /// 生成富文本字符串（带超链接）
    /// - Parameters:
    ///   - text: 原始文本
    ///   - textColor: 默认文本颜色
    ///   - textFont: 默认文本字体
    ///   - regexTypes: 正则匹配类型数组
    /// - Returns: 格式化后的富文本
    public func getAttributedString(
        _ text: String,
        textColor: UIColor = UIColor.lx.color(hex: "666666"),
        textFont: UIFont = UIFont.systemFont(ofSize: SCALE_IP6_WIDTH_TO_WIDTH(14)),
        regexTypes: [SwiftRegexType]
    ) -> NSAttributedString? {
        return text.lx.createAttributedString(
            textColor: textColor,
            textFont: textFont,
            regexTypes: regexTypes
        )
    }
    
    // MARK: 显示方法
    
    /// 显示模态视图
    /// - Parameters:
    ///   - title: 标题文本
    ///   - content: 富文本内容
    ///   - config: 模态视图配置
    ///   - items: 底部按钮配置数组
    ///   - vc: 呈现视图控制器（默认使用当前控制器）
    @objc open func show(
        with title: String,
        content: NSAttributedString,
        config: SwiftHyperlinksConfig,
        items: [SwiftItem],
        vc: UIViewController? = nil
    ) {
        // 构建UI层次结构
        view.addSubview(contentView)
        if !title.isEmpty {
            contentView.addSubview(titleLabel)
        }
        contentView.addSubview(scrollView)
        scrollView.addSubview(textLabel)
        contentView.addSubview(lineView)
        
        // 清理旧按钮
        itemViews.forEach { $0.removeFromSuperview() }
        itemViews.removeAll()
        
        // 创建底部按钮
        for item in items {
            let itemView = SwiftItemView()
            itemView.item = item
            contentView.addSubview(itemView)
            itemViews.append(itemView)
            itemView.lineView.backgroundColor = config.lineColor
            itemView.addTarget(self, action: #selector(itemViewClick(_:)), for: .touchUpInside)
        }
        
        // 配置标题和内容
        titleLabel.text = title
        // 配置内容视图
        contentView.layer.cornerRadius = config.contentViewRadius
        contentView.lx.width = config.contentViewWidth
        contentView.lx.x = (SCREEN_WIDTH_TO_WIDTH - config.contentViewWidth) * 0.5
        
        if !title.isEmpty {
            // 计算标题高度并布局
            let titleHeight = titleLabel.text?.lx.height(font: config.titleFont, width: width) ?? 0
            titleLabel.frame = CGRect(
                x: config.contentViewSubViewX,
                y: config.titleTop,
                width: width,
                height: titleHeight
            )
        }

        // 计算内容高度并布局滚动视图
        let contentHeight = contentHeight(for: content)
        let contentY = title.isEmpty ? config.titleTop : titleLabel.frame.maxY + config.contentMidViewTop
        let scrollHeight = min(config.contentMidViewHeight, contentHeight)
        scrollView.frame = CGRect(
            x: 0,
            y: contentY,
            width: contentView.frame.width,
            height: scrollHeight
        )
        
        // 配置文本标签
        textLabel.viewFrame = CGRect(
            x: config.contentViewSubViewX,
            y: 0,
            width: width,
            height: contentHeight
        )
        textLabel.attributedText = content
        scrollView.contentSize = CGSize(width: width, height: contentHeight)
        
        // 布局分隔线
        lineView.frame = CGRect(
            x: 0,
            y: scrollView.frame.maxY + config.lineTop,
            width: contentView.frame.width,
            height: SCALE_IP6_WIDTH_TO_WIDTH(0.5)
        )
        
        // 布局底部按钮
        if !itemViews.isEmpty {
            let buttonWidth = contentView.frame.width / CGFloat(itemViews.count)
            for (index, itemView) in itemViews.enumerated() {
                // 最后一个按钮隐藏右侧分隔线
                itemView.lineView.isHidden = (index == itemViews.count - 1)
                itemView.frame = CGRect(
                    x: CGFloat(index) * buttonWidth,
                    y: lineView.frame.maxY,
                    width: buttonWidth,
                    height: config.itemHeight
                )
                itemView.setLineViewFrame()
            }
        }
        
        // 计算内容视图总高度
        let contentViewHeight = itemViews.last?.frame.maxY ?? lineView.frame.maxY
        contentView.lx.height = contentViewHeight
        
        // 垂直居中显示（考虑偏移量）
        contentView.lx.y = (SCREEN_HEIGHT_TO_HEIGHT - contentViewHeight) * 0.5 + config.contentViewOffSet
        
        // 呈现模态视图
        let currentVC = vc ?? UIApplication.lx.currentViewController
        currentVC?.present(self, animated: true)
    }

}

// MARK: - 布局辅助
extension SwiftHyperlinksController {
    /// 内容区域可用宽度
    private var width: CGFloat {
        contentView.frame.width - config.contentViewSubViewX * 2
    }
    
    /// 计算富文本内容高度
    private func contentHeight(for attributedText: NSAttributedString?) -> CGFloat {
        guard let text = attributedText else { return 0 }
        return text.lx.height(width)
    }
}

// MARK: - 模态视图配置类
@objc(LXObjcModalConfig)
@objcMembers open class SwiftHyperlinksConfig: NSObject {
    public override init() { }
    
    // MARK: 内容视图配置
    
    /// 内容视图圆角半径（默认：10pt）
    open var contentViewRadius: CGFloat = SCALE_IP6_WIDTH_TO_WIDTH(10)
    
    /// 内容视图宽度（默认：288pt）
    open var contentViewWidth: CGFloat = SCALE_IP6_WIDTH_TO_WIDTH(288)
    
    /// 内容视图垂直偏移量（默认：0）
    open var contentViewOffSet: CGFloat = 0
    
    /// 内容子视图左右边距（默认：20pt）
    open var contentViewSubViewX: CGFloat = SCALE_IP6_WIDTH_TO_WIDTH(20)
    
    // MARK: 标题配置
    
    /// 标题距离顶部距离（默认：20pt）
    open var titleTop: CGFloat = SCALE_IP6_WIDTH_TO_WIDTH(20)
    
    /// 标题字体（默认：18pt 中黑体）
    open var titleFont: UIFont = UIFont.lx.font(withMedium: 18)
    
    /// 标题颜色（默认：黑色）
    open var titleColor: UIColor = .black
    
    // MARK: 内容区域配置
    
    /// 内容距离标题的间距（默认：13pt）
    open var contentMidViewTop: CGFloat = SCALE_IP6_WIDTH_TO_WIDTH(13)
    
    /// 内容区域最大高度（默认：200pt）
    open var contentMidViewHeight: CGFloat = SCALE_IP6_WIDTH_TO_WIDTH(200)
    
    /// 是否允许内容滚动（默认：true）
    open var isContentMidViewScrollEnabled: Bool = true
    
    /// 是否显示垂直滚动条（默认：true）
    open var isshowsVerticalScrollIndicator: Bool = true
    
    // MARK: 分隔线配置
    
    /// 分隔线距离内容区域的间距（默认：13pt）
    open var lineTop: CGFloat = SCALE_IP6_WIDTH_TO_WIDTH(13)
    
    /// 分隔线颜色（默认：#EFEFEF）
    open var lineColor: UIColor = UIColor.lx.color(hex: "EFEFEF")
    
    // MARK: 底部按钮配置
    
    /// 按钮高度（默认：55pt）
    open var itemHeight: CGFloat = SCALE_IP6_WIDTH_TO_WIDTH(55)
    
    // MARK: 交互配置
    
    /// 点击背景是否关闭弹窗（默认：true）
    open var isDismissBackground: Bool = true
    
    /// 超链接选中背景色（默认：黑色10%透明度）
    open var selectBgColor: UIColor = UIColor.black.withAlphaComponent(0.1)
}

// MARK: - 底部按钮数据模型
@objc(LXObjcItem)
@objcMembers open class SwiftItem: NSObject {
    /// 按钮标题
    open var title: String
    
    /// 标题颜色（默认：黑色）
    open var titleColor: UIColor
    
    /// 标题字体（默认：16pt 中黑体）
    open var titleFont: UIFont
    
    /// 点击回调
    open var handdler: (() -> Void)?
    
    /// 初始化底部按钮配置
    public init(
        title: String,
        titleColor: UIColor = .black,
        titleFont: UIFont = UIFont.lx.font(withMedium: SCALE_IP6_WIDTH_TO_WIDTH(16)),
        handdler: (() -> Void)? = nil
    ) {
        self.title = title
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.handdler = handdler
    }
}

// MARK: - 底部按钮视图
fileprivate class SwiftItemView: UIButton {
    /// 右侧分隔线
    var lineView = UIView()
    
    /// 关联的数据模型
    var item: SwiftItem? {
        didSet {
            guard let item = item else { return }
            setTitle(item.title, for: .normal)
            setTitleColor(item.titleColor, for: .normal)
            titleLabel?.font = item.titleFont
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lineView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置分隔线布局
    func setLineViewFrame() {
        lineView.frame = CGRect(
            x: frame.width - SCALE_IP6_WIDTH_TO_WIDTH(0.5),
            y: 0,
            width: SCALE_IP6_WIDTH_TO_WIDTH(0.5),
            height: frame.height
        )
    }
}
