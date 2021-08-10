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
    [self addTarget:target action:@selector(invokeTarget:)
   forControlEvents:controlEvents];
    NSMutableArray *targets = [self _lxAllObjcControlBlockTargets];
    [targets addObject:target];
}

- (void)lx_setTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    if (!target || !action || !controlEvents) return;
    NSSet *targets = [self allTargets];
    [targets enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSArray *actions = [self actionsForTarget:obj forControlEvent:controlEvents];
        for (NSString *currentAction in actions) {
            [self removeTarget:obj
                        action:NSSelectorFromString(currentAction)
              forControlEvents:controlEvents];
        }
    }];
    /// 添加任务对象
    [self addTarget:target action:action forControlEvents:controlEvents];
}

- (void)lx_setBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block {
    [self lx_removeAllBlocksForControlEvents:UIControlEventAllEvents];
    [self lx_addBlockForControlEvents:controlEvents block:block];
}

- (void)lx_removeAllBlocksForControlEvents:(UIControlEvents)controlEvents {
    if (!controlEvents) return;
    NSMutableArray *targets = [self _lxAllObjcControlBlockTargets];
    NSMutableArray *removes = [NSMutableArray array];
    [targets enumerateObjectsUsingBlock:^(_LXObjcControlBlockTarget *target, NSUInteger idx, BOOL * _Nonnull stop) {
        if (target.events & controlEvents) {
            UIControlEvents newEvent = target.events & (~controlEvents);
            if (newEvent) {
                [self removeTarget:target
                            action:@selector(invokeTarget:)
                  forControlEvents:target.events];
                target.events = newEvent;
                [self addTarget:target
                         action:@selector(invokeTarget:)
               forControlEvents:target.events];
            } else {
                [self removeTarget:target
                            action:@selector(invokeTarget:)
                  forControlEvents:target.events];
                [removes addObject:target];
            }
        }
    }];
    [targets removeObjectsInArray:removes];
}

- (void)lx_removeAllTargets {
    [[self allTargets] enumerateObjectsUsingBlock: ^(id object, BOOL *stop) {
        [self removeTarget:object action:nil forControlEvents:UIControlEventAllEvents];
    }];
    [[self _lxAllObjcControlBlockTargets] removeAllObjects];
}

- (NSMutableArray *)_lxAllObjcControlBlockTargets {
    NSMutableArray *targets = objc_getAssociatedObject(self, &block_key_control);
    if (!targets) {
        targets = [NSMutableArray array];
        objc_setAssociatedObject(self, &block_key_control, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end
