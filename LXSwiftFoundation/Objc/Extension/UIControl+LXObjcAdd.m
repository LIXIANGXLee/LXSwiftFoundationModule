//
//  UIControl+LXObjcAdd.m
//  LXSwiftFoundation
//
//  Created by 李响 on 2016/8/3.
//

#import "UIControl+LXObjcAdd.h"
#import <objc/runtime.h>

static const int block_key_control;
@interface _LXObjcControlBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id objc);
@property (nonatomic, assign) UIControlEvents events;

/// 初始化事件和回调函数
- (id)initWithBlock:(void (^)(id objc))block events:(UIControlEvents)events;

/// 执行回调函数对应的target
- (void)invokeTarget:(id)objc;

@end

@implementation _LXObjcControlBlockTarget

- (id)initWithBlock:(void (^)(id objc))block events:(UIControlEvents)events {
    self = [super init];
    if (self) {
        _block = [block copy];
        _events = events;
    }
    return self;
}

- (void)invokeTarget:(id)objc {
    if (_block) _block(objc);
}

@end

@implementation UIControl (LXObjcAdd)

- (void)lx_addBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block {
    if (!controlEvents) return;
    _LXObjcControlBlockTarget *target = [[_LXObjcControlBlockTarget alloc] initWithBlock:block events:controlEvents];
    [self addTarget:target action:@selector(invokeTarget:) forControlEvents:controlEvents];
    NSMutableArray *targets = [self _lxAllObjcControlBlocks];
    [targets addObject:target];
}

- (void)lx_removeAllBlocks {
    [[self allTargets] enumerateObjectsUsingBlock: ^(id object, BOOL *stop) {
        [self removeTarget:object action:nil forControlEvents:UIControlEventAllEvents];
    }];
    [[self _lxAllObjcControlBlocks] removeAllObjects];
}

- (NSMutableArray *)_lxAllObjcControlBlocks {
    NSMutableArray *targets = objc_getAssociatedObject(self, &block_key_control);
    if (!targets) {
        targets = [NSMutableArray array];
        objc_setAssociatedObject(self, &block_key_control, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end
