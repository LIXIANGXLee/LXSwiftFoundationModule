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
        
        let textView = SwiftTextView(frame: CGRect(x: 20, y: 100, width: 260, height: 200))
        self.view.addSubview(textView)
        textView.maxTextLength = 5
        textView.placeholder = "dsds"
        textView.placeholderColor = UIColor.red
        textView.textHandler = { (text) in
            SwiftLog.log("-=-=-=-=-=-\(text)")
        }
        
        textView.updateTextUI()
        
        
        let textField = SwiftTextField(frame: CGRect(x: 20, y: 310, width: 260, height: 100))
        self.view.addSubview(textField)
        textField.textRectInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        textField.maxTextLength = 5
        textField.placeholder = "dsdsds"
        textField.textColor = UIColor.blue
        textField.backgroundColor = UIColor.white
        textField.lx.setPlaceholder("dsdsds", color: UIColor.red)
        textField.textHandler =  { (text) in
            SwiftLog.log("-=-=-=--------=\(text)")
        }
        
        let swiftView = SwiftView(frame: CGRect(x: 20, y: 500, width: 260, height: 100))
        swiftView.backgroundColor = UIColor.red
        swiftView.throttleInterval = 1
        self.view.addSubview(swiftView)

        swiftView.handler = {view in
            SwiftLog.log(view)
        }
        
        
        
        
    }
    
}
