//
//  TestViewController.swift
//  LXSwiftFoundationModule
//
//  Created by XL on 2020/10/9.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import LXSwiftFoundation

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        let label = LXSwiftTextLable()
        label.delegate = self
        view.addSubview(label)
        
        label.viewFrame = CGRect(x: 20, y: 100, width: 300, height: 300)
        let str1 = "本月再充电200度达到黄金会员，立享服务费折查看详情"
    
        
        let type2 = LXSwiftRegexType("([0-9]+\\.[0-9]+)|([0-9]+)", color: UIColor.red, font: UIFont.systemFont(ofSize: 12), isExpression: false)

        let attr1 = LXSwiftRegex.regex(of: str1, textColor: UIColor.lx.color(hex: "333333"), textFont: UIFont.systemFont(ofSize: 12), wordRegexTypes: [type2])
        
        label.attributedText = attr1
         
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
  
        self.present(Test1ViewController(), animated: true, completion: nil)
        
    }
    
    
}


extension TestViewController : LXTextLableDelegate {
    func lxTextLable(_ textView: LXSwiftTextLable, didSelect text: String) {
        print("========\(text)")
    }
}
