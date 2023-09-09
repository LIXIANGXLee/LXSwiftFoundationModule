//
//  UIImage+add.m
//  LXSwiftFoundationModule
//
//  Created by Mac on 2021/9/4.
//  Copyright © 2021 李响. All rights reserved.
//

#import "UIImage+add.h"

#import <LXSwiftFoundation-Swift.h>
@interface LXBundleImage : NSObject
+ (LXBundleImage *)shared;
- (LXObjcConvenienceBundle *)bundle;
@end

@implementation LXBundleImage
static LXBundleImage *instance;
+ (LXBundleImage *)shared {
static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}
- (LXObjcConvenienceBundle *)bundle {
    NSString *bundlePath = [NSBundle bundleForClass:self.class].bundlePath;
    return [[LXObjcConvenienceBundle alloc] initWithBundlePath:bundlePath bundleName:@"" path:nil];
}
@end
@implementation UIImage (add)

+ (nullable UIImage *)imageName:(NSString *)imageName path:(NSString *)path {
    return [[LXBundleImage shared].bundle imageNamed:imageName path:path];
}

+ (nullable UIImage *)imageName:(NSString *)imageName {
    return [[LXBundleImage shared].bundle imageNamed:imageName path:@""];
}

@end
