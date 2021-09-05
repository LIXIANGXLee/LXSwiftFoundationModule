//
//  UIGestureRecognizer+LXObjcAdd.h
//  LXSwiftFoundation
//
//  Created by 李响 on 2016/8/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIGestureRecognizer (LXObjcAdd)

/// 将事件block块添加到手势识别器对象
- (void)lx_addActionBlock:(void (^)(id sender))block;

/// 移除所有回调函数即block回调函数
- (void)lx_removeAllActionBlocks;

@end

NS_ASSUME_NONNULL_END
