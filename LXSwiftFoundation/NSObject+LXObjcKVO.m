//
//  NSObject+LXObjcKVO.m
//  LXSwiftFoundation
//
//  Created by 李响 on 2016/8/3.
//

#import "NSObject+LXObjcKVO.h"
#import <objc/runtime.h>

static const int block_key_kvo;
@interface _LXObjcKVOBlockTarget : NSObject
/// block回调属性
@property (nonatomic, copy) void (^block)(__weak id obj, id oldVal, id newVal);

/// 初始化方法添加回调函数
- (id)initWithBlock:(void (^)(__weak id obj, id oldVal, id newVal))block;

@end

@implementation _LXObjcKVOBlockTarget

- (id)initWithBlock:(void (^)(__weak id obj, id oldVal, id newVal))block {
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

/// kvo监听回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (!self.block) return;
    
    BOOL isPrior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
    if (isPrior) return;
    
    NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
    if (changeKind != NSKeyValueChangeSetting) return;
    
    /// 旧值
    id oldVal = [change objectForKey:NSKeyValueChangeOldKey];
    if (oldVal == [NSNull null]) oldVal = nil;
    
    /// 替换的新值
    id newVal = [change objectForKey:NSKeyValueChangeNewKey];
    if (newVal == [NSNull null]) newVal = nil;
    
    /// 监听结果回调
    self.block(object, oldVal, newVal);
}

@end

@implementation NSObject (LXObjcKVO)

- (void)lx_addObserverBlockForKeyPath:(NSString *)keyPath block:(void (^)(__weak id obj, id oldVal, id newVal))block {
    if (!keyPath || !block) return;
    _LXObjcKVOBlockTarget *target = [[_LXObjcKVOBlockTarget alloc] initWithBlock:block];
    NSMutableDictionary *dic = [self _lxAllObjcObserverBlocks];
    NSMutableArray *arr = dic[keyPath];
    if (!arr) {
        arr = [NSMutableArray new];
        dic[keyPath] = arr;
    }
    [arr addObject:target];
    [self addObserver:target
           forKeyPath:keyPath
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:NULL];
}

- (void)lx_removeObserverBlocksForKeyPath:(NSString *)keyPath {
    if (!keyPath) return;
    NSMutableDictionary *dic = [self _lxAllObjcObserverBlocks];
    NSMutableArray *arr = dic[keyPath];
    [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        [self removeObserver:obj forKeyPath:keyPath];
    }];
    [dic removeObjectForKey:keyPath];
}

- (void)lx_removeObserverBlocks {
    NSMutableDictionary *dic = [self _lxAllObjcObserverBlocks];
    [dic enumerateKeysAndObjectsUsingBlock: ^(NSString *key, NSArray *arr, BOOL *stop) {
        [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
            [self removeObserver:obj forKeyPath:key];
        }];
    }];
    [dic removeAllObjects];
}

- (NSMutableDictionary *)_lxAllObjcObserverBlocks {
    NSMutableDictionary *targets = objc_getAssociatedObject(self, &block_key_kvo);
    if (!targets) {
        targets = [NSMutableDictionary new];
        objc_setAssociatedObject(self, &block_key_kvo, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end
