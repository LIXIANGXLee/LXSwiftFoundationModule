//
//  UIColor+LXObjcAdd.h
//  LXSwiftFoundation
//
//  Created by 李响 on 2016/8/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (LXObjcAdd)

+ (nullable UIColor *)lx_colorWithHexString:(NSString *)hexStr;

+ (UIColor *)lx_colorWithRGB:(uint32_t)rgbValue;
+ (UIColor *)lx_colorWithRGBA:(uint32_t)rgbaValue;
+ (UIColor *)lx_colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
