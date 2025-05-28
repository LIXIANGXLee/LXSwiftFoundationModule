//
//  SwiftHyperlinksModalController.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2020/7/14.

///  内容可以带超链接的弹窗

import UIKit

/// 模态视图控制器，支持超链接文本和底部操作按钮
/// - Note: 继承自 SwiftModalController，提供标题、可滚动超链接文本和底部按钮的布局
@objc(LXObjcHyperlinksModalController)
@objcMembers open class SwiftHyperlinksModalController: SwiftModalController {
    
    // MARK: - 类型定义
    /// 超链接点击回调类型
    public typealias CallBack = ((String) -> (Void))
    
    // MARK: - 公开属性
    /// 超链接点击回调
    open var callBack: SwiftHyperlinksModalController.CallBack?
    
    // MARK: - 私有属性
    /// 模态视图配置
    private var modaConfig = SwiftModalConfig()
    /// 底部按钮视图集合
    private var itemViews = [SwiftItemView]()
    /// 底部按钮数据模型集合
    private var modalItems = [SwiftItem]()
    
    // MARK: - UI组件
    /// 标题标签
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = modaConfig.titleColor
        label.font = modaConfig.titleFont
        return label
    }()
    
    /// 内容滚动视图
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = modaConfig.isContentMidViewScrollEnabled
        view.showsVerticalScrollIndicator = modaConfig.isshowsVerticalScrollIndicator
        return view
    }()
    
    /// 超链接文本标签
    private lazy var textLabel: SwiftTextLable = {
        var config = SwiftTextLableConfig()
        config.bgColor = self.modaConfig.selectBgColor
        let label = SwiftTextLable(config: config)
        label.delegate = self
        return label
    }()
    
    /// 分隔线视图
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = modaConfig.lineColor
        return view
    }()
    
    // MARK: - 生命周期方法
    open override func backgroundViewTap() {
        // 根据配置决定是否允许点击背景关闭
        if modaConfig.isDismissBg {
            super.backgroundViewTap()
        }
    }
    
    // MARK: - 事件处理
    /// 底部按钮点击事件
    @objc private func itemViewClick(_ itemView: SwiftItemView) {
        // 执行按钮对应的回调
        modalItems[itemView.tag].callBack?()
        // 关闭模态视图
        lx.dismissViewController()
    }
}

// MARK: - 超链接文本代理实现
extension SwiftHyperlinksModalController: TextLableDelegate {
    /// 处理超链接点击事件
    public func textLable(_ textView: SwiftTextLable, didSelect text: String) {
        callBack?(text)
    }
}

// MARK: - 功能扩展
extension SwiftHyperlinksModalController {
    
    // MARK: 文本处理工具
    /// 生成富文本字符串（带超链接）
    /// - Parameters:
    ///   - text: 原始文本
    ///   - textColor: 默认文本颜色
    ///   - textFont: 默认文本字体
    ///   - regexTypes: 正则匹配类型数组
    /// - Returns: 格式化后的富文本
    public func getAttributedString(with text: String,
                                    textColor: UIColor = UIColor.lx.color(hex: "666666"),
                                    textFont: UIFont = UIFont.systemFont(ofSize: 14),
                                    regexTypes: [SwiftRegexType]) -> NSAttributedString? {
        
        SwiftRegex.createAttributedString(from: text,
                                          textColor: textColor,
                                          textFont: textFont,
                                          regexTypes: regexTypes)
    }
    
    // MARK: 配置方法
    /// 配置模态视图
    /// - Parameters:
    ///   - modaConfig: 视图配置
    ///   - modalItems: 底部按钮数据
    ///   - callBack: 超链接回调
    @objc open func setModal(_ modaConfig: SwiftModalConfig, modalItems: [SwiftItem], callBack: SwiftHyperlinksModalController.CallBack?) {
        // 保存配置和数据
        self.modaConfig = modaConfig
        self.modalItems = modalItems
        self.callBack = callBack
        
        // 构建UI层次结构
        view.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(scrollView)
        scrollView.addSubview(textLabel)
        contentView.addSubview(lineView)
        
        // 创建底部按钮
        for modalItem in modalItems {
            let itemView = SwiftItemView()
            itemView.lineView.backgroundColor = modaConfig.lineColor
            itemView.setTitle(modalItem.title, for: .normal)
            itemView.setTitleColor(modalItem.titleColor, for: .normal)
            itemView.titleLabel?.font = modalItem.titleFont
            contentView.addSubview(itemView)
            itemViews.append(itemView)
            itemView.addTarget(self, action: #selector(itemViewClick(_:)), for: .touchUpInside)
        }
    }
    
    // MARK: 显示方法
    /// 显示模态视图
    /// - Parameters:
    ///   - title: 标题文本
    ///   - content: 富文本内容
    ///   - vc: 呈现视图控制器（默认使用当前控制器）
    @objc open func show(with title: String, content: NSAttributedString, vc: UIViewController? = nil) {
        // 配置标题
        titleLabel.text = title
        contentView.layer.cornerRadius = self.modaConfig.contentViewRadius
        contentView.lx.width = modaConfig.contentViewW
        contentView.lx.x = (SCREEN_WIDTH_TO_WIDTH - modaConfig.contentViewW) * 0.5
        
        // 计算标题高度并设置frame
        self.titleLabel.frame = CGRect(
            x: modaConfig.contentViewSubViewX,
            y: modaConfig.titleTop,
            width: contentView.frame.width - modaConfig.contentViewSubViewX * 2,
            height: getTitleH()
        )
        
        // 计算内容高度并设置滚动区域
        let contentH = getContentH(content)
        scrollView.frame = CGRect(
            x: 0,
            y: titleLabel.frame.maxY + modaConfig.contentMidViewTop,
            width: contentView.frame.width,
            height: min(modaConfig.contentMidViewH, contentH)
        )
        
        // 配置超链接文本标签
        textLabel.viewFrame = CGRect(
            x: modaConfig.contentViewSubViewX,
            y: 0,
            width: contentView.frame.width - modaConfig.contentViewSubViewX * 2,
            height: contentH
        )
        textLabel.attributedText = content
        scrollView.contentSize = CGSize(width: 0, height: contentH)
        
        // 设置分隔线
        lineView.frame = CGRect(
            x: 0,
            y: scrollView.frame.maxY + modaConfig.lineTop,
            width: contentView.frame.width,
            height: SCALE_IP6_WIDTH_TO_WIDTH(0.5)
        )
        
        // 布局底部按钮
        if itemViews.count > 0 {
            let colW = contentView.frame.width / CGFloat(itemViews.count)
            for (index, itemView) in itemViews.enumerated() {
                // 最后一个按钮隐藏右侧分隔线
                itemView.lineView.isHidden = (itemViews.count - 1 == index)
                itemView.tag = index
                itemView.frame = CGRect(
                    x: CGFloat(index) * colW,
                    y: lineView.frame.maxY,
                    width: colW,
                    height: modaConfig.itemH
                )
                itemView.setLineViewFrame()
            }
        }
        
        // 计算内容视图总高度
        if itemViews.count > 0 {
            contentView.lx.height = itemViews.last!.frame.maxY
        } else {
            contentView.lx.height = lineView.frame.maxY
        }
        
        // 垂直居中显示，考虑偏移量
        contentView.lx.y = (SCREEN_HEIGHT_TO_HEIGHT - contentView.lx.height) * 0.5 + modaConfig.contentViewOffSet
        
        // 呈现模态视图
        let currentVC = vc ?? UIApplication.lx.currentViewController
        currentVC?.present(self, animated: true, completion: nil)
    }
    
    // MARK: 辅助方法
    /// 计算标题高度
    fileprivate func getTitleH() -> CGFloat {
        guard let text = titleLabel.text else { return 0 }
        return text.lx.height(font: modaConfig.titleFont, width: contentView.frame.width - modaConfig.contentViewSubViewX * 2)
    }
    
    /// 计算内容高度
    fileprivate func getContentH(_ attr: NSAttributedString) -> CGFloat {
        attr.lx.height(contentView.frame.width - self.modaConfig.contentViewSubViewX * 2)
    }
}

// MARK: - 模态视图配置类
@objc(LXObjcModalConfig)
@objcMembers open class SwiftModalConfig: NSObject {
    public override init() { }
    
    // MARK: 内容视图配置
    /// 内容视图圆角半径
    open var contentViewRadius: CGFloat = SCALE_IP6_WIDTH_TO_WIDTH(10)
    /// 内容视图宽度
    open var contentViewW: CGFloat = SCALE_IP6_WIDTH_TO_WIDTH(288)
    /// 内容视图垂直偏移量
    open var contentViewOffSet: CGFloat = 0
    /// 内容子视图左右边距
    open var contentViewSubViewX: CGFloat = SCALE_IP6_WIDTH_TO_WIDTH(20)
    
    // MARK: 标题配置
    /// 标题距离顶部距离
    open var titleTop: CGFloat = SCALE_IP6_WIDTH_TO_WIDTH(20)
    /// 标题字体
    open var titleFont: UIFont = UIFont.lx.font(withMedium: 18)
    /// 标题颜色
    open var titleColor: UIColor = UIColor.black
    
    // MARK: 内容区域配置
    /// 内容距离标题的间距
    open var contentMidViewTop: CGFloat = SCALE_IP6_WIDTH_TO_WIDTH(13)
    /// 内容区域最大高度
    open var contentMidViewH: CGFloat = SCALE_IP6_WIDTH_TO_WIDTH(200)
    /// 是否允许内容滚动
    open var isContentMidViewScrollEnabled: Bool = true
    /// 是否显示垂直滚动条
    open var isshowsVerticalScrollIndicator: Bool = true
    
    // MARK: 分隔线配置
    /// 分隔线距离内容区域的间距
    open var lineTop: CGFloat =  SCALE_IP6_WIDTH_TO_WIDTH(13)
    /// 分隔线颜色
    open var lineColor: UIColor = UIColor.lx.color(hex: "EFEFEF")
    
    // MARK: 底部按钮配置
    /// 按钮高度
    open var itemH: CGFloat = SCALE_IP6_WIDTH_TO_WIDTH(55)
    
    // MARK: 交互配置
    /// 点击背景是否关闭弹窗
    open var isDismissBg: Bool = true
    /// 选中背景色
    open var selectBgColor: UIColor = UIColor.black.withAlphaComponent(0.1)
}

// MARK: - 底部按钮数据模型
@objc(LXObjcItem)
@objcMembers open class SwiftItem: NSObject {
    /// 按钮回调闭包类型
    public typealias LXSwiftModalItemCallBack = (() -> Void)
    
    /// 按钮标题
    open var title: String
    /// 标题颜色
    open var titleColor: UIColor
    /// 标题字体
    open var titleFont: UIFont
    /// 点击回调
    open var callBack: SwiftItem.LXSwiftModalItemCallBack?
    
    /// 初始化按钮数据模型
    public init(title: String,
                titleColor: UIColor = UIColor.black,
                titleFont: UIFont = UIFont.lx.font(withMedium: 16),
                callBack: SwiftItem.LXSwiftModalItemCallBack?) {
        self.title = title
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.callBack = callBack
    }
}

// MARK: - 底部按钮视图
@objc(LXObjcItemView)
@objcMembers open class SwiftItemView: UIButton {
    /// 右侧分隔线
    open var lineView: UIView
    
    public override init(frame: CGRect) {
        lineView = UIView()
        super.init(frame: frame)
        addSubview(lineView)
    }
    
    /// 设置分隔线布局
    open func setLineViewFrame() {
        lineView.frame = CGRect(
            x: frame.width - SCALE_IP6_WIDTH_TO_WIDTH(0.5),
            y: 0,
            width: SCALE_IP6_WIDTH_TO_WIDTH(0.5),
            height: frame.height
        )
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
