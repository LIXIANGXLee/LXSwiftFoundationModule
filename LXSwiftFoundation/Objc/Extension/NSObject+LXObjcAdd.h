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

/// 获取类的所有类方法名字
+ (NSArray<NSString *> *)lx_getAllClassMethodNames;

/// 判断实例方法和类方法是否响应，如果是类调用则是判断是否响应类方法，实例对象调用则是判断是否响应对象方法，注意⚠️，类也是能掉此方法的，不理解的自己看一下isa指针问题就懂了
- (BOOL)lx_respondsToSelector:(SEL)sel;

/// 判断是否响应实例对象
+ (BOOL)lx_instancesRespondToSelector:(SEL)sel;

/// 获取实例方法的实现
+ (IMP)lx_instanceMethodForSelector:(SEL)sel;

/// 判断是否为子类
+ (BOOL)lx_isSubclassOfClass:(Class)aClass;

@end

NS_ASSUME_NONNULL_END
