//
//  KVOViewController.swift
//  LXSwiftFoundationModule
//
//  Created by xrj on 2025/6/5.
//  Copyright © 2025 李响. All rights reserved.
//

import UIKit

class KVOViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        

        let user = User()

        // 开始监听x
        let disposable = user.lx.observeKeyPath("name") { change in
            print("值发生变化！")
            print("旧值: \(change?[.oldKey] as? String ?? "nil")")
            print("新值: \(change?[.newKey] as? String ?? "nil")\n")
        }

        // 触发变化
        user.name = "张三"
        user.name = "李四"

        // 取消监听（若不需要提前取消，可忽略此操作）
        disposable.dispose()

    }
    

}

class User: NSObject {
    @objc dynamic var name: String = "初始名字" // 必须标记 @objc dynamic
}
