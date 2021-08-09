//
//  NSString+LXObjcSize.m
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/8/9.
//

#import "NSString+LXObjcSize.h"

@implementation NSString (LXObjcSize)

- (CGSize)lx_sizeWithPreferWidth:(CGFloat)width font:(UIFont *)font {
    if (!font) { return CGSizeZero; }
    NSDictionary *dict = @{NSFontAttributeName: font};
    return [self lx_sizeWithPreferWidth:width attribute:dict];
}

- (CGSize)lx_sizeWithPreferWidth:(CGFloat)width attribute:(NSDictionary *)attr {
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:attr context:nil];
    CGFloat sizeWidth = ceilf(CGRectGetWidth(rect));
    CGFloat sizeHieght = ceilf(CGRectGetHeight(rect));
    return CGSizeMake(sizeWidth, sizeHieght);
}

- (CGSize)lx_sizeWithpreferHeight:(CGFloat)height font:(UIFont *)font {
    if (!font) { return CGSizeZero; }
    NSDictionary *dict = @{NSFontAttributeName: font};
    return [self lx_sizeWithpreferHeight:height attribute:dict];
}

- (CGSize)lx_sizeWithpreferHeight:(CGFloat)height attribute:(NSDictionary *)attr {
    CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:attr context:nil];
    CGFloat sizeWidth = ceilf(CGRectGetWidth(rect));
    CGFloat sizeHieght = ceilf(CGRectGetHeight(rect));
    return CGSizeMake(sizeWidth, sizeHieght);
}


@end
