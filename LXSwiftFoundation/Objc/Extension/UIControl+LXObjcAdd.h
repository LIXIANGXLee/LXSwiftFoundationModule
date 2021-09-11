//
//  UIControl+LXObjcAdd.h
//  LXSwiftFoundation
//
//  Created by 李响 on 2016/8/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (LXObjcAdd)

/// 将特定事件的block添加到内部调度表中，block回调方
- (void)lx_addBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block;

/// 移除所有Target监听对象
- (void)lx_removeAllBlocks;

@end

NS_ASSUME_NONNULL_END
