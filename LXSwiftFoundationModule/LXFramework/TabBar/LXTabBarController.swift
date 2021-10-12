//
//  LXTabBarController.swift
//  LXSwiftFoundationModule
//
//  Created by 李响 on 2021/9/24.
//  Copyright © 2021 李响. All rights reserved.
//

import UIKit

class LXTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}

extension LXTabBarController {
    
    /// 添加控制器
   fileprivate func setupChildVC(vc: UIViewController,
                                 naviType: UINavigationController.Type = LXNavigationController.self,
                                 preload: Bool = false) {
        let nav = naviType.init(rootViewController: vc)
        if preload { vc.view.backgroundColor = vc.view.backgroundColor }
        addChild(nav)
    }

}
