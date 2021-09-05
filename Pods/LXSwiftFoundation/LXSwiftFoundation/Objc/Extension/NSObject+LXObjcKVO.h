//
//  NSObject+LXObjcKVO.h
//  LXSwiftFoundation
//
//  Created by 李响 on 2016/8/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LXObjcKVO)

/// 注册block块以接收指定路径的KVO通知 相对于接收器
- (void)lx_addObserverBlockForKeyPath:(NSString*)keyPath block:(void (^)(id _Nonnull obj, _Nullable id oldVal, _Nullable id newVal))block;

/// 移除单个通知，接收由给定密钥路径指定的属性的更改通知，相对于接收器，并释放这些块
- (void)lx_removeObserverBlocksForKeyPath:(NSString*)keyPath;

/// 移除所有通知监听，接收更改通知，并释放这些块。
- (void)lx_removeObserverBlocks;

@end

NS_ASSUME_NONNULL_END
