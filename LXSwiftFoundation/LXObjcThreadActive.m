//
//  LXObjcThreadActive.m
//  LXSwiftFoundation
//
//  Created by Mac on 2020/9/26.
//  Copyright © 2020 李响. All rights reserved.
//

#import "LXObjcThreadActive.h"
#import "LXObjcProxy.h"

/** LXThread **/
//@interface LXObjcThread : NSThread
//@end
//@implementation LXObjcThread
//- (void)dealloc{
//    NSLog(@"%s", __func__);
//}
//@end

@interface LXObjcThreadActive()
@property (strong, nonatomic) NSThread *innerThread;
@property (assign, nonatomic) BOOL isStart;

@end

@implementation LXObjcThreadActive

#pragma mark - public methods
- (instancetype)init{
    if (self = [super init]) {
        if (@available(iOS 10.0, *)) {
            __weak typeof(self)weakSelf = self;
            self.innerThread = [[NSThread alloc] initWithBlock:^{
                [weakSelf __saveThread];
            }];
            
        } else {
            LXObjcProxy *proxy = [LXObjcProxy proxyWithTarget:self];
            self.innerThread = [[NSThread alloc]initWithTarget:proxy selector:@selector(__saveThread) object:nil];
        }
        
        [self start];

    }
    return self;
}

- (void)start{
    if (!self.innerThread) return;
   
    if (!self.innerThread.isExecuting && !self.isStart) {
         self.isStart = true;
         [self.innerThread start];
    }
}

- (void)executeTask:(LXObjcThreadActiveTask)task{
    if (!self.innerThread || !task) return;
    
    [self performSelector:@selector(__executeTask:)
                 onThread:self.innerThread
               withObject:task waitUntilDone:NO];
}

- (void)stop{
    if (!self.innerThread) return;
    
    [self performSelector:@selector(__stop)
                 onThread:self.innerThread
               withObject:nil waitUntilDone:YES];
}

- (void)dealloc{
    NSLog(@"%s", __func__);
    [self stop];
}

#pragma mark - private methods
-(void)__saveThread{

    CFRunLoopSourceContext context = {0};
    CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault,
                                                      0,
                                                      &context);
    CFRunLoopAddSource(CFRunLoopGetCurrent(),
                       source,
                       kCFRunLoopDefaultMode);
    CFRelease(source);
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
}

- (void)__stop{
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.innerThread = nil;
    self.isStart = false;
}

- (void)__executeTask:(LXObjcThreadActiveTask)task{
    task();
}

@end
