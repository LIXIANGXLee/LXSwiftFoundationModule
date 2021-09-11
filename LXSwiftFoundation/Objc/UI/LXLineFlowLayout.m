//
//  LXLineFlowLayout.m
//  LXSwiftFoundation
//
//  Created by Mac on 2016/9/26.
//  Copyright © 2016 李响. All rights reserved.
//

#import "LXLineFlowLayout.h"

@implementation LXLineFlowLayout

+ (instancetype)manager {
    LXLineFlowLayout *flowLayout = [[LXLineFlowLayout alloc] init];
    return flowLayout;
}

- (void)prepareLayout{
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.itemSize = CGSizeMake(_ItemWidth?_ItemWidth:260, _ItemHeight?_ItemHeight:300);
    CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    self.minimumLineSpacing = _minimumLine?_minimumLine : 0.01;
    self.minimumInteritemSpacing  = _minimumInter?_minimumInter : 0.01;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attsArray = [super layoutAttributesForElementsInRect:rect];
    CGFloat centerX = self.collectionView.frame.size.width / 2 + self.collectionView.contentOffset.x;
    for (UICollectionViewLayoutAttributes *atts in attsArray) {
        CGFloat space = ABS(atts.center.x - centerX);
        CGFloat scale = 1 - (space/self.collectionView.frame.size.width)*0.15;
        atts.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return attsArray;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    NSArray *attsArray = [super layoutAttributesForElementsInRect:rect];
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width / 2;
    CGFloat minSpace = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in attsArray) {
        if (ABS(minSpace) > ABS(attrs.center.x - centerX)) {
            minSpace = attrs.center.x - centerX;
        }
    }
    proposedContentOffset.x += minSpace;
    return proposedContentOffset;
}

@end
