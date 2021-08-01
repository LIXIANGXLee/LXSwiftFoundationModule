//
//  LXObjcProxy.h
//  LXSwiftFoundation
//
//  Created by Mac on 2016/9/26.
//  Copyright © 2016 李响. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXObjcProxy : NSObject

///添加构造方法
+(instancetype)proxyWithTarget:(id)target;

/// 弱引用对象
@property (weak, nonatomic) id target;

@end

NS_ASSUME_NONNULL_END
