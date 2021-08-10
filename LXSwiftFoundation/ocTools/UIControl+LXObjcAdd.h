//
//  UIControl+LXObjcAdd.h
//  LXSwiftFoundation
//
//  Created by 李响 on 2016/8/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (LXObjcAdd)

/// 将特定事件的block添加到内部调度表中
- (void)lx_addBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block;

/// 添加或替换特定事件的目标对象
- (void)lx_setTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

/// 将事件的块添加或替换到内部事件中
- (void)lx_setBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block;

/// 从数组中删除特定事件的所有块
- (void)lx_removeAllBlocksForControlEvents:(UIControlEvents)controlEvents;

/// 移除所有Target监听对象
- (void)lx_removeAllTargets;

@end

NS_ASSUME_NONNULL_END
