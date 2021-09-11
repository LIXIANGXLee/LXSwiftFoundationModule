//
//  LXWaterFlowLayout.m
//  LXSwiftFoundation
//
//  Created by Mac on 2016/9/26.
//  Copyright © 2016 李响. All rights reserved.
//

#import "LXWaterFlowLayout.h"

@interface LXWaterFlowLayout ()
/**
 *  存放每列高度字典
 */
@property (nonatomic, strong) NSMutableDictionary *dicOfheight;
/**
 *  存放所有item的attrubutes属性
 */
@property (nonatomic, strong) NSMutableArray *itemArray;


@end

@implementation LXWaterFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.colNumber = 2;
        self.rowSpacing = 10.0f;
        self.colSpacing = 10.0f;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _dicOfheight = [NSMutableDictionary dictionary];
        self.itemArray = [NSMutableArray array];
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    //初始化好每列的高度
    for (NSInteger i = 0; i < self.colNumber ; i++) {
        [_dicOfheight setObject:@(self.sectionInset.top) forKey:[NSString stringWithFormat:@"%ld",i]];
    }
    for (NSInteger i = 0 ; i < count; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [self.itemArray addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
}

- (CGSize)collectionViewContentSize {
    __weak __typeof(self)weakSelf = self;
    __block NSString *maxHeightline = @"0";
    [_dicOfheight enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *obj, BOOL *stop) {
        if ([weakSelf.dicOfheight[maxHeightline] floatValue] < [obj floatValue] ) {
            maxHeightline = key;
        }
    }];
    return CGSizeMake(self.collectionView.bounds.size.width, [_dicOfheight[maxHeightline] floatValue] + self.sectionInset.bottom);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.itemArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //计算item宽
    CGFloat itemW = (self.collectionView.bounds.size.width - (self.sectionInset.left + self.sectionInset.right) - (self.colNumber - 1) * self.colSpacing) / self.colNumber;
    CGFloat itemH;
    //计算item高
    itemH = [self.delegate getHeight:indexPath width:itemW];
    CGSize itemSize = CGSizeMake(itemW, itemH);
    
    //循环遍历找出高度最短行
    __weak __typeof(self)weakSelf = self;
    __block NSString *lineMinHeight = @"0";
    [_dicOfheight enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *obj, BOOL *stop) {
        if ([weakSelf.dicOfheight[lineMinHeight] floatValue] > [obj floatValue]) {
            lineMinHeight = key;
        }
    }];
    int line = [lineMinHeight intValue];
    //找出最短行后，计算item位置
    CGPoint itemOrigin = CGPointMake(self.sectionInset.left + line * (itemW + self.colSpacing), [_dicOfheight[lineMinHeight] floatValue]);
    _dicOfheight[lineMinHeight] = @(itemSize.height + self.rowSpacing + [_dicOfheight[lineMinHeight] floatValue]);
    attr.frame = (CGRect){itemOrigin,itemSize};
    return attr;
}

@end
