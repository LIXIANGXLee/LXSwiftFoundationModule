//
//  LXSwiftQueue.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/10/3.
//  Copyright © 2020 李响. All rights reserved.
//
///  Data structure Queue 队列数据结构

import UIKit

public class LXSwiftQueue<Element> {
    
    /// 链表
    private var list = LXObjcLinkedList()
    
    /// 锁 （解决异步线程资源抢占问题）
    private var lock = NSLock()
}

extension LXSwiftQueue {
    
    /// 入队列一个元素
    public func enQueue(_ element: Element) {
        lock.lock()
        defer { lock.unlock() }
        list.add(element)
    }
    
    /// 出队列一个元素
    public func deQueue() -> Element? {
        lock.lock()
        defer { lock.unlock() }
        if isEmpty() {
            return nil
        } else {
            return list.remove(0) as? Element
        }
    }
    
    /// 获取队列第一个元素
    public func front() -> Element? {
        lock.lock()
        defer { lock.unlock() }
        if isEmpty() {
            return nil
        } else {
            return list.get(0) as? Element
        }
    }
    
    /// 清空队列所有元素
    public func clear() {
        lock.lock()
        defer { lock.unlock() }
        list.clear()
    }
    
    /// 获取队列元素的个数
    public func size() -> Int {
        lock.lock()
        defer { lock.unlock() }
        return Int(list.size())
    }
    
    /// 判断队列是否为空
    public func isEmpty() -> Bool {
        lock.lock()
        defer { lock.unlock() }
        return list.isEmpty()
    }
}

