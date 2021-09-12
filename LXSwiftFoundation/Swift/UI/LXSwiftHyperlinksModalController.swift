//
//  LXSwiftHyperlinksModalController.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2020/7/14.

//  内容可以带超链接的弹窗

import UIKit

@objc(LXObjcHyperlinksModalController)
@objcMembers open class LXSwiftHyperlinksModalController: LXSwiftModalController {
    
    public typealias CallBack = ((String) -> (Void))
    open var callBack: LXSwiftHyperlinksModalController.CallBack?
    
    private var modaConfig = LXSwiftModalConfig()
    
    /// modaItems 集合
    private var itemViews = [LXSwiftItemView]()
    
    /// ModalItem事件集合
    private var modalItems = [LXSwiftItem]()
    
    lazy var titleLabel: UILabel = {
       let titleLabel = UILabel()
       titleLabel.textAlignment = .center
       titleLabel.textColor = modaConfig.titleColor
       titleLabel.font = modaConfig.titleFont
       return titleLabel
    }()
    
    lazy var scrollView: UIScrollView = {
       let scrollView = UIScrollView()
       scrollView.isScrollEnabled = modaConfig.isContentMidViewScrollEnabled
       scrollView.showsVerticalScrollIndicator = modaConfig.isshowsVerticalScrollIndicator
       return scrollView
    }()
    
    lazy var textLabel: LXSwiftTextLable = {
       var config = LXSwiftTextLableConfig()
       config.bgColor = self.modaConfig.selectBgColor
       let textLabel = LXSwiftTextLable(config: config)
       textLabel.delegate = self
       return textLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = modaConfig.lineColor
        return lineView
    }()
    
    open override func backgroundViewTap() {
        if modaConfig.isDismissBg { super.backgroundViewTap() }
    }
    
    ///事件监听 及回调
    @objc private func itemViewClick(_ itemView: LXSwiftItemView) {
        modalItems[itemView.tag].callBack?()
        lx.dismissViewController()
    }
}

extension LXSwiftHyperlinksModalController: LXTextLableDelegate {
    public func lxTextLable(_ textView: LXSwiftTextLable, didSelect text: String) { callBack?(text) }
}

extension LXSwiftHyperlinksModalController {

    open func getAttributedString(with text: String, textColor: UIColor = UIColor.lx.color(hex: "666666"), textFont: UIFont = UIFont.systemFont(ofSize: 14), regexTypes: [LXSwiftRegexType]) -> NSAttributedString? { LXSwiftRegex.regex(of: text, textColor: textColor, textFont: textFont, wordRegexTypes: regexTypes) }
    
    /// 设置UI信息 和超链接点击回调
    @objc open func setModal(_ modaConfig: LXSwiftModalConfig, modalItems: [LXSwiftItem], callBack: LXSwiftHyperlinksModalController.CallBack?) {
        self.modaConfig = modaConfig
        self.modalItems = modalItems
        self.callBack = callBack

        view.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(scrollView)
        scrollView.addSubview(textLabel)
        contentView.addSubview(lineView)
        
        for modalItem in modalItems {
            let itemView = LXSwiftItemView()
            itemView.lineView.backgroundColor = modaConfig.lineColor
            itemView.setTitle(modalItem.title, for:.normal)
            itemView.setTitleColor(modalItem.titleColor, for: .normal)
            itemView.titleLabel?.font = modalItem.titleFont
            contentView.addSubview(itemView)
            itemViews.append(itemView)
            itemView.addTarget(self,action: #selector(itemViewClick(_:)), for: UIControl.Event.touchUpInside)
        }
    }
    
    /// 显示UI图层
    @objc open func show(with title: String, content: NSAttributedString) {
        titleLabel.text = title
        contentView.layer.cornerRadius = self.modaConfig.contentViewRadius
        contentView.lx.width = modaConfig.contentViewW
        contentView.lx.x = (SCREEN_WIDTH_TO_WIDTH - modaConfig.contentViewW) * 0.5
       
        self.titleLabel.frame = CGRect(x: modaConfig.contentViewSubViewX,
                                  y: modaConfig.titleTop,
                                  width: contentView.frame.width - modaConfig.contentViewSubViewX * 2,
                                  height: getTitleH())
        let contentH = getContentH(content)
        scrollView.frame = CGRect(x: 0,
                                   y: titleLabel.frame.maxY + modaConfig.contentMidViewTop,
                                     width: contentView.frame.width,
                                     height: min(modaConfig.contentMidViewH, contentH))
        textLabel.viewFrame = CGRect(x: modaConfig.contentViewSubViewX,
                                       y: 0,
                                       width: contentView.frame.width - modaConfig.contentViewSubViewX * 2,
                                       height: contentH)
        textLabel.attributedText = content
        scrollView.contentSize = CGSize(width: 0, height: contentH)
        lineView.frame = CGRect(x: 0,
                                y: scrollView.frame.maxY + modaConfig.lineTop,
                                width: contentView.frame.width,
                                height: SCALE_IP6_WIDTH_TO_WIDTH(0.5))
      
        if itemViews.count > 0 {
            let colW = contentView.frame.width / CGFloat(itemViews.count)
            for (index, itemView) in itemViews.enumerated() {
                itemView.lineView.isHidden = (itemViews.count - 1 == index)
                itemView.tag = index
                itemView.frame = CGRect(x: CGFloat(index) * colW,
                                        y: lineView.frame.maxY,
                                        width: colW,
                                        height: modaConfig.itemH)
                itemView.setLineViewFrame()
            }
        }
        
        if itemViews.count > 0 {
            contentView.lx.height = itemViews.last!.frame.maxY
        } else {
            contentView.lx.height = lineView.frame.maxY
        }
        contentView.lx.y = (SCREEN_HEIGHT_TO_HEIGHT - contentView.lx.height) * 0.5 + modaConfig.contentViewOffSet
        UIApplication.lx.visibleViewController?.present(self, animated: true, completion: nil)
    }
    
   fileprivate func getTitleH() -> CGFloat {
        if let text = titleLabel.text {
            return text.lx.height(font: modaConfig.titleFont, width: contentView.frame.width - modaConfig.contentViewSubViewX * 2)
        } else { return 0 }
    }
    
    fileprivate func getContentH(_ attr: NSAttributedString) -> CGFloat { attr.lx.height(contentView.frame.width - self.modaConfig.contentViewSubViewX * 2) }
}

@objc(LXObjcModalConfig)
@objcMembers open class LXSwiftModalConfig: NSObject {

    public override init() { }
    
    /// 内容圆角
    open var contentViewRadius: CGFloat = SCALE_IP6_WIDTH_TO_WIDTH(10)
    open var contentViewW: CGFloat = SCALE_IP6_WIDTH_TO_WIDTH(288)
    //  距离中间位置的偏移量
    open var contentViewOffSet: CGFloat = 0
    open var contentViewSubViewX: CGFloat = SCALE_IP6_WIDTH_TO_WIDTH(20)

    /// 标题颜色和字体大小 距离顶部的距离
    open var titleTop: CGFloat = SCALE_IP6_WIDTH_TO_WIDTH(20)
    open var titleFont: UIFont = UIFont.lx.font(withMedium: 18)
    open var titleColor: UIColor = UIColor.black
    
    /// 内容颜色和字体大小 距离title的距离
    open var contentMidViewTop: CGFloat = SCALE_IP6_WIDTH_TO_WIDTH(13)
    open var contentMidViewH: CGFloat = SCALE_IP6_WIDTH_TO_WIDTH(200)
    open var isContentMidViewScrollEnabled: Bool = true
    open var isshowsVerticalScrollIndicator: Bool = true
    
    /// 线颜色 和 距离内容的距离
    open var lineTop: CGFloat =  SCALE_IP6_WIDTH_TO_WIDTH(13)
    open var lineColor: UIColor = UIColor.lx.color(hex: "EFEFEF")
    
    /// item 高度
    open var itemH: CGFloat = SCALE_IP6_WIDTH_TO_WIDTH(55)
    
    /// 点击背景是否关闭弹窗
    open var isDismissBg: Bool = true
    
    open var selectBgColor: UIColor = UIColor.black.withAlphaComponent(0.1)
}

@objc(LXObjcItem)
@objcMembers open class LXSwiftItem: NSObject {
    
    public typealias LXSwiftModalItemCallBack = (() -> Void)
    open var title: String
    open var titleColor: UIColor
    open var titleFont: UIFont
    open var callBack: LXSwiftItem.LXSwiftModalItemCallBack?
    
   public init(title: String, titleColor: UIColor = UIColor.black, titleFont: UIFont = UIFont.lx.font(withMedium: 16), callBack: LXSwiftItem.LXSwiftModalItemCallBack?) {
        self.title = title
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.callBack = callBack
    }
}

// MARK: - LXItemView
@objc(LXObjcItemView)
@objcMembers open class LXSwiftItemView: UIButton {
    //线的view
    open var lineView: UIView
    public override init(frame: CGRect) {
        lineView = UIView()
        super.init(frame: frame)
        addSubview(lineView)
    }
    
    ///布局线的尺寸
    open func setLineViewFrame() {
        lineView.frame = CGRect(x: frame.width - SCALE_IP6_WIDTH_TO_WIDTH(0.5),
                                y: 0,
                                width: SCALE_IP6_WIDTH_TO_WIDTH(0.5),
                                height: frame.height)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
