//
//  LXSwiftWaterfallLayout.swift
//  LXSwiftFoundationManager
//
//  Created by Mac on 2018/4/23.
//  Copyright © 2018 李响. All rights reserved.
//

import UIKit

// MARK: - 瀑布流布局数据源协议
@objc(LXObjcWaterfallLayoutDataSource)
public protocol SwiftWaterfallLayoutDataSource: AnyObject {
    
    /// 计算指定 indexPath 对应 item 的高度（根据给定的宽度动态计算）
    /// - Parameters:
    ///   - layout: 瀑布流布局对象
    ///   - width: item 的预设宽度
    ///   - indexPath: item 的位置索引
    @objc func waterfallLayout(_ layout: SwiftWaterfallLayout, width: CGFloat, indexPath: IndexPath) -> CGFloat
    
    /// 返回瀑布流的列数
    /// - Parameter layout: 瀑布流布局对象
    @objc func numberOfColsInWaterfallLayout(_ layout: SwiftWaterfallLayout) -> Int
}

// MARK: - 瀑布流布局类
@objc(LXObjcWaterfallLayout)
@objcMembers open class SwiftWaterfallLayout: UICollectionViewFlowLayout {
    
    // MARK: 公开属性
    /// 布局数据源
    open weak var dataSource: SwiftWaterfallLayoutDataSource?
    
    // MARK: 私有属性
    /// 缓存所有布局属性
    private var attrsArray = [UICollectionViewLayoutAttributes]()
    /// 记录当前最大高度（用于计算 contentSize）
    private var maxHeight: CGFloat = 0
    /// 各列的当前高度数组（用于布局计算）
    private var colHeights: [CGFloat] = []
}

// MARK: - 布局逻辑
extension SwiftWaterfallLayout {
    
    /// 准备布局（核心方法，每次布局前调用）
    open override func prepare() {
        super.prepare()
        
        // 重置布局状态
        resetLayoutState()
        
        // 安全校验
        guard let collectionView = collectionView else { return }
        guard let dataSource = dataSource else { return }
        
        // 获取列数（至少保证1列）
        let numberOfCols = max(dataSource.numberOfColsInWaterfallLayout(self), 1)
        // 计算有效的item宽度
        let itemWidth = calculateItemWidth(columnCount: numberOfCols)
        
        // 遍历所有item计算布局属性
        let itemCount = collectionView.numberOfItems(inSection: 0)
        for index in 0..<itemCount {
            let indexPath = IndexPath(item: index, section: 0)
            // 计算并设置每个item的布局属性
            if let attribute = layoutAttributeForItem(at: indexPath, columnCount: numberOfCols, itemWidth: itemWidth) {
                attrsArray.append(attribute)
            }
        }
        
        // 计算最大高度（用于 contentSize）
        maxHeight = colHeights.max() ?? 0
    }
    
    /// 返回指定区域内的所有布局属性
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // 直接返回所有缓存的属性（可根据rect进行过滤优化，此处简化为全部返回）
        return attrsArray
    }
    
    /// 返回内容尺寸
    open override var collectionViewContentSize: CGSize {
        // 宽度为0（系统会自动处理为collectionView宽度），高度为最大列高 + 底部间距
        return CGSize(width: 0, height: maxHeight + sectionInset.bottom)
    }
}

// MARK: - 私有方法
private extension SwiftWaterfallLayout {
    
    /// 重置布局状态
    func resetLayoutState() {
        attrsArray.removeAll()
        colHeights.removeAll()
        
        // 初始化列高数组（每列初始高度为顶部内边距）
        let cols = dataSource?.numberOfColsInWaterfallLayout(self) ?? 2
        let columnCount = max(cols, 1)
        colHeights = Array(repeating: sectionInset.top, count: columnCount)
    }
    
    /// 计算item宽度
    func calculateItemWidth(columnCount: Int) -> CGFloat {
        guard let collectionView = collectionView else { return 0 }
        
        // 计算可用宽度（总宽度 - 左右内边距 - 列间距总和）
        let contentWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right
        let totalSpacing = CGFloat(columnCount - 1) * minimumInteritemSpacing
        let itemWidth = (contentWidth - totalSpacing) / CGFloat(columnCount)
        
        // 确保宽度有效（不小于0）
        return max(itemWidth, 0)
    }
    
    /// 生成指定indexPath的布局属性
    func layoutAttributeForItem(at indexPath: IndexPath, columnCount: Int, itemWidth: CGFloat) -> UICollectionViewLayoutAttributes? {
        guard let dataSource = dataSource else { return nil }
        
        // 从数据源获取item高度
        let itemHeight = dataSource.waterfallLayout(self, width: itemWidth, indexPath: indexPath)
        
        // 找到最短列的索引和高度
        guard let minHeight = colHeights.min(), let minColumnIndex = colHeights.firstIndex(of: minHeight) else { return nil }
        
        // 计算Y坐标（如果是首行则不需要添加行间距）
        let yPosition = minHeight + (minHeight == sectionInset.top ? 0 : minimumLineSpacing)
        // 计算X坐标（左边距 + 列位置*(宽度+间距)）
        let xPosition = sectionInset.left + (itemWidth + minimumInteritemSpacing) * CGFloat(minColumnIndex)
        
        // 创建布局属性
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attribute.frame = CGRect(x: xPosition, y: yPosition, width: itemWidth, height: itemHeight)
        
        // 更新列高（当前列的底部Y坐标）
        colHeights[minColumnIndex] = attribute.frame.maxY
        
        return attribute
    }
}
