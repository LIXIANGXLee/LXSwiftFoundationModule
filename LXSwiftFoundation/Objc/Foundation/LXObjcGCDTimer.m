//
//  LXObjcGCDTimer.m
//  LXSwiftFoundation
//
//  Created by 李响 on 2016/8/10.
//

#import "LXObjcGCDTimer.h"

@implementation LXObjcGCDTimer

static NSMutableDictionary *_timers;
dispatch_semaphore_t _semaphore;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _timers = [NSMutableDictionary dictionary];
        _semaphore = dispatch_semaphore_create(1);
    });
}

+ (void)timerTask:(NSString *)identified task:(void (^)(void))task{
    [self timerTask:0.0 interval:1.0 repeats:YES async:YES identified:identified task:^{
        task();
    }];
}

+ (void)timerTask:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async identified:(NSString *)identified task:(void (^)(void))task{
    if (!task || start < 0 || (interval <= 0 && repeats)) return;
    dispatch_queue_t queue = async ? dispatch_get_global_queue(0, 0) : dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    _timers[identified] = timer;
    dispatch_semaphore_signal(_semaphore);
    dispatch_source_set_event_handler(timer, ^{
        task();
        // 不重复的任务
        if (!repeats) { [self cancelTimerTask:identified]; }
    });
    dispatch_resume(timer);
}

+ (void)timerTask:(id)target selector:(SEL)selector start:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async identified:(NSString *)identified{
    if (!target || !selector) return;
    [self timerTask:start interval:interval repeats:repeats async:async identified:identified task:^{
        if ([target respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:selector];
#pragma clang diagnostic pop
        }
    }];
}

+ (void)cancelTimerTask:(NSString *)identified{
    
    if (identified.length == 0) return;
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    dispatch_source_t timer = _timers[identified];
    if (timer) {
        dispatch_source_cancel(timer);
        [_timers removeObjectForKey:identified];
    }
    dispatch_semaphore_signal(_semaphore);
}

@end
