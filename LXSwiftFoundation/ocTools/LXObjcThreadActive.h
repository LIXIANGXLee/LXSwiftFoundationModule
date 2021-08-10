//
//  LXObjcThreadActive.h
//  LXSwiftFoundation
//
//  Created by Mac on 2020/9/26.
//  Copyright © 2020 李响. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^LXObjcThreadActiveTask)(void);

@interface LXObjcThreadActive : NSObject

/// 开启线程（此线程生命周期跟随当前类生命周期
- (void)start;

/// 在线程中执行任务
- (void)executeTask:(LXObjcThreadActiveTask)task;

/// 主动结束线程
- (void)stop;

@end

NS_ASSUME_NONNULL_END
