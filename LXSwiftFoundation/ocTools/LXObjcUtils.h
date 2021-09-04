//
//  LXObjcUtils.h
//  LXSwiftFoundation
//
//  Created by 李响 on 2019/6/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    LXObjcAuthTypePhoto = 0, /// 图片（相册）
    LXObjcAuthTypeAudio,     /// 音频（麦克风）
    LXObjcAuthTypeVideo,     /// 视频（相机）
} LXObjcAuthType;

// 1 = "wifi", 2 = "4G", 3 = "3G", 4 = "2G", default = "未知"
typedef enum : NSUInteger {
    LXNetWorkTypeWifi = 1,
    LXNetWorkType4G,
    LXNetWorkType3G,
    LXNetWorkType2G,
    LXNetWorkTypeUnknow
} LXNetWorkType;

@interface LXObjcUtils : NSObject

/** 版本升级 版本比较大小
 
 @param v1 version
 @param v2 version
 @return 0: v1 == v2, -1: v1 < v2 , 1: v1 > v2
 */
+ (int)compareVersionWithV1:(const char * _Nullable)v1 v2:(const char * _Nullable) v2;

/// 将度换为弧度转
+ (CGFloat)degreesToRadians:(CGFloat)degrees;

/// 将弧度转换为度
+ (CGFloat)radiansToDegrees:(CGFloat)radians;

/// 获取网络类型 1 = "wifi", 2 = "4G", 3 = "3G", 4 = "2G", default = "未知"
+ (LXNetWorkType)getNetWorkType;

///  是否包含表情符号
- (BOOL)isContainsEmoji:(NSString *)string;

/// 是否在主线程
+ (BOOL)isMainThread;

/// 主线程执行block
+ (void)executeMainForSafe:(void(^)(void)) block;

/// 异步线程执行block
+ (void)executeGlobalForSafe:(void(^)(void)) block;

/// 去设置权限（相机、相册）
+ (void)jumpToSetting;

/// 获取跟窗口,适配iOS13.0+ PS:如果需要实现iPad多屏处理
/// 最好是使用SceneDelegate管理Window
+ (UIWindow *)getRootWindow;

/// 获取最外层窗口
+ (UIWindow *)getLastWindow;

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

/// 转换小写数字为大写数字 1 到 壹，2 到 贰 长度要小于19个，否则会crash闪退
+ (NSString *)convertToUppercaseNumbers:(double)number;

/// 去两边空格
+ (NSString *)stringByTrim:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
