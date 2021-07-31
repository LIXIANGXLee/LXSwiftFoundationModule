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
    let linkList = LXObjcLinkedList()

    
     override func viewDidLoad() {
        super.viewDidLoad()
        
        print("===--------======\( 3606.lx.timeToStr)");
        
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
        
        
        
//   protocolUIShow()

        linkList.add("dd")
        print("-=-11=-=-=\(linkList)")
        print("-=-=11-=-=\(linkList.contains("dd"))")

        linkList.add("ww")
        linkList.add("ee")
        print("-=-22=-=-=\(linkList)")

        linkList.insert(1, value: "fd")
        print("-=-=33-=-=\(linkList)")
        print("-=-=33-=-=\(linkList.size())")
        
        linkList.remove(0)
        print("-=-=44-=-=\(linkList)")
        print("-=-=44-=-=\(linkList.get(1))")
        
    }
    
    
    func protocolUIShow() {
        let config = LXSwiftModalConfig()
        config.isDismissBg = false
        config.contentMidViewH = scale_ip6_width(260)
        config.titleFont = UIFont.lx.fontWithMedium(16)
        config.titleColor = UIColor.black
        let itemCancel = LXSwiftItem(title: "不同意",
                                         titleColor: UIColor.blue,
                                         titleFont: UIFont.systemFont(ofSize: 17, weight: .medium))
        {
           
        }
        let itemTrue =  LXSwiftItem(title: "同意",
                                         titleColor: UIColor.blue,
                                        titleFont: UIFont.systemFont(ofSize: 17, weight: .medium))
        {
//            guard let b = Int(Bundle.lx.buildVersion ?? "0") else { return  }
            UserDefaults.standard.setValue(true, forKey: "isProtocolMark")
            UserDefaults.standard.synchronize()
       }
        
        let modal = LXSwiftHyperlinksModalController(config,modalItems:  itemCancel,itemTrue)

        modal.setHandle { (text) -> (Void) in
           
            print("-=-=-=-=-=\(text)")
        }
        
        let s1 = "《用户服务协议》"
        let s2 = "《隐私政策》"
        let r1 = LXSwiftRegexType(s1,
                                  color: UIColor.lx.color(hex: "36acff"),
                                  font: UIFont.systemFont(ofSize: 14),
                                  isExpression: false)
        let r2 = LXSwiftRegexType(s2,
                                  color: UIColor.lx.color(hex: "36acff"),
                                  font: UIFont.systemFont(ofSize: 14),
                                  isExpression: false)

        let str = "欢迎使用美术迎使用！我们非常重视您的隐私和个人信息安全。在您使用相框前，请认真阅读\(s1)及\(s2)，您同意并接受全部条款后方可开始使用。"
        
        guard let attr = modal.getAttributedString(with: str, textColor: UIColor.lx.color(hex: "666666"), textFont: UIFont.systemFont(ofSize: 14), regexTypes: [r1,r2]) else { return }

        modal.show(with: "温馨提示", content: attr)
    }
}

