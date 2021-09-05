//
//  NSObject+LXObjcAdd.m
//  LXSwiftFoundation
//
//  Created by Mac on 2021/8/29.
//

#import "NSObject+LXObjcAdd.h"
#import <objc/runtime.h>
#import <CoreData/CoreData.h>

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

    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList(c, &outCount);
    NSMutableArray *mArr = [NSMutableArray array];
    for (unsigned int i = 0; i < outCount; ++i) {
      Ivar ivar = ivars[i];
      const void *name = ivar_getName(ivar);
      NSString *ivarName = [NSString stringWithUTF8String:name];
        [mArr addObject:ivarName];
    }
    // 释放资源
    free(ivars);
    return mArr;
}

/// 获取类的所有方法名字
+ (NSArray<NSString *> *)lx_getAllMethodNames {
    Class c = [self class];

    unsigned int outCount = 0;
    Method *methods = class_copyMethodList(c, &outCount);
    NSMutableArray *mArr = [NSMutableArray array];
    for (unsigned int i = 0; i < outCount; ++i) {
      Method method = methods[i];
      SEL methodName = method_getName(method);
      [mArr addObject:NSStringFromSelector(methodName)];
    }
    // 释放资源
    free(methods);
    return mArr;
}

@end
