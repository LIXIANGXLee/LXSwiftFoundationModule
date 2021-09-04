//
//  LXObjcProxy.m
//  LXSwiftFoundation
//
//  Created by Mac on 2016/9/26.
//  Copyright © 2016 李响. All rights reserved.
//

#import "LXObjcProxy.h"

@implementation LXObjcProxy

+ (instancetype)proxyWithTarget:(id)target{
    LXObjcProxy *proxy = [LXObjcProxy alloc];
    proxy.target = target;
    return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation{
    [invocation invokeWithTarget:self.target];
}

@end
