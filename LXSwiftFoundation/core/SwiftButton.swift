//
//  SwiftButton.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

/* 使用示例：
let button = SwiftButton()
button.setLayoutCalculators(
    titleBlock: { contentRect in
        return CGRect(x: 0, y: contentRect.height*0.7,
                     width: contentRect.width, height: contentRect.height*0.3)
    },
    imageBlock: { contentRect in
        return CGRect(x: 0, y: 0,
                     width: contentRect.width, height: contentRect.height*0.7)
    }
)
*/

/// 自定义按钮，支持通过闭包动态计算图片和标题的布局位置
open class SwiftButton: UIButton {
    
    // MARK: - 公开属性
    
    /// 通用数据容器（可用于传递自定义数据）
    open var userInfo: Any?
    
    /// 内容区域布局回调类型
    public typealias ContentRectLayoutClosure = (_ contentRect: CGRect) -> CGRect
    
    /// 标题区域计算闭包（优先级高于系统默认布局）
    open var titleLayoutClosure: ContentRectLayoutClosure?
    
    /// 图片区域计算闭包（优先级高于系统默认布局）
    open var imageLayoutClosure: ContentRectLayoutClosure?
    
    // MARK: - 初始化方法
    
    /// 设计初始化方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    /// 不支持Storyboard初始化（增强代码安全性）
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 布局配置
    
    /// 设置标题和图片布局计算闭包
    /// - Parameters:
    ///   - titleClosure: 标题区域计算闭包（传入完整内容区域，返回标题实际区域）
    ///   - imageClosure: 图片区域计算闭包（传入完整内容区域，返回图片实际区域）
    open func setLayoutCalculators(
        titleClosure: ContentRectLayoutClosure?,
        imageClosure: ContentRectLayoutClosure?) {
        titleLayoutClosure = titleClosure
        imageLayoutClosure = imageClosure
    }
    
    // MARK: - 布局计算重写
    
    /// 图片区域计算（优先使用闭包，否则调用系统默认实现）
    open override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return imageLayoutClosure?(contentRect) ?? super.imageRect(forContentRect: contentRect)
    }
    
    /// 标题区域计算（优先使用闭包，否则调用系统默认实现）
    open override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return titleLayoutClosure?(contentRect) ?? super.titleRect(forContentRect: contentRect)
    }
}

// MARK: - 配置方法
private extension SwiftButton {
    /// 通用初始化配置
    func commonInit() {
        // 图片视图配置
        imageView?.contentMode = .scaleAspectFit
        imageView?.clipsToBounds = true
        
        // 标题标签配置
        titleLabel?.textAlignment = .center
        titleLabel?.numberOfLines = 0
        
        // 按钮基础配置
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center
        adjustsImageWhenHighlighted = false
        adjustsImageWhenDisabled = false
    }
}
