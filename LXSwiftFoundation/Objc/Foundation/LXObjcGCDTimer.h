//
//  LXObjcGCDTimer.h
//  LXSwiftFoundation
//
//  Created by 李响 on 2016/8/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXObjcGCDTimer : NSObject

/// 初始化一个新计时器，开始计时器为0，间隔为1，重复执行
/// 标识为唯一标识符保存计时器，任务和取消计时任务，重复为是
+ (void)timerTask:(NSString *)identified task:(void(^)(void))task;

/// 初始化一个新计时器，开始为开始计时器，间隔为重复计时器，重复为是或否，标识为唯一标识符保存计时器，任务和取消定时任务，重复为是或否
+ (void)timerTask:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async identified:(NSString *)identified task:(void(^)(void))task;

+ (void)timerTask:(id)target selector:(SEL)selector start:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async identified:(NSString *)identified;

/// 唯一标识符取消定时任务
+ (void)cancelTimerTask:(NSString *)identified;

@end

NS_ASSUME_NONNULL_END
