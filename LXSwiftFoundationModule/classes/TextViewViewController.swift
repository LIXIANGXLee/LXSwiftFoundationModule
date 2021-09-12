//
//  TextViewViewController.swift
//  LXSwiftFoundationModule
//
//  Created by 李响 on 2021/9/6.
//  Copyright © 2021 李响. All rights reserved.
//

import UIKit
import LXSwiftFoundation

class TextViewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "textView和textField展示"
        self.view.backgroundColor = UIColor.blue
        
        let textView = LXSwiftTextView(frame: CGRect(x: 20, y: 100, width: 260, height: 200))
        self.view.addSubview(textView)
        textView.maxTextLength = 5
        textView.placeholder = "dsds"
        textView.setHandle { (text) in
            print("-=-=-=-=-=-\(text)")
        }
        
        textView.updateTextUI()
        
        
        let textField = LXSwiftTextField(frame: CGRect(x: 20, y: 310, width: 260, height: 100))
        self.view.addSubview(textField)
        textField.textRectInsert = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        textField.maxTextLength = 5
        textField.placeholder = "dsdsds"
        textField.setHandle { (text) in
            print("-=-=-=--------=\(text)")
        }
        
    }
    
}
