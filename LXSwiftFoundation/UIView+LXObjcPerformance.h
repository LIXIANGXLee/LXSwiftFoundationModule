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

//The current page displays the maximum number of pictures with tableviewcell max count or uicollectionviewcell max count
@property(nonatomic, assign)int lx_maxTaskPerformedCount;

/// private timer
@property(nonatomic, readonly, nullable)NSTimer *lx_timer;

/// - Using this method, uitableview and uicollectionview performance can be optimized add Observer
-(void)lx_addRunLoopObserverOfPerformance;

/// Add task
-(void)lx_addTask:(ObjcRunloopBlock)task;

/// remove Observer（Please call to remove the observer when you do not use the observer, otherwise it will cause memory leak）
-(void)lx_removeRunLoopObserver;

@end

NS_ASSUME_NONNULL_END
