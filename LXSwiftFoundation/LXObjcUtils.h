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
int _compareVersionInSwift(const char * _Nullable v1,
                           const char * _Nullable v2);

NS_ASSUME_NONNULL_BEGIN

@interface LXObjcUtils : NSObject
/**
 * Get the network type
 */
+ (int)getNetWorkType;

/**
 * 是否在主线程
 */
+ (BOOL)isMainThread;

/**
 * 主线程执行block
 */
+ (void)executeOnSafeMian:(void(^)(void)) block;

/**
 *  异步线程执行block
 */
+ (void)executeOnSafeGlobal:(void(^)(void)) block;

@end

NS_ASSUME_NONNULL_END
