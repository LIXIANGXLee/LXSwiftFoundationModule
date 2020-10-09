//
//  TestViewController.swift
//  LXSwiftFoundationModule
//
//  Created by XL on 2020/10/9.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        self.view.addRunLoopObserverOfPerformance()
        self.view.maxTaskPerformedCount = 20
        self.view.addTask {
//           for i in 0..<100 {
//               print("-=-\(i)=-=-=")

//           }
        }
    }
    
    deinit {
        print("=TestViewController=deinit===")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.removeRunLoopObserver()

        self.dismiss(animated: true, completion: nil)
    }
}
