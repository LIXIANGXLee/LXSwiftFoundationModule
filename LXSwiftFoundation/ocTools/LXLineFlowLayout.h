//
//  LXLineFlowLayout.h
//  LXSwiftFoundation
//
//  Created by Mac on 2016/9/26.
//  Copyright © 2016 李响. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXLineFlowLayout : UICollectionViewFlowLayout

+ (instancetype)manager;

/// 布局item 的宽
@property(nonatomic,assign) CGFloat ItemWidth;

/// 布局item 的高
@property(nonatomic,assign) CGFloat ItemHeight;

/// 布局item 垂直方向间距（竖）
@property(nonatomic,assign) CGFloat minimumLine;

/// 布局item 水平方向间距（横）
@property(nonatomic,assign) CGFloat minimumInter;

@end
