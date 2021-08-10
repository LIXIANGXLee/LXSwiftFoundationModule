//
//  NSString+LXObjcSize.m
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/8/9.
//

#import "NSString+LXObjcAdd.h"

@implementation NSString (LXObjcAdd)

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

- (BOOL)lx_containsString:(NSString *)string {
    if (string == nil) return NO;
    return [self rangeOfString:string].location != NSNotFound;
}

- (NSString *)lx_firstCharLower {
    
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    [string appendString:[NSString stringWithFormat:@"%c", [self characterAtIndex:0]].lowercaseString];
    if (self.length >= 2) [string appendString:[self substringFromIndex:1]];
    return string;
}

- (NSString *)lx_firstCharUpper {
    
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    [string appendString:[NSString stringWithFormat:@"%c", [self characterAtIndex:0]].uppercaseString];
    if (self.length >= 2) [string appendString:[self substringFromIndex:1]];
    return string;
}

- (NSString *)lx_underlineFromCamel {
    
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    for (NSUInteger i = 0; i<self.length; i++) {
        unichar c = [self characterAtIndex:i];
        NSString *cString = [NSString stringWithFormat:@"%c", c];
        NSString *cStringLower = [cString lowercaseString];
        if ([cString isEqualToString:cStringLower]) {
            [string appendString:cStringLower];
        } else {
            [string appendString:@"_"];
            [string appendString:cStringLower];
        }
    }
    return string;
}

- (NSString *)lx_camelFromUnderline {
    
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    NSArray *cmps = [self componentsSeparatedByString:@"_"];
    for (NSUInteger i = 0; i<cmps.count; i++) {
        NSString *cmp = cmps[i];
        if (i && cmp.length) {
            [string appendString:[NSString stringWithFormat:@"%c", [cmp characterAtIndex:0]].uppercaseString];
            if (cmp.length >= 2) [string appendString:[cmp substringFromIndex:1]];
        } else {
            [string appendString:cmp];
        }
    }
    return string;
}

- (id)lx_jsonStringToId {
    if (!self || self.length == 0) { return nil; }
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

- (NSString *)lx_documentFile {
    
    NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [self createFilePath:[docsdir stringByAppendingPathComponent:self]];
}

- (NSString *)lx_cacheFile {
    
  NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  return  [self createFilePath:[docsdir stringByAppendingPathComponent:self]];
}

- (NSString *)createFilePath:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) ) {
        // 在 Document 目录下创建一个 head 目录
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filePath;
}

/// 汉字的拼音
+ (NSString *)lx_chineseToPinyin {
    NSMutableString *mString = [self mutableCopy];
    CFStringTransform(( CFMutableStringRef)mString, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)mString, NULL, kCFStringTransformStripDiacritics, NO);
    return [mString stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@end
