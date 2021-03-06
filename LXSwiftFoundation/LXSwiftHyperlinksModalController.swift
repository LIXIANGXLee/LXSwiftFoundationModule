//
//  LXSwiftHyperlinksModalController.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2020/7/14.

//  内容可以带超链接的弹窗

import UIKit

open class LXSwiftHyperlinksModalController: LXSwiftModalController {
    
    public typealias CallBack = ((String) -> (Void))
    public var callBack: LXSwiftHyperlinksModalController.CallBack?
    
    private var modaConfig: LXSwiftModalConfig
    public init(_ modaConfig: LXSwiftModalConfig, modalItems: LXSwiftItem...) {
        self.modaConfig = modaConfig
        self.modalItems = modalItems
        super.init(nibName: nil, bundle: nil)
        
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
            itemView.addTarget(self,action: #selector(itemViewClick(_:)),
                               for: UIControl.Event.touchUpInside)
        }
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    /// modaItems 集合
    var itemViews = [LXSwiftItemView]()
    
    /// ModalItem事件集合
    var modalItems = [LXSwiftItem]()

    public override func backgroundViewTap() {
        if modaConfig.isDismissBg {
            super.backgroundViewTap()
        }
    }
    
    ///事件监听 及回调
    @objc private func itemViewClick(_ itemView: LXSwiftItemView) {
        modalItems[itemView.tag].callBack?()
        lx.dismissViewController()
    }

}

extension LXSwiftHyperlinksModalController: LXTextLableDelegate {
    public func lxTextLable(_ textView: LXSwiftTextLable, didSelect text: String) {
        self.callBack?(text)
    }
}

extension LXSwiftHyperlinksModalController {

    /// 设置回调
    public func setHandle(_ callBack: LXSwiftHyperlinksModalController.CallBack?) {
        self.callBack = callBack
    }
    
    public func getAttributedString(with text: String,
                                    textColor: UIColor = UIColor.lx.color(hex: "666666"),
                                    textFont: UIFont = UIFont.systemFont(ofSize: 14),
                                    regexTypes: [LXSwiftRegexType])
    -> NSAttributedString? {
        return LXSwiftRegex.regex(of: text, textColor: textColor,
                                            textFont: textFont,
                                            wordRegexTypes: regexTypes)
    }
    
    public func show(with title: String, content: NSAttributedString) {
        titleLabel.text = title
        contentView.layer.cornerRadius = self.modaConfig.contentViewRadius
        contentView.lx.width = modaConfig.contentViewW
        contentView.lx.x = (UIScreen.main.bounds.width - modaConfig.contentViewW) * 0.5
       
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
                                height: scale_ip6_width(0.5))
      
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
        contentView.lx.y = (UIScreen.main.bounds.height -  contentView.lx.height) * 0.5 + modaConfig.contentViewOffSet
        
        UIApplication.lx.visibleViewController?.present(self, animated: true, completion: nil)
    }
    
    func getTitleH() -> CGFloat {
        if let text = titleLabel.text {
            return text.lx.height(font: modaConfig.titleFont,
                                  width: contentView.frame.width - modaConfig.contentViewSubViewX * 2)
        }else{
            return 0
        }
    }
    
    func getContentH(_ attr: NSAttributedString) -> CGFloat {
        return attr.lx.height(width: contentView.frame.width - self.modaConfig.contentViewSubViewX * 2)
    }

}

public class LXSwiftModalConfig {

    public init(){ }
    
    /// 内容圆角
    public var contentViewRadius: CGFloat = scale_ip6_width(10)
    public var contentViewW: CGFloat = scale_ip6_width(288)
    //  距离中间位置的偏移量
    public var contentViewOffSet: CGFloat = 0
    public var contentViewSubViewX: CGFloat = scale_ip6_width(20)

    /// 标题颜色和字体大小 距离顶部的距离
    public var titleTop: CGFloat = scale_ip6_width(20)
    public var titleFont: UIFont = UIFont.lx.fontWithMedium(18)
    public var titleColor: UIColor = UIColor.black
    
    /// 内容颜色和字体大小 距离title的距离
    public var contentMidViewTop: CGFloat = scale_ip6_width(13)
    public var contentMidViewH: CGFloat = scale_ip6_width(200)
    public var isContentMidViewScrollEnabled: Bool = true
    public var isshowsVerticalScrollIndicator: Bool = true
    
    /// 线颜色 和 距离内容的距离
    public var lineTop: CGFloat =  scale_ip6_width(13)
    public var lineColor: UIColor = UIColor.lx.color(hex: "EFEFEF")
    
    /// item 高度
    public var itemH: CGFloat = scale_ip6_width(55)
    
    /// 点击背景是否关闭弹窗
    public var isDismissBg: Bool = true
    
    public var selectBgColor: UIColor = UIColor.black.withAlphaComponent(0.1)
}

public struct LXSwiftItem {
    
   public typealias LXSwiftModalItemCallBack = (() -> Void)
   public var title: String
   public var titleColor: UIColor
   public var titleFont: UIFont
   public var callBack: LXSwiftItem.LXSwiftModalItemCallBack?
    
   public init(title: String, titleColor: UIColor = UIColor.black,
                titleFont: UIFont = UIFont.lx.fontWithMedium(16),
                callBack: LXSwiftItem.LXSwiftModalItemCallBack?) {
        self.title = title
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.callBack = callBack
    }
}

// MARK: - LXItemView
public class LXSwiftItemView: UIButton {
    //线的view
    public var lineView: UIView!
    public override init(frame: CGRect) {
        super.init(frame: frame)
        lineView = UIView()
        addSubview(lineView)
    }
    
    ///布局线的尺寸
    public func setLineViewFrame() {
        lineView.frame = CGRect(x: frame.width - scale_ip6_width(0.5),
                                y: 0,
                                width: scale_ip6_width(0.5),
                                height: frame.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
