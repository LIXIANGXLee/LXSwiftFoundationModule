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
        list.append(element)
        lock.unlock()
    }
    
    ///get and remove Last element of the stack
    public mutating func pop() -> Element?{
        lock.lock()
        let element = list.removeLast()
        lock.unlock()
        return element
    }
    
    ///Empty stack elements and  return list
    @discardableResult
    public mutating func clear() -> ([Element]) {
        lock.lock()
        list.removeAll()
        lock.unlock()
        return list
    }
    
    ///Number of stack elements
    public func size() -> Int {
        lock.lock()
        let count = list.count
        lock.unlock()
        return count
    }
    
    ///Is the stack element empty
    public func isEmpty() -> Bool {
        lock.lock()
        let isisEmpty = list.isEmpty
        lock.unlock()
        return isisEmpty
    }
    
}
