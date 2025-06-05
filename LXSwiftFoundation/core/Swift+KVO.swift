//
//  Swift+KVO.swift
//  Pods
//
//  Created by xrj on 2025/6/5.
//

import Foundation

// KVO 扩展实现
extension SwiftBasics where Base: NSObject {
    /**
     封装 KVO 监听为 Block 形式
     
     - Parameters:
        - keyPath: 要观察的属性路径
        - changeHandler: 值变化时的回调 Block
     - Returns: 可销毁的 Disposable 对象，用于取消监听
     - Note: 使用后需持有返回对象，对象释放时会自动取消监听
     */
   public func observeKeyPath(_ keyPath: String,
                        changeHandler: @escaping (_ change: [NSKeyValueChangeKey: Any]?) -> Void) -> SwiftDisposable {
        let observer = KVOObserver(target: base, keyPath: keyPath, changeHandler: changeHandler)
        
        // 关联对象存储观察者
        var observers = objc_getAssociatedObject(base, &swiftObserverKey) as? [KVOObserver] ?? []
        observers.append(observer)
        objc_setAssociatedObject(base, &swiftObserverKey, observers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return observer
    }
}

// 关联对象 Key
private var swiftObserverKey: UInt8 = 0

// 定义可销毁对象的协议
public protocol SwiftDisposable {
    func dispose()
}

// 封装 KVO 观察者的内部类
private final class KVOObserver: NSObject, SwiftDisposable {
    weak var target: NSObject?  // 弱引用避免循环引用
    let keyPath: String
    var changeHandler: ((_ change: [NSKeyValueChangeKey: Any]?) -> Void)?
    
    init(target: NSObject, keyPath: String, changeHandler: @escaping (_ change: [NSKeyValueChangeKey: Any]?) -> Void) {
        self.target = target
        self.keyPath = keyPath
        self.changeHandler = changeHandler
        
        super.init()
        // 注册 KVO 监听
        target.addObserver(self, forKeyPath: keyPath, options: [.new, .old], context: nil)
    }
    
    // KVO 回调处理
    override func observeValue(forKeyPath keyPath: String?,
                              of object: Any?,
                              change: [NSKeyValueChangeKey: Any]?,
                              context: UnsafeMutableRawPointer?) {
        guard keyPath == self.keyPath else { return }
        changeHandler?(change)  // 执行回调 Block
    }
    
    // 销毁方法
    func dispose() {
        target?.removeObserver(self, forKeyPath: keyPath)
        changeHandler = nil  // 断开引用
    }
    
    deinit {
        dispose()  // 自动清理资源
    }
}

