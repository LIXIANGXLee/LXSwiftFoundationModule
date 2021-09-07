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
    
    Class class = [self class];

    Method originalMethod = class_getInstanceMethod(class, originSel);
    Method swizzledMethod = class_getInstanceMethod(class, dstSel);
    
    // 若已经存在，则添加会失败
    BOOL didAddMethod = class_addMethod(class,
                                        originSel,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    // 若原来的方法并不存在，则添加即可
    if (didAddMethod) {
      class_replaceMethod(class,
                          dstSel,
                          method_getImplementation(originalMethod),
                          method_getTypeEncoding(originalMethod));
    } else {
      method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

/// 是否属于Foundation里的类 [NSURL class],[NSDate class],[NSValue class],[NSData class],[NSError class],[NSArray class],[NSDictionary class],[NSString class],[NSAttributedString class]
+ (BOOL)lx_isClassFromFoundation {
    Class c = [self class];

    /// 属于则直接返回 是属于Foundation的类
    if (c == [NSObject class] || c == [NSManagedObject class]) return YES;
    
    static NSSet *fClasses;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 集合中没有NSObject，因为几乎所有的类都是继承自NSObject，具体是不是NSObject需要特殊判断
        fClasses = [NSSet setWithObjects:
                      [NSURL class],
                      [NSDate class],
                      [NSValue class],
                      [NSData class],
                      [NSError class],
                      [NSArray class],
                      [NSDictionary class],
                      [NSString class],
                      [NSAttributedString class], nil];
    });
    __block BOOL result = NO;
    [fClasses enumerateObjectsUsingBlock:^(Class foundationClass, BOOL *stop) {
        if ([c isSubclassOfClass:foundationClass]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

/// 是否为系统类
+ (BOOL)lx_isSystemClass {
    Class c = [self class];
    
    const char * _Nonnull name = class_getName(c);
    if (!name) { return NO; }
    NSString *className = [NSString stringWithCString:name encoding: NSUTF8StringEncoding];

    // 再检查黑名单
    if ([className hasPrefix:@"NS"] ||
        [className hasPrefix:@"_NS"] ||
        [className hasPrefix:@"__NS"] ||
        [className hasPrefix:@"OS_"] ||
        [className hasPrefix:@"CA"] ||
        [className hasPrefix:@"UI"] ||
        [className hasPrefix:@"_UI"]) {
        return true;
    }
    
    return false;
}

/// 获取类的所有成员变量名字
+ (NSArray<NSString *> *)lx_getAllIvarNames {
    Class c = [self class];
    return [LXObjcUtils lx_getAllIvars:c];
}

/// 获取类的所有方法名字
+ (NSArray<NSString *> *)lx_getAllMethodNames{
    Class c = [self class];
    return [LXObjcUtils lx_getAllMethods:c];
}

/// 获取类的所有类方法名字
+ (NSArray<NSString *> *)lx_getAllClassMethodNames {
    Class c = object_getClass([self class]);
    return [LXObjcUtils lx_getAllMethods:c];
}

/// 判断实例方法和类方法是否响应，如果是类调用则是判断是否响应类方法，实例对象调用则是判断是否响应对象方法，注意⚠️，类也是能掉此方法的，不理解的自己看一下isa指针问题就懂了
- (BOOL)lx_respondsToSelector:(SEL)sel {
    if (sel == (SEL)0) { return NO; }
    
    /// 获取类对象或者元类对象
    Class cls = object_getClass(self);
    if (class_respondsToSelector(cls, sel)) {
        return YES;
    }

    /// 判断是否为元类
    if (class_isMetaClass(cls)) {
        return [(Class)self resolveClassMethod: sel];
    } else {
        return [cls resolveInstanceMethod: sel];
    }
}

/// 判断是否响应实例对象
+ (BOOL)lx_instancesRespondToSelector:(SEL)sel {
    if (sel == (SEL)0) { return NO; }

    if (class_respondsToSelector(self, sel)) {
        return YES;
    }
    
    /// 判断是否为元类
    if (class_isMetaClass(self)) {
        return NO;
    } else {
        return [self resolveInstanceMethod: sel];
    }
}

/// 获取实例方法的实现
+ (IMP)lx_instanceMethodForSelector:(_Nonnull SEL)sel {
    if (sel == (SEL)0) { return (IMP)0; }
    return class_getMethodImplementation((Class)self, sel);
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
