//
//  LXSwiftWaterfallLayout.swift
//  LXSwiftFoundationManager
//
//  Created by Mac on 2018/4/23.
//  Copyright © 2018 李响. All rights reserved.
//

import UIKit

@objc(LXObjcWaterfallLayoutDataSource)
public protocol LXSwiftWaterfallLayoutDataSource: AnyObject {
    
    /// 根据给出的宽度计算高度
    @objc func waterfallLayout(_ layout: LXSwiftWaterfallLayout, width: CGFloat, indexPath: IndexPath) -> CGFloat
    
    /// 每一行的列数
    @objc func numberOfColsInWaterfallLayout(_ layout: LXSwiftWaterfallLayout) -> Int
}

// MARK: - 瀑布流
@objc(LXObjcWaterfallLayout)
@objcMembers open class LXSwiftWaterfallLayout: UICollectionViewFlowLayout {
    
    open weak var dataSource: LXSwiftWaterfallLayoutDataSource?
    
    // MARK: 私有延时属性
    private lazy var attrsArray = [UICollectionViewLayoutAttributes]()
    private var maxH: CGFloat = 0
    private var startIndex = 0
    private var totalHeight: CGFloat = 0
    private lazy var colHeights: [CGFloat] = {
        let cols = self.dataSource?.numberOfColsInWaterfallLayout(self) ?? 2
        return Array(repeating: self.sectionInset.top, count: cols)
    }()
}

extension LXSwiftWaterfallLayout {
    
    open override func prepare() {
        super.prepare()
        guard let cView = collectionView else { return }

        // 获取item的个数
        let itemCount = cView.numberOfItems(inSection: 0)
        // 获取列数
        let cols = dataSource?.numberOfColsInWaterfallLayout(self) ?? 2
        // 计算Item的宽度
        let itemW = (cView.bounds.width - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing) / CGFloat(cols)
        
        // 计算所有的item的属性
        for i in startIndex..<itemCount {
            // 设置每一个Item位置相关的属性
            let indexPath = IndexPath(item: i, section: 0)
            
            // 根据位置创建Attributes属性
            let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            // 获取高度
            let height = dataSource?.waterfallLayout(self, width: itemW, indexPath: indexPath) ?? 1
            
            // 取出最小列的位置
            var minH = colHeights.min() ?? 1
            let index = colHeights.firstIndex(of: minH) ?? 1
            minH = minH + height + minimumLineSpacing
            colHeights[index] = minH
            
            // 设置item的属性
            attrs.frame = CGRect(x: self.sectionInset.left + (self.minimumInteritemSpacing + itemW) * CGFloat(index), y: minH - height - self.minimumLineSpacing, width: itemW, height: height)
            
            if !attrsArray.contains(attrs) { attrsArray.append(attrs) }
        }
        
        // 记录最大值
        maxH = colHeights.max() ?? 1
        
        // 给startIndex重新复制
        startIndex = itemCount
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? { attrsArray }
    
    open override var collectionViewContentSize: CGSize { CGSize(width: 0, height: maxH + sectionInset.bottom - minimumLineSpacing) }
}

