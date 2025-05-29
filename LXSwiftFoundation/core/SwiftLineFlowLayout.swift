//
//  SwiftLineFlowLayout.swift
//  LXSwiftSwiftFoundation
//
//  Created by 李响 on 2020/7/5.
//

import UIKit

/// 线性流式布局的代理协议，用于通知当前居中的索引
@objc(LXObjcLineFlowLayoutDelegate)
public protocol SwiftLineFlowLayoutDelegate: AnyObject {
    
    /// 当滑动到某个中心视图时的回调方法
    /// - Parameters:
    ///   - lineFlowLayout: 触发事件的布局对象
    ///   - index: 当前位于视图中心的单元格索引
    @objc optional func lineFlowLayout(_ lineFlowLayout: SwiftLineFlowLayout, _ index: Int)
}

/// 自定义水平线性流式布局，支持居中缩放效果
@objc(LXObjcLineFlowLayout)
@objcMembers open class SwiftLineFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - 公开属性
    
    /// 布局代理
    open weak var delegate: SwiftLineFlowLayoutDelegate?
    
    // MARK: - 私有属性
    
    /// 当前居中的单元格索引（避免重复回调）
    private var currentCenteredIndex: Int = 0
    
    /// 缩放系数（距离中心越远，缩放比例越小，取值范围0.0~1.0）
    private let scaleFactor: CGFloat = 0.3
    
    /// 最小行间距（设置为0实现紧密排列）
    private let minimumLineSpacingValue: CGFloat = 0
    
    // MARK: - 布局准备
    
    /// 准备布局（设置初始参数）
    open override func prepare() {
        super.prepare()
        
        // 1. 配置滚动方向为水平
        scrollDirection = .horizontal
        
        // 2. 设置单元格最小间距为0（紧密排列）
        minimumLineSpacing = minimumLineSpacingValue
        
        // 3. 计算并设置左右边距使内容居中
        guard let collectionView = collectionView else { return }
        
        // 确保itemSize有有效值（默认使用100防止除0错误）
        let itemWidth = itemSize.width > 0 ? itemSize.width : 100
        
        // 计算水平边距 = (屏幕宽度 - 单元格宽度) / 2
        let horizontalInset = max(0, (collectionView.frame.width - itemWidth) * 0.5)
        
        // 4. 设置sectionInset确保内容居中显示（保留原有top/bottom值）
        sectionInset = UIEdgeInsets(
            top: sectionInset.top,
            left: horizontalInset,
            bottom: sectionInset.bottom,
            right: horizontalInset
        )
    }
    
    // MARK: - 布局属性计算
    
    /// 返回指定矩形区域内所有元素的布局属性（添加缩放效果）
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // 1. 获取父类计算的布局属性
        guard let collectionView = collectionView,
              let attributesArray = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        // 2. 计算当前可视区域中心点（考虑滚动偏移）
        let visibleCenterX = collectionView.contentOffset.x + collectionView.bounds.width / 2
        
        // 3. 对每个单元格应用缩放变换
        return attributesArray.map { originalAttributes in
            // 创建属性副本（避免修改原始属性）
            let attributes = originalAttributes.copy() as! UICollectionViewLayoutAttributes
            
            // 计算单元格中心与屏幕中心的水平距离
            let distanceToCenter = abs(attributes.center.x - visibleCenterX)
            
            /* 缩放比例计算逻辑：
               - 当单元格位于中心时：distance=0 → scale=1.0（原始大小）
               - 当单元格位于屏幕边缘时：distance=collectionView.width/2 → scale=1-scaleFactor
               - 缩放曲线：线性递减
             */
            let scale = max(0, 1 - (distanceToCenter / collectionView.bounds.width) * scaleFactor)
            
            // 应用缩放变换
            attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            // 设置层级（中心单元格显示在最前面）
            attributes.zIndex = Int(scale * 1000)  // 根据缩放值生成zIndex
            
            return attributes
        }
    }
    
    // MARK: - 滚动位置调整
    
    /// 计算滚动停止时的目标位置（自动吸附到最近的单元格）
    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                        withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset,
                                          withScrollingVelocity: velocity)
        }
        
        // 1. 确定目标显示区域（使用collectionView的bounds）
        let targetRect = CGRect(
            x: proposedContentOffset.x,
            y: 0,
            width: collectionView.bounds.width,
            height: collectionView.bounds.height
        )
        
        // 2. 获取目标区域内的布局属性
        guard let attributes = super.layoutAttributesForElements(in: targetRect) else {
            return proposedContentOffset
        }
        
        // 3. 计算目标中心点（屏幕中心）
        let targetCenterX = proposedContentOffset.x + collectionView.bounds.width / 2
        
        // 4. 寻找最近的单元格
        var closestAttribute: UICollectionViewLayoutAttributes?
        var minDistance = CGFloat.greatestFiniteMagnitude  // 初始设为最大浮点数
        
        for attribute in attributes {
            // 计算单元格中心与目标中心的绝对距离
            let distance = abs(attribute.center.x - targetCenterX)
            
            // 更新最小距离和最近单元格
            if distance < minDistance {
                minDistance = distance
                closestAttribute = attribute
            }
        }
        
        // 5. 调整contentOffset使最近的单元格居中
        if let closestAttribute = closestAttribute {
            // 计算需要调整的偏移量：单元格中心X - 屏幕中心X
            let adjustedOffsetX = closestAttribute.center.x - collectionView.bounds.width / 2
            
            return CGPoint(
                x: adjustedOffsetX,
                y: proposedContentOffset.y
            )
        }
        
        return proposedContentOffset
    }
    
    // MARK: - 布局失效处理
    
    /// 当边界改变时判断是否需要重新布局（检测当前居中单元格变化）
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return true }
        
        // 1. 计算当前可见区域中心点
        let visibleCenterX = collectionView.contentOffset.x + collectionView.bounds.width / 2
        
        // 2. 获取当前可见区域的布局属性
        guard let attributes = layoutAttributesForElements(in: newBounds) else {
            return super.shouldInvalidateLayout(forBoundsChange: newBounds)
        }
        
        // 3. 寻找距离中心最近的单元格
        var closestIndex: Int?
        var minDistance = CGFloat.greatestFiniteMagnitude
        
        for attribute in attributes {
            let distance = abs(attribute.center.x - visibleCenterX)
            if distance < minDistance {
                minDistance = distance
                closestIndex = attribute.indexPath.item
            }
        }
        
        // 4. 检测中心索引变化并通知代理
        if let closestIndex = closestIndex, closestIndex != currentCenteredIndex {
            currentCenteredIndex = closestIndex
            delegate?.lineFlowLayout?(self, currentCenteredIndex)
        }
        
        // 5. 继承父类的布局失效判断（通常需要重新计算布局属性）
        return super.shouldInvalidateLayout(forBoundsChange: newBounds)
    }
}
