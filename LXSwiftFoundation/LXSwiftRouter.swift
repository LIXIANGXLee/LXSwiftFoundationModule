//
//  LXRouter.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/4/28.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

//MARK: - router struct
public struct LXSwiftRouter {
    
    /// regist call back method
    public typealias CallInfoBack = (([String: Any?]?) -> Any?)
    
    /// open  call back method
    public typealias CallBack = ((Any?) -> Void)
    
    /// DispatchSemaphore
    private static let semaphore = DispatchSemaphore(value: 1)
    
    ///router array
    private static var routers = [String : LXSwiftRouter.CallInfoBack]()
    
}

// MARK: - public
extension LXSwiftRouter {
    
    ///register router
    ///
    /// - Parameters:
    ///   - urlStr:  url name, for example："http://home/bus"
    ///   - callInfoBack:  call back method
    public static func regist(with urlStr: String?,
                              callInfoBack: LXSwiftRouter.CallInfoBack?)
    {
        guard let url = urlStr,
            url.hasPrefix("http://"),
            let callBack = callInfoBack  else { return  }
        
        self.semaphore.wait()
        routers[url] = callBack
        self.semaphore.signal()
    }
    
    /// trigger event
    ///
    /// - Parameters:
    ///   - urlStr:  url  url name, for example："http://home/bus"
    ///   - paras:   call back method
    public static func open(with urlStr: String?,
                            paras:[String:Any?]? = nil,
                            callBack: LXSwiftRouter.CallBack? = nil)
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
    ///   - eventName: url  url name, for example："http://home/bus"
    ///   - return result
    public static func  object(for urlStr: String?) -> Any? {
        guard let url = urlStr,
            url.hasPrefix("http://") else { return nil }
        
        return routers[url]?(nil)
    }
    
    ///remove router
    ///
    /// - Parameters:
    ///   - urlStr: url  url name, for example："http://home/bus"
    @discardableResult
    public static func remove(with urlStr: String?) -> LXSwiftRouter.CallInfoBack? {
        guard let url = urlStr,
            url.hasPrefix("http://") else { return nil }
        
        self.semaphore.wait()
        let callInfoBack = routers.removeValue(forKey: url)
        self.semaphore.signal()
        return callInfoBack
    }
    
    ///deregister
    public static func deregister() {
        self.semaphore.wait()
        routers.removeAll()
        self.semaphore.signal()
    }
    
}
