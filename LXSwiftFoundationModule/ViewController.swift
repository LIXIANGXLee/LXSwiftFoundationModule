//
//  ViewController.swift
//  LXSwiftFoundationModule
//
//  Created by XL on 2020/9/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let str = "dfhv"
        
        
        print("\(str.lx.subString(with: 3..<3))")
        print("\(str.lx.substring(from: 4))")
        print("\(str.lx.substring(to: 0))")

        print("\(str.lx.md5)")
        print("===\(UIDevice.lx.isPad)")
        print("===\(UIDevice.lx.isPhone)")
        print("===\(Bundle.lx.bundleVersion ?? "")")

        
       
        
        
    }
 


}

extension String {
  
    func qq()  {
    }
}
