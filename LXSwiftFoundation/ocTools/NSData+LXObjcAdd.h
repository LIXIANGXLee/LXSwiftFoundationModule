//
//  NSData+LXObjcAdd.h
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/8/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (LXObjcAdd)

/// data -> string
- (nullable NSString * )lx_jsonDataToString;

@end

NS_ASSUME_NONNULL_END
