//
//  NSTimer+LXObjcAdd.m
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/8/10.
//

#import "NSTimer+LXObjcAdd.h"

@implementation NSTimer (LXObjcAdd)

+ (instancetype)lx_scheduleTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeat block:(void(^)(NSTimer *))block {
    NSTimer *timer = [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(excuteTimerBlock:) userInfo:[block copy] repeats:repeat];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    return timer;
}

+ (void)excuteTimerBlock:(NSTimer *)timer {
    void(^block)(NSTimer *) = timer.userInfo;
    if (block) {
        block(timer);
    }
}

@end
