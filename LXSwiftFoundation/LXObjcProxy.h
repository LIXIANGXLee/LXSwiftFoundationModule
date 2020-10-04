//
//  LXObjcProxy.h
//  LXSwiftFoundation
//
//  Created by Mac on 2020/9/26.
//  Copyright © 2020 李响. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXObjcProxy : NSObject
+(instancetype)proxyWithTarget:(id)target;

@property (weak, nonatomic) id target;

@end

NS_ASSUME_NONNULL_END
