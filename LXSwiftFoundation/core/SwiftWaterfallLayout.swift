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
    ///   - width: item 的预设宽度（已扣除间距）
    ///   - indexPath: item 的位置索引
    /// - Returns: item 的实际高度
    @objc func waterfallLayout(_ layout: SwiftWaterfallLayout, width: CGFloat, indexPath: IndexPath) -> CGFloat
    
    /// 返回瀑布流的列数
    /// - Parameter layout: 瀑布流布局对象
    /// - Returns: 瀑布流列数（至少为1）
    @objc func numberOfColsInWaterfallLayout(_ layout: SwiftWaterfallLayout) -> Int
}

// MARK: - 瀑布流布局类
@objc(LXObjcWaterfallLayout)
@objcMembers open class SwiftWaterfallLayout: UICollectionViewFlowLayout {
    
    // MARK: 公开属性
    /// 布局数据源（弱引用避免循环引用）
    open weak var dataSource: SwiftWaterfallLayoutDataSource?
    
    // MARK: 私有属性
    /// 缓存所有item的布局属性
    private var attrsArray = [UICollectionViewLayoutAttributes]()
    /// 内容区域的最大高度（用于计算contentSize）
    private var maxHeight: CGFloat = 0
    /// 记录各列的当前底部Y坐标（用于布局计算）
    private var colHeights: [CGFloat] = []
}

// MARK: - 布局核心逻辑
extension SwiftWaterfallLayout {
    
    /// 准备布局（核心方法，每次布局前系统自动调用）
    open override func prepare() {
        super.prepare()
        
        // 重置布局状态
        resetLayoutState()
        
        // 安全校验：确保collectionView和数据源存在
        guard let collectionView = collectionView,
              let dataSource = dataSource else {
            return
        }
        
        // 获取有效列数（确保至少1列）
        let numberOfCols = max(dataSource.numberOfColsInWaterfallLayout(self), 1)
        // 计算单列宽度（扣除内边距和列间距）
        let itemWidth = calculateItemWidth(columnCount: numberOfCols)
        
        // 获取item总数（只处理第0组）
        let itemCount = collectionView.numberOfItems(inSection: 0)
        
        // 遍历所有item计算布局属性
        for index in 0..<itemCount {
            let indexPath = IndexPath(item: index, section: 0)
            guard let attribute = layoutAttributeForItem(
                at: indexPath,
                columnCount: numberOfCols,
                itemWidth: itemWidth
            ) else { continue }
            
            attrsArray.append(attribute)
        }
        
        // 计算最大高度（取所有列的最大高度 + 底部内边距）
        maxHeight = (colHeights.max() ?? 0) + sectionInset.bottom
    }
    
    /// 返回指定区域内需要显示的布局属性
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // 优化：只返回与显示区域相交的布局属性，提升性能
        return attrsArray.filter { $0.frame.intersects(rect) }
    }
    
    /// 返回内容区域的总尺寸
    open override var collectionViewContentSize: CGSize {
        // 宽度为0表示自动匹配collectionView宽度
        return CGSize(width: 0, height: maxHeight)
    }
}

// MARK: - 布局辅助方法
private extension SwiftWaterfallLayout {
    
    /// 重置布局状态（每次重新布局时调用）
    func resetLayoutState() {
        // 清空缓存
        attrsArray.removeAll()
        colHeights.removeAll()
        
        // 获取有效列数（默认2列）
        let columnCount = max(dataSource?.numberOfColsInWaterfallLayout(self) ?? 2, 1)
        // 初始化列高数组（每列起始位置 = 顶部内边距）
        colHeights = Array(repeating: sectionInset.top, count: columnCount)
    }
    
    /// 计算单列实际宽度
    /// - Parameter columnCount: 当前列数
    /// - Returns: 每列的有效展示宽度
    func calculateItemWidth(columnCount: Int) -> CGFloat {
        guard let collectionView = collectionView else { return 0 }
        
        // 计算可用内容宽度（总宽度 - 左右内边距）
        let contentWidth = collectionView.bounds.width
            - sectionInset.left
            - sectionInset.right
        
        // 计算总间距（列间距 * (列数 - 1)）
        let totalSpacing = CGFloat(columnCount - 1) * minimumInteritemSpacing
        
        // 计算单列宽度 = (内容宽度 - 总间距) / 列数
        let itemWidth = (contentWidth - totalSpacing) / CGFloat(columnCount)
        
        // 返回有效值（确保不小于0）
        return max(itemWidth, 0)
    }
    
    /// 创建单个item的布局属性
    /// - Parameters:
    ///   - indexPath: item位置
    ///   - columnCount: 总列数
    ///   - itemWidth: 计算好的单列宽度
    /// - Returns: 布局属性对象（失败时返回nil）
    func layoutAttributeForItem(
        at indexPath: IndexPath,
        columnCount: Int,
        itemWidth: CGFloat
    ) -> UICollectionViewLayoutAttributes? {
        guard let dataSource = dataSource else { return nil }
        
        // 1. 获取动态高度（通过数据源回调）
        let itemHeight = dataSource.waterfallLayout(
            self,
            width: itemWidth,
            indexPath: indexPath
        )
        
        // 2. 寻找最短列（瀑布流核心算法）
        guard var minHeight = colHeights.min(),
              let minColumnIndex = colHeights.firstIndex(of: minHeight) else {
            return nil
        }
        
        // 3. 计算位置坐标
        // X坐标：左内边距 + (列宽+列间距) * 列索引
        let xPosition = sectionInset.left +
            (itemWidth + minimumInteritemSpacing) * CGFloat(minColumnIndex)
        
        // Y坐标处理逻辑：
        //   - 如果是当前列的第一个元素：直接使用当前列高度
        //   - 非首元素：当前列高度 + 行间距
        let yPosition = minHeight +
            (minHeight > sectionInset.top ? minimumLineSpacing : 0)
        
        // 4. 创建布局属性
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attribute.frame = CGRect(
            x: xPosition,
            y: yPosition,
            width: itemWidth,
            height: itemHeight
        )
        
        // 5. 更新列高记录
        colHeights[minColumnIndex] = attribute.frame.maxY
        
        return attribute
    }
}
