//
//  UIView+LXObjcPerformance.m
//  LXSwiftFoundationModule
//
//  Created by XL on 2020/10/10.
//  Copyright © 2020 李响. All rights reserved.
//

#import "UIView+LXObjcPerformance.h"
#import <objc/runtime.h>
#import "LXObjcProxy.h"

@implementation UIView (LXObjcPerformance)

// Global observer object
static  CFRunLoopObserverRef currentObserver;

- (void)setMaxTaskPerformedCount:(int)maxTaskPerformedCount{
    objc_setAssociatedObject(self, @selector(maxTaskPerformedCount), @(maxTaskPerformedCount), OBJC_ASSOCIATION_ASSIGN);
}

- (int)maxTaskPerformedCount {
    return (int)objc_getAssociatedObject(self, _cmd);
}

-(void)setTimer:(NSTimer * )timer{
    objc_setAssociatedObject(self, @selector(timer), timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimer *)timer {
    return (NSTimer *)objc_getAssociatedObject(self, _cmd);
}

#pragma mark - Add task
-(NSMutableArray *)tasks{
    
    NSMutableArray * taskArr = objc_getAssociatedObject(self, @selector(tasks));
    if (!taskArr) {
        taskArr = [NSMutableArray array];
        objc_setAssociatedObject(self, @selector(tasks), taskArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return taskArr;
}

/// not events
-(void)repeats{ }

/// - Using this method, uitableview and uicollectionview performance can be optimized add Observer
-(void)addRunLoopObserverOfPerformance{
    
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)(self),
        &CFRetain,
        &CFRelease,
        NULL
    };
    currentObserver =  CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &CallBack, &context);
    CFRunLoopAddObserver(runloop, currentObserver, kCFRunLoopCommonModes);
    CFRelease(currentObserver);
    
}

/// remove Observer
-(void)removeRunLoopObserver {
    
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    if (runloop && currentObserver) {
        CFRunLoopRemoveObserver(runloop, currentObserver, kCFRunLoopCommonModes);
    }
    [self removeTimer];
}

-(void)addTask:(ObjcRunloopBlock)task{
    
    /// 创建定时器
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:[LXObjcProxy proxyWithTarget:self] selector:@selector(repeats) userInfo:nil repeats:YES];
        [self.timer fire];
    }
    
    [self.tasks addObject:task];
    int maxTaskCount = self.maxTaskPerformedCount ? self.maxTaskPerformedCount : 10;
    /// cell is  screen out
    if (self.tasks.count > maxTaskCount) {
        [self.tasks removeObjectAtIndex:0];
    }
    
}

/// observer call back
static void CallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    UIView * objc = (__bridge UIView *)info;
    if (objc.tasks.count == 0) {
        [objc removeTimer];
        return;
    };
    ObjcRunloopBlock task =  objc.tasks.firstObject;
    task();
    [objc.tasks removeObjectAtIndex:0];
    
}

/// remove timer
-(void)removeTimer {
    if (self.timer != nil && [self.timer isValid]) {
        [self.timer invalidate];
        [self setTimer:nil];
    }
}

@end
