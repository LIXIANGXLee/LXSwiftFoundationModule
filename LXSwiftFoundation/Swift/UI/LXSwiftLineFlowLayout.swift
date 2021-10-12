//
//  LXSwiftLineFlowLayout.swift
//  LXSwiftSwiftFoundation
//
//  Created by 李响 on 2020/7/5.
//

import UIKit

@objc(LXObjcLineFlowLayoutDelegate)
public protocol LXSwiftLineFlowLayoutDelegate: AnyObject {
    
    /// 滑动到的中心view的索引的回调
    @objc optional func lineFlowLayout(_ lineFlowLayout: LXSwiftLineFlowLayout, _ index: Int)
}

// MARK: - 线性布局
@objc(LXObjcLineFlowLayout)
@objcMembers open class LXSwiftLineFlowLayout: UICollectionViewFlowLayout {
   
    open weak var delegate: LXSwiftLineFlowLayoutDelegate?
    private var index: Int = 0
    open override func prepare() {
        super.prepare()
        scrollDirection = .horizontal
        minimumLineSpacing = 0
//        guard let c = collectionView else { return }
//
//        let inset = (c.frame.width - itemSize.width) * 0.5
//        sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
         guard let cView = collectionView else { return [] }
         var attsArray: [UICollectionViewLayoutAttributes] = []
         if let aArray = super.layoutAttributesForElements(in: rect) {
            let centerX = cView.frame.size.width / 2 + cView.contentOffset.x
            for attribute in aArray {
                let offsetX = abs(attribute.center.x - centerX)
                let scale = 1 - (offsetX / cView.frame.size.width * 0.3)
                attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
                attsArray.append(attribute)
            }
         }
        return attsArray
    }
    
    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let cView = collectionView else { return CGPoint.zero }
        var contentOffset = CGPoint(x: proposedContentOffset.x, y: proposedContentOffset.y)
        var rect = CGRect.zero
        rect.origin.y = 0
        rect.origin.x = contentOffset.x
        rect.size = cView.frame.size
        if let attsArray = super.layoutAttributesForElements(in: rect) {
            let centerX = contentOffset.x + cView.frame.size.width / 2
            var minSpace = MAXFLOAT
            for attrs in attsArray {
                if abs(minSpace) > Float(abs(attrs.center.x - centerX)) {
                    minSpace = Float(attrs.center.x - centerX)
                }
            }
            contentOffset.x += CGFloat(minSpace)
            return contentOffset
        }
        return CGPoint.zero
    }
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let cView = collectionView else { return true }
        guard let pInViewPoint = cView.superview?.convert(cView.center,
            to: self.collectionView) else { return true }
        guard let indexPathNow = cView.indexPathForItem(at: pInViewPoint) else { return true }
        if index != indexPathNow.row {
            index = indexPathNow.row
            delegate?.lineFlowLayout?(self, index)
        }
        super.shouldInvalidateLayout(forBoundsChange: newBounds)
        return true
    }
}
