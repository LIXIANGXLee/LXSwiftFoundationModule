//
//  ViewController.swift
//  LXSwiftFoundationModule
//
//  Created by XL on 2020/9/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import LXSwiftFoundation
import Photos


class ViewController: UIViewController {
    
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registSwiftCell(LXTableViewViewCell.self)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }else{
            tableView.translatesAutoresizingMaskIntoConstraints = false
        }
        return tableView
    }()
    
     override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = CGRect(x: 0, y: LXSwiftApp.navbarH, width: LXSwiftApp.screenW, height: LXSwiftApp.screenH - LXSwiftApp.navbarH - LXSwiftApp.touchBarH)

        view.addSubview(tableView)
    
      }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        
    }
    
    
    func protocolUIShow() {
        let config = LXSwiftModalConfig()
        config.isDismissBg = false
        config.contentMidViewH = SCALE_IP6_WIDTH_TO_WIDTH(260)
        config.titleFont = UIFont.lx.font(withMedium: 16)
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

       }
        
        let modal = LXSwiftHyperlinksModalController()
        modal.setModa(config, modalItems: [itemCancel,itemTrue]) { (text) -> (Void) in
            print("-=-=-=-=-=\(text)")
        }
        
        let s1 = "《用户服务协议》"
        let s2 = "《隐私政策》"
        let r1 = LXSwiftRegexType(with: s1,
                                  color: UIColor.lx.color(hex: "36acff"),
                                  font: UIFont.systemFont(ofSize: 14),
                                  isExpression: false)
        let r2 = LXSwiftRegexType(with: s2,
                                  color: UIColor.lx.color(hex: "36acff"),
                                  font: UIFont.systemFont(ofSize: 14),
                                  isExpression: false)

        let str = "欢迎使用迎使用！我们非常重视您的隐私和个人信息安全。在您使用前，请认真阅读\(s1)及\(s2)，您同意并接受全部条款后方可开始使用。"
        guard let attr = modal.getAttributedString(with: str, textColor: UIColor.lx.color(hex: "666666"), textFont: UIFont.systemFont(ofSize: 14), regexTypes: [r1,r2]) else { return }

        modal.show(with: "温馨提示", content: attr)
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueSwiftReusableCell(indexPath: indexPath) as LXTableViewViewCell

        tableView.roundSwiftSectionCell(cell, forRowAt: indexPath, cornerRadius: 20, backgroundColor: UIColor.red)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: LXSwiftApp.screenW, height: 60))
        tableView.roundSwiftSectionHeader(view, forSection: section, cornerRadius: 30, backgroundColor: UIColor.blue)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: LXSwiftApp.screenW, height: 60))
        tableView.roundSwiftSectionFooter(view, forSection: section, cornerRadius: 30, backgroundColor: UIColor.purple)
        
        
        return view
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    
    }
    
}
