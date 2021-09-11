//
//  LXWaterFlowLayout.h
//  LXSwiftFoundation
//
//  Created by Mac on 2016/9/26.
//  Copyright © 2016 李响. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LXWaterFlowLayoutDelegate <NSObject>

/// 根据宽度计算高度
- (CGFloat)getHeight:(NSIndexPath *)indexPath width:(CGFloat)width;

@end


@interface LXWaterFlowLayout : UICollectionViewLayout

/// 列数
@property (nonatomic, assign) NSInteger colNumber;

/// 行间距
@property (nonatomic, assign) CGFloat rowSpacing;

/// 列间距
@property (nonatomic, assign) CGFloat colSpacing;

/// 内边距
@property (nonatomic, assign) UIEdgeInsets sectionInset;

/// 代理
@property(nonatomic,weak) id<LXWaterFlowLayoutDelegate>delegate;

@end
