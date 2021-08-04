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
int LXCompareVersionInSwift(const char * _Nullable v1, const char * _Nullable v2);

/// 将度换为弧度转
CGFloat LXObjcDegreesToRadians(CGFloat degrees);

/// 将弧度转换为度
CGFloat LXObjcRadiansToDegrees(CGFloat radians);

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    LXObjcAuthTypePhoto = 0, /// 图片（相册）
    LXObjcAuthTypeAudio,     /// 音频（麦克风）
    LXObjcAuthTypeVideo,     /// 视频（相机）
} LXObjcAuthType;

@interface LXObjcUtils : NSObject

/// 将度换为弧度转
+ (CGFloat)degreesToRadians:(CGFloat)degrees;

/// 将弧度转换为度
+ (CGFloat)radiansToDegrees:(CGFloat)radians;

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

/// 去设置权限（相机、相册）
+ (void)jumpToSetting;

/// 获取keyWindow,适配iOS13.0+ PS:如果需要实现iPad多屏处理
/// 最好是使用SceneDelegate管理Window
+ (UIWindow*)getKeyWindow;

/// 获取当前显示的视图控制器
+ (UIViewController *)getCurrentController;

/** 检查隐私权限
 * - type 类型：
 *  LXObjcAuthTypePhoto，在plist文件里设置 Privacy - Photo Library Usage Description
 *  LXObjcAuthTypeAudio，在plist文件里设置 Privacy - Microphone Usage Description
 *  LXObjcAuthTypeVideo，在plist文件里设置 Privacy - Camera Usage Description
 * - isAlert 是否显示弹窗提示 YES则显示弹窗 NO不显示弹窗
 * - callBack 权限结果回调 isPass == YES，则权限通过
 */
+ (void)checkAuth:(LXObjcAuthType)type isAlert:(BOOL)isAlert callBack:(void (*)(BOOL isPass))callBack;

/** 检查隐私权限 有弹窗提示信息
 * - type 类型：
 *  LXObjcAuthTypePhoto，在plist文件里设置 Privacy - Photo Library Usage Description
 *  LXObjcAuthTypeAudio，在plist文件里设置 Privacy - Microphone Usage Description
 *  LXObjcAuthTypeVideo，在plist文件里设置 Privacy - Camera Usage Description
 * - callBack 权限结果回调 isPass == YES，则权限通过
 */
+ (void)checkAuth:(LXObjcAuthType)type callBack:(void (*)(BOOL isPass))callBack;

/** 将视频写入相册 (建议先执行方法checkAuth:(LXObjcAuthType)type callBack:(void (*)(BOOL isPass))callBack 或 checkAuth:(LXObjcAuthType)type isAlert:(BOOL)isAlert callBack:(void (*)(BOOL isPass))callBack LXObjcAuthType = LXObjcAuthTypePhoto  对相册隐私权限检测)
 * - parameter:
 * - url 视频资源
 * - collectionTitle 相册名称，相册名称为nil或者@"",则相册名是项目名
 */
+ (void)writeVideoToAbulmWithUrl:(NSURL *)url collectionTitle:(NSString * _Nullable)collectionTitle completionHandler:(void (^)(BOOL isSuccess, NSString * _Nonnull))completionHandler API_AVAILABLE(ios(9.0));

+ (void)writeVideoToAbulmWithUrl:(NSURL *)url completionHandler:(void (^)(BOOL isSuccess, NSString * _Nonnull))completionHandler API_AVAILABLE(ios(9.0));

/** 将图片写入相册 (建议先执行方法checkAuth:(LXObjcAuthType)type callBack:(void (*)(BOOL isPass))callBack 或 checkAuth:(LXObjcAuthType)type isAlert:(BOOL)isAlert callBack:(void (*)(BOOL isPass))callBack LXObjcAuthType = LXObjcAuthTypePhoto  对相册隐私权限检测)
 * - parameter:
 * - image 图片资源
 * - collectionTitle 相册名称，相册名称为nil或者@"",则相册名是项目名
 */
+ (void)writeImageToAbulmWithImage:(UIImage *)image collectionTitle:(NSString * _Nullable)collectionTitle completionHandler:(void (^)(BOOL isSuccess, NSString * _Nonnull))completionHandler API_AVAILABLE(ios(9.0));

+ (void)writeImageToAbulmWithImage:(UIImage *)image completionHandler:(void (^)(BOOL isSuccess, NSString * _Nonnull))completionHandler API_AVAILABLE(ios(9.0));

@end

NS_ASSUME_NONNULL_END
