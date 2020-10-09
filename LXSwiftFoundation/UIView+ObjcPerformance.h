//
//  UIView+ObjcPerformance.h
//  LXSwiftFoundationModule
//
//  Created by XL on 2020/10/10.
//  Copyright © 2020 李响. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ObjcRunloopBlock)(void);

@interface UIView (ObjcPerformance)

//The current page displays the maximum number of pictures with tableviewcell max count or uicollectionviewcell max count
@property(nonatomic,assign)int maxTaskPerformedCount;

/// private timer
@property(nonatomic,readonly)NSTimer *timer;

/// - Using this method, uitableview and uicollectionview performance can be optimized add Observer
-(void)addRunLoopObserverOfPerformance;

/// Add task
-(void)addTask:(ObjcRunloopBlock)task;

/// remove Observer （Please call to remove the observer when you do not use the observer, otherwise it will cause memory leak）
-(void)removeRunLoopObserver;

@end

NS_ASSUME_NONNULL_END
