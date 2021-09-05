//
//  LXSwiftStack.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/10/3.
//  Copyright © 2020 李响. All rights reserved.
//
///  Data structure stack 栈数据结构

import UIKit

public struct LXSwiftStack<Element> {
    
    /// 链表
    private var list = LXObjcLinkedList()
    
    /// 锁 （解决异步线程资源抢占问题）
    private var lock = NSLock()
}

extension LXSwiftStack {
    
    /// 入栈一个元素
    public func push(_ element: Element) {
        lock.lock()
        defer { lock.unlock() }
        list.add(element)
    }
    
    /// 出栈一个数据
    public func pop() -> Element? {
        lock.lock()
        defer { lock.unlock() }
        if isEmpty() {
            return nil
        } else {
            return list.remove(self.size() - 1) as? Element
        }
    }
    
    /// 清空栈所有数据
    public func clear(){
        lock.lock()
        defer { lock.unlock() }
        list.clear()
    }
    
    /// 栈元素个数
    public func size() -> Int32 {
        lock.lock()
        defer { lock.unlock() }
        return list.size()
    }
    
    /// 判断栈是否为空
    public func isEmpty() -> Bool {
        lock.lock()
        defer { lock.unlock() }
        return list.isEmpty()
    }
    
}
