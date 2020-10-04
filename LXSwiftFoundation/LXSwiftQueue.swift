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
        list.append(element)
        lock.unlock()
    }
    
    ///get and remove first element of the Queue
    public mutating func deQueue() -> Element?{
        lock.lock()
        let element = list.removeFirst()
        lock.unlock()
        return element
    }
    
    ///get first element of the Queue
    public func front() -> Element?{
        lock.lock()
        let element = list.first
        lock.unlock()
        return element
    }
    
    ///Empty Queue elements and  return list
    @discardableResult
    public mutating func clear() -> ([Element]) {
        lock.lock()
        list.removeAll()
        lock.unlock()
        return list
    }
    
     ///Number of Queue elements
     public func size() -> Int {
        lock.lock()
        let count = list.count
        lock.unlock()
        return count
     }
    
      ///Is the Queue element empty
      public func isEmpty() -> Bool {
        lock.lock()
        let isisEmpty = list.isEmpty
        lock.unlock()
        return isisEmpty
     }
    
}

