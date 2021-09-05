//
//  NSTimer+LXObjcAdd.h
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/8/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (LXObjcAdd)

+ (instancetype)lx_scheduleTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeat block:(void(^)(NSTimer * _Nullable))block;

@end

NS_ASSUME_NONNULL_END
