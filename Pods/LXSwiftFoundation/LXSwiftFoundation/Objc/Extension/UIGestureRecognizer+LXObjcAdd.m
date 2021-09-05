//
//  UIGestureRecognizer+LXObjcAdd.m
//  LXSwiftFoundation
//
//  Created by 李响 on 2016/8/3.
//

#import "UIGestureRecognizer+LXObjcAdd.h"
#import <objc/runtime.h>

static const int block_key_gesture;
@interface _LXGestureRecognizerBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id objc);

/// 初始化事件和回调函数
- (id)initWithBlock:(void (^)(id objc))block;

/// 执行回调函数对应的target
- (void)invokeTarget:(id)objc;

@end

@implementation _LXGestureRecognizerBlockTarget

- (id)initWithBlock:(void (^)(id objc))block{
    self = [super init];
    if (self) {
        _block = [block copy];
    }
    return self;
}

- (void)invokeTarget:(id)objc {
    if (_block) _block(objc);
}

@end

@implementation UIGestureRecognizer (LXObjcAdd)

- (void)lx_addActionBlock:(void (^)(id sender))block {
    _LXGestureRecognizerBlockTarget *target = [[_LXGestureRecognizerBlockTarget alloc] initWithBlock:block];
    [self addTarget:target action:@selector(invokeTarget:)];
    NSMutableArray *targets = [self _lx_allBlockTargets];
    [targets addObject:target];
}

- (void)lx_removeAllActionBlocks{
    NSMutableArray *targets = [self _lx_allBlockTargets];
    [targets enumerateObjectsUsingBlock:^(id target, NSUInteger idx, BOOL *stop) {
        [self removeTarget:target action:@selector(invokeTarget:)];
    }];
    [targets removeAllObjects];
}

- (NSMutableArray *)_lx_allBlockTargets {
    NSMutableArray *targets = objc_getAssociatedObject(self, &block_key_gesture);
    if (!targets) {
        targets = [NSMutableArray array];
        objc_setAssociatedObject(self, &block_key_gesture, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end
