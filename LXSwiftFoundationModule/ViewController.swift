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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let v = LXSwiftButton(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
//        v.layer.cornerRadius = 30
//        v.clipsToBounds = true
//        view.addSubview(v)
//        v.lx.setGradientLayer(with: [UIColor.lx.color(hex: "333333")!.cgColor, UIColor.lx.color(hex: "FFFFFF")!.cgColor])
//
//
//        let str = "dfhv"
//
//        print("\(str.lx.subString(with: 3..<3))")
//        print("\(str.lx.substring(from: 4))")
//        print("\(str.lx.substring(to: 0))")
//
//        print("\(str.lx.md5)")
//        print("===\(UIDevice.lx.isPad)")
//        print("===\(UIDevice.lx.isPhone)")
//        print("===\(Bundle.lx.bundleVersion ?? "")")
//
//        print("-=-=-=\(NSNumber(value: 2).lx.numberFormatter())")
//
  
     
        
        var field = LXSwiftTextView()
        field.frame = CGRect(x: 20, y: 100, width: 300, height: 40)
        field.backgroundColor = UIColor.red
        field.lx.maxLength = 4
        
//        field.placeholder  = "fdfdsagr"
        view.addSubview(field)
        
        field.lx.set(with: "fdfdsfggdgfdvcdbf")
        
        field.text = "dsfhsdkhgkasdjkfjdsafjkdsjvdsjf dsjhvfdvdf"
        

        field.lx.setHandle { (text) in
            print("-=-=-=-=\(text)")
        }
        
        field.lx.updateUI()

//        field.textRectInsert = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
//       print("-=-=--=-=-=\( "0000".lx.containsEmoji)")
        
        
             
             let imgview = LXSwiftButtonView(frame: CGRect(x: 10, y: 200, width: 300, height: 200))
             imgview.contentMode = .scaleAspectFit
             imgview.backgroundColor = UIColor.blue
             imgview.isUserInteractionEnabled = true
             view.addSubview(imgview)
        
             imgview.lx.set(title: "haha", image: UIImage(named: "0gO3")!)
        

             imgview.lx.set(titleCallBack: { (rect) -> (CGRect) in
                return CGRect(x: (rect.width - 40) * 0.5, y: 10, width: 40, height: 40)
            }) { (rect) -> (CGRect) in
                return CGRect(x: 0, y: 60, width: rect.width, height: 40)

            }
               
            imgview.lx.setHandle { (button) in
                  print("====\(button)")

            }
  
    }
 


}

extension String {
  
    func qq()  {
    }
}
