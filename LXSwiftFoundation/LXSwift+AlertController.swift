//
//  LXSwift+AlertController.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/4/30.
//

import UIKit

public extension LXSwiftBasics where Base: UIAlertController{

    /// 便捷添加Action
    @discardableResult
    func action(_ title: String, style: UIAlertAction.Style = .`default`,
                      _ handle: ((UIAlertAction) -> Void)? = nil)
    -> UIAlertController {
        let action = UIAlertAction(title: title, style: style, handler: handle)
        base.addAction(action)
        return base
    }
}
