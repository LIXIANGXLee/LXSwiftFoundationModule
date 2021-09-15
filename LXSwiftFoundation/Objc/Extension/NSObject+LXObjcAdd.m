//
//  NSObject+LXObjcAdd.m
//  LXSwiftFoundation
//
//  Created by Mac on 2021/8/29.
//

#import "NSObject+LXObjcAdd.h"
#import <objc/runtime.h>
#import <CoreData/CoreData.h>
#import "LXObjcUtils.h"

@implementation NSObject (LXObjcAdd)

+ (void)lx_swizzleMethod:(SEL)originSel withNewMethod:(SEL)dstSel {
    Class cls = [self class];
    
    [LXObjcUtils swizzleMethod:originSel withNewMethod:dstSel with:cls];
}

+ (void)lx_swizzleClassMethod:(SEL)originSel withNewClassMethod:(SEL)dstSel {
    Class cls = object_getClass([self class]);

    [LXObjcUtils swizzleClassMethod:originSel withNewClassMethod:dstSel with:cls];
}

/// 是否属于Foundation里的类 [NSURL class],[NSDate class],[NSValue class],[NSData class],[NSError class],[NSArray class],[NSDictionary class],[NSString class],[NSAttributedString class]
+ (BOOL)lx_isClassFromFoundation {
    Class cls = [self class];

    return [LXObjcUtils isClassFromFoundation:cls];
}

/// 是否为系统类
+ (BOOL)lx_isSystemClass {
    Class cls = [self class];
    
    return [LXObjcUtils isSystemClass:cls];
}

/// 获取类的所有成员变量名字
+ (NSArray<NSString *> *)lx_getAllIvarNames {
    Class cls = [self class];
    
    return [LXObjcUtils getAllIvars:cls];
}

/// 获取类的所有方法名字
+ (NSArray<NSString *> *)lx_getAllMethodNames{
    Class cls = [self class];
    
    return [LXObjcUtils getAllMethods:cls];
}

/// 获取类的所有类方法名字
+ (NSArray<NSString *> *)lx_getAllClassMethodNames {
    Class cls = object_getClass([self class]);
    
    return [LXObjcUtils getAllMethods:cls];
}

/// 判断实例方法和类方法是否响应，如果是类调用则是判断是否响应类方法，实例对象调用则是判断是否响应对象方法，注意⚠️，类也是能掉此方法的，不理解的自己看一下isa指针问题就懂了
- (BOOL)lx_respondsToSelector:(SEL)sel {
    Class cls = object_getClass(self);

    return [LXObjcUtils isRespondsToSelector:sel with:cls];
}

/// 判断是否响应实例对象
+ (BOOL)lx_instancesRespondToSelector:(SEL)sel {
    Class cls = [self class];

    return [LXObjcUtils isInstancesRespondToSelector:sel with:cls];
}

+ (BOOL)lx_classRespondToSelector:(SEL)sel {
    Class cls = object_getClass([self class]);
    
    return [LXObjcUtils isClassRespondToSelector:sel with:cls];
}

/// 获取实例方法的实现
+ (IMP)lx_instanceMethodForSelector:(SEL)sel {
    Class cls = [self class];

    return [LXObjcUtils getInstanceMethodForSelector:sel with:cls];
}

+ (IMP)lx_classMethodForSelector:(SEL)sel {
    Class cls = object_getClass([self class]);

    return [LXObjcUtils getClassMethodForSelector:sel with:cls];
}

/// 判断是否为子类
+ (BOOL)lx_isSubclassOfClass:(Class)aClass {
    Class cls = self;
    while (cls != Nil) {
        if (cls == aClass) {
            return YES;
        }
        cls = class_getSuperclass(cls);
    }
    return NO;
}

@end
