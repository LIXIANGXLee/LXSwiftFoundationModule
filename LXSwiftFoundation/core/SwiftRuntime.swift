//
//  SwiftRuntime.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2020/10/16.
//

import Foundation

/// 取值
public func swift_getAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer) -> T? {
    objc_getAssociatedObject(object, key) as? T
}

/// 赋值
public func swift_setRetainedAssociatedObject<T>(_ object: Any,
                                              _ key: UnsafeRawPointer,
                                              _ value: T,
                                              _ policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
    objc_setAssociatedObject(object, key, value, policy)
}

/// 移除对象存储的所有的值
public func swift_removeAssociatedObjects(_ object: Any) {
    objc_removeAssociatedObjects(object)
}
