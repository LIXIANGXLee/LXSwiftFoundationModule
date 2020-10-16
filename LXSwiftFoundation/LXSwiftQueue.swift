//
//  LXSwiftQueue.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/10/3.
//  Copyright © 2020 李响. All rights reserved.
//
///  Data structure Queue

import UIKit

public struct LXSwiftQueue<Element> {
    
    /// Element set
    private var list: [Element]
    
    /// NSLock
    private let lock = NSLock()
    
    public init() {
        list = [Element]()
    }
}

extension LXSwiftQueue {
    
    ///Put an element on the Queue
    public mutating func enQueue(_ element: Element) {
        lock.lock()
        defer { lock.unlock() }
        list.append(element)
    }
    
    ///get and remove first element of the Queue
    public mutating func deQueue() -> Element?{
        lock.lock()
        defer { lock.unlock() }
        let element = list.removeFirst()
        return element
    }
    
    ///get first element of the Queue
    public func front() -> Element?{
        lock.lock()
        defer { lock.unlock() }
        let element = list.first
        return element
    }
    
    ///Empty Queue elements and  return list
    @discardableResult
    public mutating func clear() -> ([Element]) {
        lock.lock()
        defer { lock.unlock() }
        list.removeAll()
        return list
    }
    
    ///Number of Queue elements
    public func size() -> Int {
        lock.lock()
        defer { lock.unlock() }
        let count = list.count
        return count
    }
    
    ///Is the Queue element empty
    public func isEmpty() -> Bool {
        lock.lock()
        defer { lock.unlock() }
        let isisEmpty = list.isEmpty
        return isisEmpty
    }
    
}

