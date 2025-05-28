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
    
    /// 当前居中的单元格索引
    private var currentCenteredIndex: Int = 0
    
    /// 缩放系数（距离中心越远，缩放比例越小）
    private let scaleFactor: CGFloat = 0.3
    
    /// 最小行间距（这里设置为0以实现紧密排列）
    private let minimumLineSpacingValue: CGFloat = 0
    
    // MARK: - 布局准备
    
    /// 准备布局（设置初始参数）
    open override func prepare() {
        super.prepare()
        
        // 配置基础布局参数
        scrollDirection = .horizontal
        minimumLineSpacing = minimumLineSpacingValue
        
        // 计算并设置左右边距使内容居中
        guard let collectionView = collectionView else { return }
        let horizontalInset = max(0, (collectionView.frame.width - itemSize.width) * 0.5)
        sectionInset = UIEdgeInsets(
            top: 0,
            left: horizontalInset,
            bottom: 0,
            right: horizontalInset
        )
    }
    
    // MARK: - 布局属性计算
    
    /// 返回指定矩形区域内所有元素的布局属性（添加缩放效果）
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // 获取父类计算的布局属性
        guard let collectionView = collectionView,
              let attributesArray = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        // 计算当前视图中心点（考虑滚动偏移）
        let visibleCenterX = collectionView.contentOffset.x + collectionView.bounds.width / 2
        
        // 对每个属性应用缩放变换
        return attributesArray.map { attributes in
            let attributesCopy = attributes.copy() as! UICollectionViewLayoutAttributes
            // 计算与中心的水平偏移量
            let xOffset = abs(attributesCopy.center.x - visibleCenterX)
            // 根据偏移量计算缩放比例
            let scale = 1 - (xOffset / collectionView.bounds.width) * scaleFactor
            attributesCopy.transform = CGAffineTransform(scaleX: scale, y: scale)
            return attributesCopy
        }
    }
    
    // MARK: - 滚动位置调整
    
    /// 计算滚动停止时的目标位置（使最近单元格居中）
    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                        withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset,
                                          withScrollingVelocity: velocity)
        }
        
        // 计算目标显示区域
        let targetRect = CGRect(
            x: proposedContentOffset.x,
            y: 0,
            width: collectionView.bounds.width,
            height: collectionView.bounds.height
        )
        
        // 获取目标区域内的布局属性
        guard let attributes = super.layoutAttributesForElements(in: targetRect) else {
            return proposedContentOffset
        }
        
        // 计算目标中心点
        let targetCenterX = proposedContentOffset.x + collectionView.bounds.width / 2
        
        // 寻找最近的单元格
        var closestAttribute: UICollectionViewLayoutAttributes?
        var minDistance = CGFloat.greatestFiniteMagnitude
        
        for attribute in attributes {
            let distance = abs(attribute.center.x - targetCenterX)
            if distance < minDistance {
                minDistance = distance
                closestAttribute = attribute
            }
        }
        
        // 调整contentOffset使单元格居中
        if let closestAttribute = closestAttribute {
            return CGPoint(
                x: closestAttribute.center.x - collectionView.bounds.width / 2,
                y: proposedContentOffset.y
            )
        }
        
        return proposedContentOffset
    }
    
    // MARK: - 布局失效判断
    
    /// 判断是否需要更新布局（检测当前居中单元格）
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return true }
        
        // 计算当前可见区域中心点
        let currentCenterX = collectionView.contentOffset.x + collectionView.bounds.width / 2
        let currentCenterY = collectionView.contentOffset.y + collectionView.bounds.height / 2
        let currentCenter = CGPoint(x: currentCenterX, y: currentCenterY)
        
        // 获取中心点对应的索引
        if let indexPath = collectionView.indexPathForItem(at: currentCenter),
           indexPath.item != currentCenteredIndex {
            currentCenteredIndex = indexPath.item
            delegate?.lineFlowLayout?(self, currentCenteredIndex)
        }
        
        // 继承父类的失效判断逻辑
        return super.shouldInvalidateLayout(forBoundsChange: newBounds)
    }
}
