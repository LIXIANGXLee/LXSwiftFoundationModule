//
//  LXRouter.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/4/28.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// regist 回调函数
public typealias LXSwiftCallInfoBack = (([String: Any?]?) -> Any?)

/// open 回调函数
public typealias LXSwiftCallBack = ((Any?) -> Void)

public struct LXSwiftRouter {
    
    /// 信号量
    private static let semaphore = DispatchSemaphore(value: 1)

    ///路由集合
    private static var routers = [String : LXSwiftCallInfoBack]()
  
}

// MARK: - 外部调用 扩展
extension LXSwiftRouter {
    
    ///注册路由
    ///
    /// - Parameters:
    ///   - urlStr:  url 类型的名字。例如："http://home/bus"
    ///   - callInfoBack:  回调函数
    public static func regist(with urlStr: String?,
                              callInfoBack: LXSwiftCallInfoBack?)
    {
        guard let url = urlStr,
            url.hasPrefix("http://"),
            routers.keys.contains(url),
            let callBack = callInfoBack  else { return  }
        
        self.semaphore.wait()
        routers[url] = callBack
        self.semaphore.signal()
    }
    
    ///触发事件
    ///
    /// - Parameters:
    ///   - urlStr:  url 类型的名字。例如："http://home/bus"
    ///   - paras:   回调函数参数
    public static func open(with urlStr: String?,
                            paras:[String:Any?]? = nil,
                            callBack: LXSwiftCallBack? = nil)
    {
        guard let url = urlStr,
            url.hasPrefix("http://") else { return  }
        
        if  let callInfoBack =  routers[url] {
            let result = callInfoBack(paras)
            callBack?(result)
        }
    }
    
    ///
    /// - Parameters:
    ///   - eventName:  url 类型的名字。例如："http://home/bus"
    ///   - return 返回值
    public static func  object(for urlStr: String?) -> Any? {
        guard let url = urlStr,
            url.hasPrefix("http://") else { return nil }
        
        return routers[url]?(nil)
    }
    
    ///移出路由
    ///
    /// - Parameters:
    ///   - urlStr:  url 类型的名字。例如："http://home/bus"
    @discardableResult
    public static func remove(with urlStr: String?) -> LXSwiftCallInfoBack? {
        guard let url = urlStr,
            url.hasPrefix("http://") else { return nil }
        
        self.semaphore.wait()
        let callInfoBack = routers.removeValue(forKey: url)
        self.semaphore.signal()
        return callInfoBack
    }
    
    ///销毁路由 （清空所有注册的路由）
    public static func deregister() {
        routers.removeAll()
    }
}
