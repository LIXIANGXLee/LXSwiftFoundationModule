//
//  Swift+UIButton.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2018/9/29.
//  Copyright © 2017 李响. All rights reserved.
//

import UIKit

// MARK: - UIButton 扩展
extension SwiftBasics where Base: UIButton {
    
    /// 水平居中图片和标题，并设置间距
    /// - Parameter space: 图片和标题之间的间距
    public func horizontalCenterImageAndTitle(space: CGFloat) {
        // 确保按钮有图片视图和标题标签
        guard let imageView = base.imageView,
              let titleLabel = base.titleLabel else {
            return
        }
        
        // 获取图片和标题的固有尺寸
        let imageHeight = imageView.intrinsicContentSize.height
        let imageWidth = imageView.intrinsicContentSize.width
        let titleHeight = titleLabel.intrinsicContentSize.height
        let titleWidth = titleLabel.intrinsicContentSize.width
        
        // 计算总高度（图片高度 + 标题高度 + 间距）
        let totalHeight = imageHeight + titleHeight + space
        
        // 设置图片的内边距
        base.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageHeight),  // 上移图片使其与标题垂直居中
            left: 0,
            bottom: 0,
            right: -titleWidth  // 左移图片使其与标题水平居中
        )
        
        // 设置标题的内边距
        base.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageWidth,  // 左移标题使其与图片水平居中
            bottom: -(totalHeight - titleHeight),  // 下移标题使其与图片垂直居中
            right: 0
        )
    }
    
    /// 垂直居中图片和标题，并设置间距
    /// - Parameters:
    ///   - space: 图片和标题之间的间距
    ///   - isLeftImage: 图片是否在左侧（true: 图片在左，标题在右；false: 图片在右，标题在左）
    public func verticalCenterImageAndTitle(space: CGFloat, isLeftImage: Bool = true) {
        // 确保按钮有图片视图和标题标签
        guard let imageView = base.imageView,
              let titleLabel = base.titleLabel else {
            return
        }
        
        // 获取图片和标题的宽度
        let imageWidth = imageView.intrinsicContentSize.width
        let titleWidth = titleLabel.intrinsicContentSize.width
        
        // 计算图片和标题的间距调整值
        let imageSpace = isLeftImage ? space * 0.5 : (space * 0.5 + titleWidth)
        let titleSpace = isLeftImage ? space * 0.5 : (space * 0.5 + imageWidth)
        
        // 设置图片的内边距
        base.imageEdgeInsets = UIEdgeInsets(
            top: 0,
            left: isLeftImage ? -imageSpace : imageSpace,  // 根据图片位置调整水平偏移
            bottom: 0,
            right: isLeftImage ? imageSpace : -imageSpace
        )
        
        // 设置标题的内边距
        base.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: isLeftImage ? titleSpace : -titleSpace,  // 根据标题位置调整水平偏移
            bottom: 0,
            right: isLeftImage ? -titleSpace : titleSpace
        )
    }
    
    /// 按钮的最佳宽度（根据内容自适应）
    public var bestWidth: CGFloat {
        // 使用 sizeThatFits 计算最适合的宽度（传入 CGSize.zero 表示不限制尺寸）
        base.sizeThatFits(CGSize.zero).width
    }
    
    /// 按钮的最佳高度（根据内容自适应）
    public var bestHeight: CGFloat {
        // 使用 sizeThatFits 计算最适合的高度（传入 CGSize.zero 表示不限制尺寸）
        base.sizeThatFits(CGSize.zero).height
    }
}
