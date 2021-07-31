//
//  LXSwiftQueue.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/10/3.
//  Copyright © 2020 李响. All rights reserved.
//
///  Data structure Queue

import UIKit

public class LXSwiftQueue<Element> {
    
    /// 链表
    private var list = LXObjcLinkedList()
}

extension LXSwiftQueue {
    
    /// 入队列一个元素
    public func enQueue(_ element: Element) {
        list.add(element)
    }
    
    /// 出队列一个元素
    public func deQueue() -> Element? {
        if isEmpty() {
            return nil
        } else {
            return list.remove(0) as? Element
        }
    }
    
    /// 获取队列第一个元素
    public func front() -> Element? {
        if isEmpty() {
            return nil
        } else {
            return list.get(0) as? Element
        }
    }
    
    /// 清空队列所有元素
    public func clear() {
        list.clear()
    }
    
    /// 获取队列元素的个数
    public func size() -> Int {
        return Int(list.size())
    }
    
    /// 判断队列是否为空
    public func isEmpty() -> Bool {
        return list.isEmpty()
    }
}

