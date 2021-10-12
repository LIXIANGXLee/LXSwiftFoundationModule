//
//  UIView+LXObjcPerformance.h
//  LXSwiftFoundationModule
//
//  Created by XL on 2020/10/10.
//  Copyright © 2020 李响. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ObjcRunloopBlock)(void);

@interface UIView (LXObjcPerformance)

/// 当前页面显示具有tableviewcell max count或uicollectionviewcell max count的最大图片数
@property(nonatomic, assign)NSInteger lx_maxTaskPerformedCount;

/// 只读定时器属性
@property(nonatomic, readonly, nullable)NSTimer *lx_timer;

/// 使用此方法，可以优化uitableview和uicollectionview性能
-(void)lx_addRunLoopObserverOfPerformance;

/// 添加任务
-(void)lx_addTask:(ObjcRunloopBlock)task;

/// 移除观察者（请在不使用观察者时调用以移除观察者，否则将导致内存泄漏）
-(void)lx_removeRunLoopObserver;

@end

NS_ASSUME_NONNULL_END
