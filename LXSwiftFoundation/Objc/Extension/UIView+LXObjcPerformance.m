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
static CFRunLoopObserverRef currentObserver;

-(void)setLx_maxTaskPerformedCount:(int)lx_maxTaskPerformedCount {
    objc_setAssociatedObject(self, @selector(lx_maxTaskPerformedCount), @(lx_maxTaskPerformedCount), OBJC_ASSOCIATION_ASSIGN);
}

- (int)lx_maxTaskPerformedCount {
    return (int)objc_getAssociatedObject(self, _cmd);
}

- (void)setLx_timer:(NSTimer * _Nullable)lx_timer {
    objc_setAssociatedObject(self, @selector(lx_timer), lx_timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimer *)lx_timer {
    return (NSTimer *)objc_getAssociatedObject(self, _cmd);
}

#pragma mark - Add task
-(NSMutableArray *)tasks {
    NSMutableArray * taskArr = objc_getAssociatedObject(self, @selector(tasks));
    if (!taskArr) {
        taskArr = [NSMutableArray array];
        objc_setAssociatedObject(self, @selector(tasks), taskArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return taskArr;
}

/// not events
-(void)repeats { }

/// 使用这种方法，uitableview和uicollectionview性能可以通过添加观察者进行优化
-(void)lx_addRunLoopObserverOfPerformance {
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)(self),
        &CFRetain,
        &CFRelease,
        NULL
    };
    currentObserver = CFRunLoopObserverCreate(NULL,
                                               kCFRunLoopBeforeWaiting,
                                               YES,
                                               0,
                                               &CallBack,
                                               &context);
    CFRunLoopAddObserver(runloop, currentObserver, kCFRunLoopCommonModes);
    CFRelease(currentObserver);
}

/// 移除观察者
-(void)lx_removeRunLoopObserver {
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    if (runloop && currentObserver) {
        CFRunLoopRemoveObserver(runloop, currentObserver, kCFRunLoopCommonModes);
    }
    [self removeTimer];
}

-(void)lx_addTask:(ObjcRunloopBlock)task {
    /// 创建定时器
    if (self.lx_timer == nil) {
        LXObjcProxy *proxy = [LXObjcProxy proxyWithTarget:self];
        self.lx_timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:proxy selector:@selector(repeats) userInfo:nil repeats:YES];
        [self.lx_timer fire];
    }
    
    [self.tasks addObject:task];
    int maxTaskCount = self.lx_maxTaskPerformedCount ? self.lx_maxTaskPerformedCount : 10;
    if (self.tasks.count > maxTaskCount) {
        [self.tasks removeObjectAtIndex:0];
    }
    
}

/// 事件监听回调
static void CallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    UIView * objc = (__bridge UIView *)info;
    if (objc.tasks.count == 0) {
        [objc removeTimer];
        return;
    };
    ObjcRunloopBlock task =  objc.tasks.firstObject;
    task();
    [objc.tasks removeObjectAtIndex:0];
    
}

/// 移除计时器
-(void)removeTimer {
    if (self.lx_timer != nil && [self.lx_timer isValid]) {
        [self.lx_timer invalidate];
        [self setLx_timer:nil];
    }
}

@end
