//
//  ViewController.swift
//  LXSwiftFoundationModule
//
//  Created by XL on 2020/9/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import LXSwiftFoundation

class ViewController: UIViewController {
    var  objc : LXObjcThreadActive! = nil
    //隐藏状态栏
     
    override var prefersStatusBarHidden: Bool {
        
        return true
     
    }
    
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.red
        
        var btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.orange
        btn.frame = CGRect(x: 100, y: 100, width: 260, height: 100)
        btn.lx.y = 20

        btn.setTitle("首页tab_center", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.setImage(UIImage(named: "tab_center"), for: .normal)
//        btn.lx.horizontalCenterImageAndTitle(space: 20)
        btn.lx.verticalCenterImageAndTitle(space: 30, isLeftImage: false)
        view.addSubview(btn)
      }
    
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let vc = TestViewController()

        self.navigationController?.pushViewController(vc, animated:true)
        
    }
}

