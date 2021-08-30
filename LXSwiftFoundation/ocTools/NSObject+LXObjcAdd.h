//
//  NSObject+LXObjcAdd.h
//  LXSwiftFoundation
//
//  Created by Mac on 2021/8/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LXObjcAdd)

/// 方法交换 主要是交换方法的实现 method_getImplementation
+ (void)lx_swizzleMethod:(SEL)originSel withNewMethod:(SEL)dstSel;

/// 是否属于Foundation里的类 [NSURL class],[NSDate class],[NSValue class],[NSData class],[NSError class],[NSArray class],[NSDictionary class],[NSString class],[NSAttributedString class]
+ (BOOL)lx_isClassFromFoundation;

/// 是否为系统类
+ (BOOL)lx_isSystemClass;

/// 获取类的所有成员变量名字
+ (NSArray<NSString *> *)lx_getAllIvarNames;

/// 获取类的所有方法名字
+ (NSArray<NSString *> *)lx_getAllMethodNames;

@end

NS_ASSUME_NONNULL_END
