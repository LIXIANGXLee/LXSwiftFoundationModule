//
//  LXObjcUtils.m
//  LXSwiftFoundation
//
//  Created by 李响 on 2020/6/8.
//

#import "LXObjcUtils.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <Photos/Photos.h>
#import <CoreData/CoreData.h>
#import <objc/runtime.h>

#define OBJC_PROJECT_NAME [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"]

@implementation LXObjcUtils

+ (int)compareVersionWithV1:(const char *)v1 v2:(const char *)v2 {
    assert(v1);
    assert(v2);
    const char *p_v1 = v1;
    const char *p_v2 = v2;
    while (*p_v1 && *p_v2) {
        char buf_v1[32] = {0};
        char buf_v2[32] = {0};
        char *i_v1 = strchr(p_v1, '.');
        char *i_v2 = strchr(p_v2, '.');
        if (!i_v1 || !i_v2)  { break; }
        if (i_v1 != p_v1) {
            strncpy(buf_v1, p_v1, i_v1 - p_v1);
            p_v1 = i_v1;
        }else{
            p_v1++;
        }
        if (i_v2 != p_v2) {
            strncpy(buf_v2, p_v2, i_v2 - p_v2);
            p_v2 = i_v2;
        }else {
            p_v2++;
        }
        int order = atoi(buf_v1) - atoi(buf_v2);
        if (order != 0) {
            return order < 0 ? -1 : 1;
        }
    }
    double res = atof(p_v1) - atof(p_v2);
    if (res < 0) return -1;
    if (res > 0) return 1;
    return 0;
}

+ (CGFloat)degreesToRadians:(CGFloat)degrees {
    return degrees * M_PI / 180;;
}

+ (CGFloat)radiansToDegrees:(CGFloat)radians {
    return radians * 180 / M_PI;
}

+ (LXNetWorkType)getNetWorkType {
    int NetworkType = 0; // UNKNOWN
    
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_storage zeroAddress;
    
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.ss_len = sizeof(zeroAddress);
    zeroAddress.ss_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags){
        return NetworkType;
    }
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0){
        if ((flags & kSCNetworkReachabilityFlagsReachable) != 0)
            NetworkType = 1; // WIFI
    }
    
    if (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
        (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0) {
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0){
            NetworkType = 1; // WIFI
        }
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN){
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
            CTTelephonyNetworkInfo * info = [[CTTelephonyNetworkInfo alloc] init];
            NSString *currentRadioAccessTechnology = info.currentRadioAccessTechnology;
            if (currentRadioAccessTechnology) {
                if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]){
                    NetworkType =  2; // 4G
                }
                else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS]){
                    NetworkType =  4; // 2G
                }else{
                    NetworkType =  3; // 3G
                }
            }
        }else{
            if((flags & kSCNetworkReachabilityFlagsReachable) == kSCNetworkReachabilityFlagsReachable){
                if ((flags & kSCNetworkReachabilityFlagsTransientConnection) == kSCNetworkReachabilityFlagsTransientConnection){
                    if((flags & kSCNetworkReachabilityFlagsConnectionRequired) == kSCNetworkReachabilityFlagsConnectionRequired){
                        NetworkType = 4; // 2G
                    }else{
                        NetworkType = 3; // 3G
                    }
                }
            }
        }
    }
    return (LXNetWorkType)NetworkType;
}

///  是否包含表情符号
- (BOOL)isContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences  usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
       const unichar hs = [substring characterAtIndex:0];
       if (0xd800 <= hs && hs <= 0xdbff) {
           if (substring.length > 1) {
               const unichar ls = [substring characterAtIndex:1];
               const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
               if (0x1d000 <= uc && uc <= 0x1f77f) {
                   returnValue = YES;
               }
           }
       } else if (substring.length > 1) {
           const unichar ls = [substring characterAtIndex:1];
           if (ls == 0x20e3) {
               returnValue = YES;
           }
       } else {
           if (0x2100 <= hs && hs <= 0x27ff) {
               returnValue = YES;
           } else if (0x2B05 <= hs && hs <= 0x2b07) {
               returnValue = YES;
           } else if (0x2934 <= hs && hs <= 0x2935) {
               returnValue = YES;
           } else if (0x3297 <= hs && hs <= 0x3299) {
               returnValue = YES;
           } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
               returnValue = YES;
           }
       }
   }];
   return returnValue;
}

+ (BOOL)isMainThread {
    return [[NSThread currentThread] isMainThread];
}

+ (void)executeMainForSafe:(void (^)(void))block {
    if([self isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

+ (void)executeGlobalForSafe:(void (^)(void))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        block();
    });
}

/// 检查权限
+ (void)checkAuth:(LXObjcAuthType)type isAlert:(BOOL)isAlert callBack:(void (*)(BOOL isPass))callBack {
    __weak typeof(self)weakSelf = self;
    [LXObjcUtils executeMainForSafe:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        switch (type) {
            case LXObjcAuthTypePhoto:
                [strongSelf checkPhotoAuth:isAlert callBack:callBack];
                break;
            case LXObjcAuthTypeVideo:
                [strongSelf checkCameraAuth:AVMediaTypeVideo isAlert:isAlert callBack:callBack];
                break;
            case LXObjcAuthTypeAudio:
                [strongSelf checkCameraAuth:AVMediaTypeAudio isAlert:isAlert callBack:callBack];
                break;
            default:
                [strongSelf checkPhotoAuth:isAlert callBack:callBack];
                break;
        }
    }];
}

+ (void)checkAuth:(LXObjcAuthType)type callBack:(void (*)(BOOL))callBack {
   
    __weak typeof(self)weakSelf = self;
    [LXObjcUtils executeMainForSafe:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf checkAuth:type isAlert:YES callBack:callBack];
    }];
    
}

/// 检查相册权限
+ (void)checkPhotoAuth:(BOOL)isAlert callBack:(void (*)(BOOL isPass))callBack {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) {
        if (callBack) { callBack(NO); }
        if (isAlert) {
           [self unableAccessPermissions:@"无法访问您的相册权限"];
        }
    } else if (status == PHAuthorizationStatusDenied) {
        if (callBack) { callBack(NO); }
        if (isAlert) {
            [self expectAccessPermissions:@"开启相册权限" message:[NSString stringWithFormat:@"“%@”想访问您的照片，开启后即可使用相册图片", OBJC_PROJECT_NAME]];
        }
    } else if (status == PHAuthorizationStatusAuthorized) {
        if (callBack) { callBack(YES); }
    } else if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (callBack) { callBack(status == PHAuthorizationStatusAuthorized); }
        }];
    }
}

/// 检查相机权限
+ (void)checkCameraAuth:(AVMediaType)type isAlert:(BOOL)isAlert callBack:(void (*)(BOOL isPass))callBack {
     AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:type];
    if (status == AVAuthorizationStatusRestricted) {
        if (callBack) { callBack(NO); }
        if (isAlert) {
            if (type == AVMediaTypeAudio) {
                [self unableAccessPermissions:@"无法访问您的麦克风权限"];
            }else if (type == AVMediaTypeVideo){
                [self unableAccessPermissions:@"无法访问您的相机权限"];
            }
        }
    } else if (status == AVAuthorizationStatusDenied) {
        if (callBack) { callBack(NO); }

        if (isAlert) {
            if (type == AVMediaTypeAudio) {
                [self expectAccessPermissions:@"开启麦克风权限" message:[NSString stringWithFormat:@"“%@”想访问您的麦克风，开启之后即可录音或播音", OBJC_PROJECT_NAME] ];
            }else if (type == AVMediaTypeVideo){
                [self expectAccessPermissions:@"开启相机权限" message:[NSString stringWithFormat:@"“%@”想访问您的相机，开启之后即可拍照或者拍摄", OBJC_PROJECT_NAME]];
            }
        }
    } else if (status == AVAuthorizationStatusAuthorized) {
        if (callBack) { callBack(YES); }
    } else if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:type completionHandler:^(BOOL granted) {
            if (callBack) { callBack(granted); }
        }];
    }
}
/// 无法访问您的权限
+ (void)unableAccessPermissions:(NSString *)title {
    __weak typeof(self)weakSelf = self;
    [LXObjcUtils executeMainForSafe:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle: UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [[strongSelf getCurrentController] presentViewController:alertController animated:YES completion:nil];
    }];
}

/// 推荐打开权限
+(void)expectAccessPermissions:(NSString *)title message:(NSString *)message {
  
    __weak typeof(self)weakSelf = self;
    [LXObjcUtils executeMainForSafe:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"以后再说" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [strongSelf jumpToSetting];
        }]];
        [[strongSelf getCurrentController] presentViewController:alertController animated:YES completion:nil];
    }];

}

+ (void)jumpToSetting {
    NSURL *url = [NSURL URLWithString: UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        if (@available(iOS 10.0, *)){
            [[UIApplication sharedApplication] openURL:url options:@{ } completionHandler:nil];
        }else{
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [[UIApplication sharedApplication] openURL:url];
            #pragma clang diagnostic pop
        }
    }
}

/// 获取当前显示的视图控制器
+ (UIViewController *)getCurrentController {
    UIViewController *rootVC = [self getRootWindow].rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootVC];
    return currentVC;
}

/// 获取跟窗口,适配iOS13.0+ PS:如果需要实现iPad多屏处理
/// 最好是使用SceneDelegate管理Window
+ (UIWindow *)getRootWindow {
    UIWindow *mainWindow = nil;
    // 如果是多场景，可以遍历windows,检查window.isKeyWindow获取
    NSArray *windows = [self getAllWindows];
    if (@available(iOS 13.0, *)) {
        for (UIWindow *window in windows) {
            if (window.isKeyWindow) {
                mainWindow = window;
                break;
            }
        }
        if (!mainWindow) {
            mainWindow = windows.firstObject;
        }
    } else {
        mainWindow = [UIApplication sharedApplication].keyWindow;
        if (!mainWindow) {
            mainWindow =  windows.firstObject;
        }
    }
    return mainWindow;
}

/// 获取最外层窗口
+ (UIWindow *)getLastWindow {
    return [self getAllWindows].lastObject;
}

+ (NSArray<UIWindow *> *)getAllWindows{
    return [UIApplication sharedApplication].windows;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    while (rootVC.presentedViewController) {
        rootVC = rootVC.presentedViewController;
    }
    if ([rootVC isKindOfClass:UITabBarController.class]) {
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    }else if ([rootVC isKindOfClass:UINavigationController.class]){
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    }else{
        currentVC = rootVC;
    }
    return currentVC;;
}

+ (void)writeVideoToAbulmWithUrl:(NSURL *)url completionHandler:(void (^)(BOOL, NSString * _Nonnull))completionHandler {
    [self writeVideoToAbulmWithUrl:url collectionTitle:nil completionHandler:completionHandler];
}

+ (void)writeVideoToAbulmWithUrl:(NSURL *)url collectionTitle:(NSString *)collectionTitle completionHandler:(void (^)(BOOL isSuccess, NSString * _Nonnull ))completionHandler {
    
    __weak typeof(self)weakSelf = self;
    [self saveVideoToSystemWithUrl:url
                 completionHandler:^(BOOL success, NSError *error, NSString *assetUrlLocalIdentifier) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (success) {
            [strongSelf saveAssetToCustomCollection:collectionTitle
                               assetLocalIdentifier:assetUrlLocalIdentifier
                                  completionHandler:completionHandler];
        }else{
            [self executeMainForSafe:^{
                if (completionHandler) {
                    completionHandler(NO, error.localizedDescription);
                }
            }];
        }
    }];

}

+ (void)writeImageToAbulmWithImage:(UIImage *)image completionHandler:(void (^)(BOOL, NSString * _Nonnull))completionHandler {
    [self writeImageToAbulmWithImage:image
                     collectionTitle:nil
                   completionHandler:completionHandler];
}

+ (void)writeImageToAbulmWithImage:(UIImage *)image collectionTitle:(NSString *)collectionTitle completionHandler:(void (^)(BOOL isSuccess, NSString * _Nonnull ))completionHandler {
    
    __weak typeof(self)weakSelf = self;
    [self saveImageToSystemWithImage:image
                   completionHandler:^(BOOL success, NSError *error, NSString *assetImageLocalIdentifier) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (success){
            [strongSelf saveAssetToCustomCollection:collectionTitle
                               assetLocalIdentifier:assetImageLocalIdentifier
                                  completionHandler:completionHandler];
        }else{
            [self executeMainForSafe:^{
                if (completionHandler) {
                    completionHandler(NO, error.localizedDescription);
                }
            }];
        }
    }];
}

/// 添加资源到自定义相册
+ (void)saveAssetToCustomCollection:(NSString * _Nullable)collectionTitle assetLocalIdentifier:(NSString *)assetLocalIdentifier completionHandler:(void (^)(BOOL isSuccess, NSString * _Nonnull error))completionHandler {
    // 获得相簿
    __weak typeof(self)weakSelf = self;
    [self getAssetCollection:collectionTitle
                    callBack:^(PHAssetCollection * _Nullable assetCollection) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (assetCollection){
            [strongSelf addCameraAssetToAlbum:assetLocalIdentifier
                              assetCollection:assetCollection
                            completionHandler:^(BOOL success, NSError *error) {
                
                [self executeMainForSafe:^{
                    if (completionHandler) {
                        completionHandler(success, error.localizedDescription);
                    }
                }];
            }];
        }else{
            [self executeMainForSafe:^{
                if (completionHandler) {
                    completionHandler(NO, @"获取相册失败");
                }
            }];
        }
    }];
}

/// 保存图片资源到系统相册
+ (void)saveImageToSystemWithImage:(UIImage *)image completionHandler:(void(^)(BOOL success, NSError *error,NSString *assetImageLocalIdentifier))completionHandler {
    
    __block NSString *assetImageLocalIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //保存图片A到"相机胶卷"中
        if (@available(iOS 9.0, *)) {
            assetImageLocalIdentifier = [PHAssetCreationRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
        }
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        completionHandler(success,error,assetImageLocalIdentifier);
    }];
}

/// 保存视频资源到系统相册
+ (void)saveVideoToSystemWithUrl:(NSURL *)url completionHandler:(void(^)(BOOL success, NSError *error,NSString *assetUrlLocalIdentifier))completionHandler {
    
    __block NSString *assetUrlLocalIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //保存图片A到"相机胶卷"中
        if (@available(iOS 9.0, *)) {
            assetUrlLocalIdentifier = [PHAssetCreationRequest creationRequestForAssetFromVideoAtFileURL:url].placeholderForCreatedAsset.localIdentifier;
        }
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        completionHandler(success, error, assetUrlLocalIdentifier);
    }];
}

/// 添加相机资源到自定义相册
+ (void)addCameraAssetToAlbum:(NSString *)assetLocalIdentifier assetCollection:(PHAssetCollection *)assetCollection completionHandler:(void(^)(BOOL success, NSError *error))completionHandler {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 添加"相机胶卷"中的资源A到"相簿"D中，获取图片
        PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetLocalIdentifier] options:nil].lastObject;
        // 添加图片到相簿中的请求
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        // 添加图片到相簿
        [request insertAssets:@[asset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        completionHandler(success, error);
    }];
}

///获取自定义相册
+ (void)getAssetCollection:(NSString * _Nullable)collectionTitle callBack:(void(^)(PHAssetCollection * __nullable assetCollection))callBack {
    
    if (!collectionTitle || collectionTitle.length == 0) {
        collectionTitle = OBJC_PROJECT_NAME;
    }
    
    /// 查找相册
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *assetCollection in assetCollections) {
        if ([assetCollection.localizedTitle isEqualToString:collectionTitle]) {
            callBack(assetCollection);
            return ;
        }
    }
    
    /// 创建相册
    NSError *error = nil;
    __block NSString *assetCollectionLocalIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        assetCollectionLocalIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:collectionTitle].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    if (error){
        callBack(nil);
    }else{
        PHAssetCollection *assetCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionLocalIdentifier] options:nil].lastObject;
        callBack(assetCollection);
    }
}

+ (NSString *)convertToUppercaseNumbers:(double)number {
    
    // 首先转化成标准格式 “200.23”，为了后面操作不报错
    NSString *numberStr = [NSString stringWithFormat:@"%.2f",number];
    NSMutableString *tempStr = [[NSMutableString alloc] initWithString: numberStr];
    // 位
    NSArray *carryArr1 = @[
                           @"元",
                           @"拾",
                           @"佰",
                           @"仟",
                           @"万",
                           @"拾",
                           @"佰",
                           @"仟",
                           @"亿",
                           @"拾",
                           @"佰",
                           @"仟",
                           @"兆",
                           @"拾",
                           @"佰",
                           @"仟"
                        ];
    NSArray *carryArr2 = @[
        @"分",
        @"角"
    ];
    // 数字
    NSArray *numArr = @[
                        @"零",
                        @"壹",
                        @"贰",
                        @"叁",
                        @"肆",
                        @"伍",
                        @"陆",
                        @"柒",
                        @"捌",
                        @"玖"
                    ];
    
    NSArray *temarr = [tempStr componentsSeparatedByString:@"."];
    // 小数点前的数值字符串
    NSString *firstStr = [NSString stringWithFormat:@"%@",temarr[0]];
    // 小数点后的数值字符串
    NSString *secondStr = [NSString stringWithFormat:@"%@",temarr[1]];
    
    // 是否拼接了“零”，做标记
    bool zero = NO;
    // 拼接数据的可变字符串
    NSMutableString *endMStr = [[NSMutableString alloc] init];
    
    // 首先遍历firstStr，从最高位往个位遍历，高位----->个位
    for(int i = (int)firstStr.length; i > 0; i--) {
        // 取最高位数
        NSInteger MyData = [[firstStr substringWithRange:NSMakeRange(firstStr.length - i, 1)] integerValue];
        if ([numArr[MyData] isEqualToString:@"零"]) {
            if ([carryArr1[i - 1] isEqualToString:@"万"] ||
                [carryArr1[i - 1] isEqualToString:@"亿"] ||
                [carryArr1[i - 1] isEqualToString:@"元"] ||
                [carryArr1[i - 1] isEqualToString:@"兆"]) {
                // 去除有“零万”
                if (zero) {
                    endMStr = [NSMutableString stringWithFormat:@"%@", [endMStr substringToIndex:(endMStr.length - 1)]];
                    [endMStr appendString:carryArr1[i - 1]];
                    zero = NO;
                }else{
                    [endMStr appendString:carryArr1[i - 1]];
                    zero = NO;
                }
                // 去除有“亿万”、"兆万"的情况
                if ([carryArr1[i - 1] isEqualToString:@"万"]) {
                    if ([[endMStr substringWithRange:NSMakeRange(endMStr.length - 2, 1)] isEqualToString:@"亿"]) {
                        endMStr = [NSMutableString stringWithFormat:@"%@",[endMStr substringToIndex:endMStr.length - 1]];
                    }
                    
                    if ([[endMStr substringWithRange:NSMakeRange(endMStr.length - 2, 1)] isEqualToString:@"兆"]) {
                        endMStr = [NSMutableString stringWithFormat:@"%@",[endMStr substringToIndex:endMStr.length - 1]];
                    }
                }
                // 去除“兆亿”
                if ([carryArr1[i - 1] isEqualToString:@"亿"]) {
                    if ([[endMStr substringWithRange:NSMakeRange(endMStr.length - 2, 1)] isEqualToString:@"兆"]) {
                        endMStr = [NSMutableString stringWithFormat:@"%@",[endMStr substringToIndex:endMStr.length - 1]];
                    }
                }
            }else{
                if (!zero) {
                    [endMStr appendString:numArr[MyData]];
                    zero=YES;
                }
            }
        }else{
            [endMStr appendString:numArr[MyData]];
            [endMStr appendString:carryArr1[i - 1]];
            zero = NO;
        }
    }
    
    // 再遍历secondStr 角位----->分位
    if ([secondStr isEqualToString:@"00"]) {
        [endMStr appendString:@"整"];
    }else{
        for(int i = (int)secondStr.length; i > 0; i--) {
            // 取最高位数
            NSInteger MyData = [[secondStr substringWithRange:NSMakeRange(secondStr.length - i, 1)] integerValue];
            [endMStr appendString:numArr[MyData]];
            [endMStr appendString:carryArr2[i - 1]];
        }
    }
    return endMStr;
}

+ (NSString *)stringByTrim:(NSString *)string {
    
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [string stringByTrimmingCharactersInSet:set];
}

@end
