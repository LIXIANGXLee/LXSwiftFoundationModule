//
//  UIColor+LXObjcAdd.h
//  LXSwiftFoundation
//
//  Created by 李响 on 2016/8/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (LXObjcAdd)
+ (nullable UIColor *)colorWithHexString:(NSString *)hexStr;

+ (UIColor *)colorWithRGB:(uint32_t)rgbValue;
+ (UIColor *)colorWithRGBA:(uint32_t)rgbaValue;
+ (UIColor *)colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
