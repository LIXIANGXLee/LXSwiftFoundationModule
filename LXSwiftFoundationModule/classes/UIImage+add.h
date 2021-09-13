//
//  UIImage+add.h
//  LXSwiftFoundationModule
//
//  Created by Mac on 2021/9/4.
//  Copyright © 2021 李响. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (add)

/// 加载图片资源 bundle里的资源用于私有库开发神器
+ (nullable UIImage *)imageName:(NSString *)imageName path:(NSString *)path;

/// 加载图片资源 bundle里的资源用于私有库开发神器
+ (nullable UIImage *)imageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
