//
//  LXObjcUtils.h
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/6/8.
//

#import <Foundation/Foundation.h>

/**
 version campare
 
 @param v1 one version
 @param v2 two version
 @return 0:eque,-1:one small,1:two small
 */
int _compareVersionInSwift(const char *v1, const char *v2);

NS_ASSUME_NONNULL_BEGIN

@interface LXObjcUtils : NSObject
/**
 * Get the network type
 */
+ (int)getNetWorkType;

@end

NS_ASSUME_NONNULL_END
