//
//  LXSwiftRuntime.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2020/10/16.
//

import Foundation

public func lx_getAssociatedObject<T>(_ object: Any,
                                      _ key: UnsafeRawPointer) -> T? {
    return objc_getAssociatedObject(object, key) as? T
}

public func lx_setRetainedAssociatedObject<T>(_ object: Any,
                                              _ key: UnsafeRawPointer,
                                              _ value: T,
                                              _ policy: objc_AssociationPolicy =
                                                .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
    objc_setAssociatedObject(object, key, value, policy)
}

public func lx_removeAssociatedObjects(_ object: Any) {
    objc_removeAssociatedObjects(object)
}
