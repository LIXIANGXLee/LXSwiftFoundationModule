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
    
    /// 链表
    private var list = LXObjcLinkedList()
}

extension LXSwiftStack {
    
    /// 入栈一个元素
    public func push(_ element: Element) {
        list.add(element)
    }
    
    /// 出栈一个数据
    public func pop() -> Element? {
        if isEmpty() {
            return nil
        } else {
            return list.remove(self.size() - 1) as? Element
        }
    }
    
    /// 清空栈所有数据
    public func clear(){
        list.clear()
    }
    
    /// 栈元素个数
    public func size() -> Int32 {
        return list.size()
    }
    
    /// 判断栈是否为空
    public func isEmpty() -> Bool {
        return list.isEmpty()
    }
    
}
