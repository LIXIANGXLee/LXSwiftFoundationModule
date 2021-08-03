//
//  LXObjcUtils.h
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/6/8.
//

#import <Foundation/Foundation.h>

/** 版本升级 版本比较大小
 
 @param v1 one version
 @param v2 two version
 @return 0:eque,-1:one small,1:two small
 */
int _compareVersionInSwift(const char * _Nullable v1, const char * _Nullable v2);

NS_ASSUME_NONNULL_BEGIN

@interface LXObjcUtils : NSObject

/// 获取网络类型
+ (int)getNetWorkType;

/// 是否在主线程
+ (BOOL)isMainThread;

/// 主线程执行block
+ (void)executeOnSafeMian:(void(^)(void)) block;

/// 异步线程执行block
+ (void)executeOnSafeGlobal:(void(^)(void)) block;

/// 是否属于Foundation里的类 [NSURL class],[NSDate class],[NSValue class],[NSData class],[NSError class],[NSArray class],[NSDictionary class],[NSString class],[NSAttributedString class]
+ (BOOL)isClassFromFoundation:(Class)c;

/// 是否为系统类
+ (BOOL)isSystemClass:(Class)c;

/// 方法交换 主要是交换方法的实现
+ (void)swizzleMethod:(SEL)originSel withNewMethod:(SEL)dstSel;

/** 将视频写入相册
 * - parameter:
 * - url 视频资源
 * - collectionTitle 相册名称，相册名称为nil或者@"",则相册名是项目名
 */
+ (void)writeVideoToAbulmWithUrl:(NSURL *)url collectionTitle:(NSString * _Nullable)collectionTitle completionHandler:(void (^)(BOOL isSuccess, NSString * _Nonnull))completionHandler API_AVAILABLE(ios(9.0));

+ (void)writeVideoToAbulmWithUrl:(NSURL *)url completionHandler:(void (^)(BOOL isSuccess, NSString * _Nonnull))completionHandler API_AVAILABLE(ios(9.0));


/** 将图片写入相册
 * - parameter:
 * - image 图片资源
 * - collectionTitle 相册名称，相册名称为nil或者@"",则相册名是项目名
 */
+ (void)writeImageToAbulmWithImage:(UIImage *)image collectionTitle:(NSString * _Nullable)collectionTitle completionHandler:(void (^)(BOOL isSuccess, NSString * _Nonnull))completionHandler API_AVAILABLE(ios(9.0));

+ (void)writeImageToAbulmWithImage:(UIImage *)image completionHandler:(void (^)(BOOL isSuccess, NSString * _Nonnull))completionHandler API_AVAILABLE(ios(9.0));

@end

NS_ASSUME_NONNULL_END
