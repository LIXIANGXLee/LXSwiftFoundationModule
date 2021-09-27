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

typedef enum : NSUInteger {
    LXVersionTypeSmall = -1,
    LXVersionTypeEqual = 0,
    LXVersionTypeBig = 1
} LXVersionType;

@interface LXObjcUtils : NSObject

/// 方法交换 主要是交换对象方法的实现 method_getImplementation
+ (void)swizzleMethod:(SEL)originSel withNewMethod:(SEL)dstSel with:(Class)cls;

/// 方法交换 主要是交换类方法的实现 method_getImplementation
+ (void)swizzleClassMethod:(SEL)originSel withNewClassMethod:(SEL)dstSel with:(Class)cls;

/// 获取类的所有成员变量名字
+ (NSArray<NSString *> *)getAllIvars:(Class)cls;

/// 获取类的所有方法名字
+ (NSArray<NSString *> *)getAllMethods:(Class)cls;

/// 是否属于Foundation里的类，cls要传类对象，不是元类对象 [NSURL class],[NSDate class],[NSValue class],[NSData class],[NSError class],[NSArray class],[NSDictionary class],[NSString class],[NSAttributedString class]
+ (BOOL)isClassFromFoundation:(Class)cls;

/// 是否为系统类，cls要传类对象，不是元类对象
+ (BOOL)isSystemClass:(Class)cls;

/// 判断实例方法和类方法是否响应，cls如果是类对象，则判断是否响应实例方法，cls如果是元类对象，则判断是否响应类方法
+ (BOOL)isRespondsToSelector:(SEL)sel with:(Class)cls;

/// 判断是否响应实例方法
+ (BOOL)isInstancesRespondToSelector:(SEL)sel with:(Class)cls;

/// 判断是否响应类方法
+ (BOOL)isClassRespondToSelector:(SEL)sel with:(Class)cls;

/// 获取实例方法的实现
+ (IMP _Nullable)getInstanceMethodForSelector:(SEL)sel with:(Class)cls;

/// 获得类方法的实现
+ (IMP _Nullable)getClassMethodForSelector:(SEL)sel with:(Class)cls;

/** 版本升级 版本比较大小
 
 @param v1 version
 @param v2 version
 @return 0: v1 == v2, -1: v1 < v2 , 1: v1 > v2
 */
+ (int)compareVersionWithV1:(const char * _Nullable)v1 v2:(const char * _Nullable)v2;

/** 版本升级 版本比较大小
 
 @param v1 version
 @param v2 version
 @return LXVersionTypeEqual: v1 == v2,
         LXVersionTypeSmall: v1 < v2,
         LXVersionTypeBig:   v1 > v2
 */
+ (LXVersionType)compareWithV1:(const char * _Nullable)v1 v2:(const char * _Nullable)v2;

/// 将度换为弧度转
+ (CGFloat)degreesToRadians:(CGFloat)degrees;

/// 将弧度转换为度
+ (CGFloat)radiansToDegrees:(CGFloat)radians;

/// 获取网络类型 1 = "wifi", 2 = "4G", 3 = "3G", 4 = "2G", default = "未知"
+ (LXNetWorkType)getNetWorkType;

///  是否包含表情符号
- (BOOL)isContainsEmoji:(NSString *)string;

/// 判断是否在主线程
+ (BOOL)isMainThread;

/// 主线程执行block，如果项目有主线程操作推荐调用此方法，更有效
+ (void)executeMainForSafe:(void(^)(void)) block;

/// 异步线程执行block
+ (void)executeGlobalForSafe:(void(^)(void)) block;

/// 去设置权限（相机、相册）
+ (void)jumpToSetting;

/// 获取跟窗口,适配iOS13.0+ PS:如果需要实现iPad多屏处理
/// 最好是使用SceneDelegate管理Window
+ (UIWindow *)getRootWindow;

/// 获取最外层窗口，并且过滤了相册授权弹起的窗口，因为关闭后Windows里面依然存在hidden的相册窗口，避免影响后续操作，特在此过滤掉
+ (UIWindow *)getLastWindow;

/// 获取所有窗口
+ (NSArray<UIWindow *> *)getAllWindows;

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

/** 将视频写入相册（系统相册+自定义相册） (建议先执行方法checkAuth:(LXObjcAuthType)type callBack:(void (*)(BOOL isPass))callBack 或 checkAuth:(LXObjcAuthType)type isAlert:(BOOL)isAlert callBack:(void (*)(BOOL isPass))callBack LXObjcAuthType = LXObjcAuthTypePhoto  对相册隐私权限检测)
 * - parameter:
 * - url 视频资源
 * - collectionTitle 相册名称，相册名称为nil或者@"",则相册名是项目名
 */
+ (void)writeVideoToAbulmWithUrl:(NSURL *)url collectionTitle:(NSString * _Nullable)collectionTitle completionHandler:(void (^)(BOOL isSuccess, NSString *error))completionHandler API_AVAILABLE(ios(9.0));

/// 将视频写入相册(系统相册) (建议先执行方法checkAuth:(LXObjcAuthType)type callBack:(void (*)(BOOL isPass))callBack 或 checkAuth:(LXObjcAuthType)type isAlert:(BOOL)isAlert callBack:(void (*)(BOOL isPass))callBack LXObjcAuthType = LXObjcAuthTypePhoto  对相册隐私权限检测)
+ (void)writeVideoToAbulmWithUrl:(NSURL *)url completionHandler:(void (^)(BOOL isSuccess, NSError *error, NSString *assetUrlLocalIdentifier))completionHandler API_AVAILABLE(ios(9.0));

/** 将图片写入相册（系统相册+自定义相册） (建议先执行方法checkAuth:(LXObjcAuthType)type callBack:(void (*)(BOOL isPass))callBack 或 checkAuth:(LXObjcAuthType)type isAlert:(BOOL)isAlert callBack:(void (*)(BOOL isPass))callBack LXObjcAuthType = LXObjcAuthTypePhoto  对相册隐私权限检测)
 * - parameter:
 * - image 图片资源
 * - collectionTitle 相册名称，相册名称为nil或者@"",则相册名是项目名
 */
+ (void)writeImageToAbulmWithImage:(UIImage *)image collectionTitle:(NSString * _Nullable)collectionTitle completionHandler:(void (^)(BOOL isSuccess, NSString *error))completionHandler API_AVAILABLE(ios(9.0));

/// 将图片写入相册(系统相册) (建议先执行方法checkAuth:(LXObjcAuthType)type callBack:(void (*)(BOOL isPass))callBack 或 checkAuth:(LXObjcAuthType)type isAlert:(BOOL)isAlert callBack:(void (*)(BOOL isPass))callBack LXObjcAuthType = LXObjcAuthTypePhoto  对相册隐私权限检测)
+ (void)writeImageToAbulmWithImage:(UIImage *)image completionHandler:(void (^)(BOOL isSuccess, NSError *error, NSString *assetImageLocalIdentifier))completionHandler API_AVAILABLE(ios(9.0));

/// 转换小写数字为大写数字 1 到 壹，2 到 贰 长度要小于19个，否则会crash闪退
+ (NSString *)convertToUppercaseNumbers:(double)number;

/// 去两边空格
+ (NSString *)stringByTrim:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
