//
//  SwiftLabel.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// 自定义 UILabel 子类，支持设置文字内容的内边距。
/// 可在 Interface Builder 中直接配置各方向内边距，或通过代码设置。
open class SwiftLabel: UILabel {
    
    // MARK: - 自定义属性
    
    /// 通用参数容器，可用于传递自定义数据或配置。
    public var swiftModel: Any?
    
    // MARK: - 内边距属性
    
    /// 文字内容的内边距，默认为 .zero。
    private var padding = UIEdgeInsets.zero
    
    /// 上内边距（支持 Interface Builder 实时渲染）
    @IBInspectable open var paddingTop: CGFloat {
        get { padding.top }
        set { padding.top = newValue }
    }
    
    /// 左内边距（支持 Interface Builder 实时渲染）
    @IBInspectable open var paddingLeft: CGFloat {
        get { padding.left }
        set { padding.left = newValue }
    }
    
    /// 下内边距（支持 Interface Builder 实时渲染）
    @IBInspectable open var paddingBottom: CGFloat {
        get { padding.bottom }
        set { padding.bottom = newValue }
    }
    
    /// 右内边距（支持 Interface Builder 实时渲染）
    @IBInspectable open var paddingRight: CGFloat {
        get { padding.right }
        set { padding.right = newValue }
    }
    
    // MARK: - 文本绘制
    
    /// 重写文本绘制区域，应用自定义内边距
    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    // MARK: - 布局计算
    
    /// 计算文本的理想显示区域，考虑内边距设置
    /// - 参数 bounds: Label 的实际边界区域
    /// - 参数 numberOfLines: 最大行数限制
    /// - 返回: 计算后文本的实际需求区域（包含内边距）
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        // 1. 计算考虑内边距后的可用绘制区域
        let insetBounds = bounds.inset(by: padding)
        
        // 2. 获取系统计算的文本区域（不考虑内边距）
        let textRect = super.textRect(forBounds: insetBounds, limitedToNumberOfLines: numberOfLines)
        
        // 3. 将内边距反向应用到计算结果，得到最终文本显示区域
        let invertedPadding = UIEdgeInsets(
            top: -padding.top,
            left: -padding.left,
            bottom: -padding.bottom,
            right: -padding.right
        )
        return textRect.inset(by: invertedPadding)
    }
}
