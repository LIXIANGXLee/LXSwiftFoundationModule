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

/**
version campare

@param v1 one version
@param v2 two version
@return 0:eque,-1:one small,1:two small
*/
int _compareVersionInSwift(const char * _Nullable v1,
                           const char * _Nullable v2) {
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


@implementation LXObjcUtils

+ (int)getNetWorkType {
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
    return NetworkType;
}

+ (BOOL)isMainThread {
    return [[NSThread currentThread] isMainThread];
}

+ (void)executeOnSafeMian:(void (^)(void))block {
    if([self isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

+ (void)executeOnSafeGlobal:(void (^)(void))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        block();
    });
}

+ (BOOL)isClassFromFoundation:(Class)c {
    
    /// 属于则直接返回 是属于Foundation的类
    if (c == [NSObject class] || c == [NSManagedObject class]) return YES;
    
    static NSSet *fClasses;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 集合中没有NSObject，因为几乎所有的类都是继承自NSObject，具体是不是NSObject需要特殊判断
        fClasses = [NSSet setWithObjects:
                      [NSURL class],
                      [NSDate class],
                      [NSValue class],
                      [NSData class],
                      [NSError class],
                      [NSArray class],
                      [NSDictionary class],
                      [NSString class],
                      [NSAttributedString class], nil];
    });
    __block BOOL result = NO;
    [fClasses enumerateObjectsUsingBlock:^(Class foundationClass, BOOL *stop) {
        if ([c isSubclassOfClass:foundationClass]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

+ (BOOL)isSystemClass:(Class)c {
    const char * _Nonnull name = class_getName(c);
    if (!name) { return NO; }
    
    NSString *className = [NSString stringWithCString:name encoding: NSUTF8StringEncoding];

    // 再检查黑名单
    if ([className hasPrefix:@"NS"] ||
        [className hasPrefix:@"_NS"] ||
        [className hasPrefix:@"__NS"] ||
        [className hasPrefix:@"OS_"] ||
        [className hasPrefix:@"CA"] ||
        [className hasPrefix:@"UI"] ||
        [className hasPrefix:@"_UI"]) {
        return true;
    }
    
    return false;
}

+ (void)swizzleMethod:(SEL)originSel withNewMethod:(SEL)dstSel {
    Class cls = [self class];
    
    // 获取原方法和方法实现
    Method oriMethod = class_getInstanceMethod(cls, originSel);
    IMP oriImp = method_getImplementation(oriMethod);
    const char *oriReturnType = method_getTypeEncoding(oriMethod);
    
    // 获取即将要交换的方法和实现
    Method dstMethod = class_getInstanceMethod(cls, dstSel);
    IMP dstImp = method_getImplementation(dstMethod);
    const char *dstReturnType = method_getTypeEncoding(dstMethod);
    
    // 方法交换
    if (class_addMethod([self class], originSel, dstImp, dstReturnType)) {
        class_replaceMethod(cls, dstSel, oriImp, oriReturnType);
    } else {
        method_exchangeImplementations(oriMethod, dstMethod);
    }
}

+ (void)writeVideoToAbulmWithUrl:(NSURL *)url completionHandler:(void (^)(BOOL, NSString * _Nonnull))completionHandler {
    [self writeVideoToAbulmWithUrl:url
                   collectionTitle:nil
                 completionHandler:completionHandler];
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
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionHandler) {
                    completionHandler(NO, error.localizedDescription);
                }
            });
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
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionHandler) {
                    completionHandler(NO, error.localizedDescription);
                }
            });
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completionHandler) {
                        completionHandler(success, error.localizedDescription);
                    }
                });
            }];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionHandler) {
                    completionHandler(NO, @"获取相册失败");
                }
            });
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
        collectionTitle = [NSBundle mainBundle].infoDictionary[@"CFBundleName"];
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

@end
