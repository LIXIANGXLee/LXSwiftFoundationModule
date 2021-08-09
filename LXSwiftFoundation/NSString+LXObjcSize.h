//
//  NSString+LXObjcSize.h
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/8/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (LXObjcSize)

- (CGSize)lx_sizeWithPreferWidth:(CGFloat)width font:(UIFont *)font;
- (CGSize)lx_sizeWithPreferWidth:(CGFloat)width attribute:(NSDictionary *)attr;

- (CGSize)lx_sizeWithpreferHeight:(CGFloat)height font:(UIFont *)font;
- (CGSize)lx_sizeWithpreferHeight:(CGFloat)height attribute:(NSDictionary *)attr;

@end

NS_ASSUME_NONNULL_END
