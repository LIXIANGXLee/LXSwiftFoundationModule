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

/**
 start thread
*/
- (void)start;

/**
 Execute a task in the current child thread
 */
- (void)executeTask:(LXObjcThreadActiveTask)task;

/**
 End thread
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
