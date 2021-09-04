//
//  NSString+LXObjcSize.h
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/8/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (LXObjcAdd)

/// 给出宽度计算size
- (CGSize)lx_sizeWithPreferWidth:(CGFloat)width font:(UIFont *)font;
- (CGSize)lx_sizeWithPreferWidth:(CGFloat)width attribute:(NSDictionary *)attr;

/// 给出高度计算size
- (CGSize)lx_sizeWithpreferHeight:(CGFloat)height font:(UIFont *)font;
- (CGSize)lx_sizeWithpreferHeight:(CGFloat)height attribute:(NSDictionary *)attr;

/// 根据文字内容动态计算UILabel高度 lineSpacing 行间距
- (CGSize)lx_sizeWithWidth:(CGFloat)maxWidth withTextFont:(UIFont *)font withLineSpacing:(CGFloat)lineSpacing;

/// 根据文字内容动态计算UILabel宽高 lineSpacing  行间距
- (CGSize)lx_sizeWithHeight:(CGFloat)maxHeight withTextFont:(UIFont *)font withLineSpacing:(CGFloat)lineSpacing;

/// 判断字符是否包含字符串
- (BOOL)lx_containsString:(NSString *)string;

/// 首字母大写
- (NSString *)lx_firstCharUpper;

/// 首字母小写
- (NSString *)lx_firstCharLower;

/// 驼峰转下划线
- (NSString *)lx_underlineFromCamel;

/// 下划线转驼峰
- (NSString *)lx_camelFromUnderline;

/// string -> id 类型
- (nullable id)lx_jsonStringToId;

/// id -> string
- (nullable NSString *)lx_jsonStringWithId:(id)objc;

/// cache 沙盒路径及创建
- (NSString *)lx_cacheFile;

/// document 路径及创建
- (NSString *)lx_documentFile;

/// 汉字的拼音
+ (NSString *)lx_chineseToPinyin;

@end

NS_ASSUME_NONNULL_END
