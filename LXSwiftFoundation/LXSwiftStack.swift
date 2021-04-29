//
//  LXSwiftStack.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/10/3.
//  Copyright © 2020 李响. All rights reserved.
//
///  Data structure stack

import UIKit

public struct LXSwiftStack<Element> {
    
    /// Element set
    private var list: [Element]
    
    /// NSLock
    private let lock = NSLock()
    public init() {
        list = [Element]()
    }
}

extension LXSwiftStack {
    
    ///Put an element on the stack
    public mutating func push(_ element: Element) {
        lock.lock()
        defer { lock.unlock() }
        list.append(element)
    }
    
    ///get and remove Last element of the stack
    public mutating func pop() -> Element?{
        lock.lock()
        defer { lock.unlock() }
        let element = list.removeLast()
        return element
    }
    
    ///Empty stack elements and  return list
    @discardableResult
    public mutating func clear() -> ([Element]) {
        lock.lock()
        defer { lock.unlock() }
        list.removeAll()
        return list
    }
    
    ///Number of stack elements
    public func size() -> Int {
        lock.lock()
        defer { lock.unlock() }
        let count = list.count
        return count
    }
    
    ///Is the stack element empty
    public func isEmpty() -> Bool {
        lock.lock()
        defer { lock.unlock() }
        let isisEmpty = list.isEmpty
        return isisEmpty
    }
}
