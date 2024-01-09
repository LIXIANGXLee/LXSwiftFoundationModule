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
    
    private var datas: [[String]] = [[]]
    
    fileprivate lazy var tableView: SwiftTableView = {
        let tableView = SwiftTableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerSwiftCell(cellType: LXTableViewViewCell.self)
        return tableView
    }()
    
    private var switchCallBackKey: Void?
    private var switchCallBacka: Void?
    
     override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "UI展示"
        let _ = TestObjcView()
        datas = [
            [
               "弹窗1",
               "弹窗2",
               "弹窗3",
               "弹窗4",
               "弹窗5",
               "弹窗6",
               "两段式滑动弹窗",
               "戴超链接的弹窗"
           ],
            [
                "wkwebview加载网页，截取长图",
                "textview和textfield"
            ]
        ]

        tableView.frame = CGRect(x: 0,
                                 y: SCREEN_HEIGHT_TO_NAVBARHEIGHT,
                                 width: SCREEN_WIDTH_TO_WIDTH,
                                 height: SCREEN_HEIGHT_TO_HEIGHT - SCREEN_HEIGHT_TO_NAVBARHEIGHT - SCREEN_HEIGHT_TO_TOUCHBARHEIGHT)
         
         LXXXLog(tableView.frame)

        view.addSubview(tableView)
        
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.red
        btn.frame = CGRect(x: SCREEN_WIDTH_TO_WIDTH - 100, y: SCREEN_HEIGHT_TO_NAVBARHEIGHT, width: 60, height: 60)
        view.addSubview(btn)

        btn.addTarget(self, action: #selector(btnClick(_:)), for: UIControl.Event.touchUpInside)
     }
    
    @objc func btnClick(_ btn: UIButton) {
        
        let menu = SwiftMenuDownView()
        menu.xType = .right
        menu.animateDuration = 0.25
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 400))
        view.backgroundColor = UIColor.green
        menu.content = view
        menu.show(from: btn)
    
    }
    func showModal() {
        let config = SwiftModalConfig()
        config.isDismissBg = false
        config.contentMidViewH = SCALE_IP6_WIDTH_TO_WIDTH(260)
        config.titleFont = UIFont.lx.font(withMedium: 16)
        config.titleColor = UIColor.black
        let itemCancel = SwiftItem(title: "不同意",
                                         titleColor: UIColor.blue,
                                         titleFont: UIFont.systemFont(ofSize: 17, weight: .medium)) { }
        let itemTrue =  SwiftItem(title: "同意",
                                         titleColor: UIColor.blue,
                                        titleFont: UIFont.systemFont(ofSize: 17, weight: .medium)) {
            let str = Bundle.main.path(forResource: "lxQrCodeVoice", ofType: "wav")
            SwiftUtils.playSound(with: str)
        }
        
        let modal = SwiftHyperlinksModalController()
        modal.setModal(config, modalItems: [itemCancel,itemTrue]) { (text) -> (Void) in
            print("-=-=-=-=-=\(text)")
            
        }
        let r1 = SwiftRegexType(with: "《用户服务协议》",
                                  color: UIColor.lx.color(hex: "36acff"),
                                  font: UIFont.systemFont(ofSize: 14),
                                  isExpression: false)
        let r2 = SwiftRegexType(with: "《隐私政策》",
                                  color: UIColor.lx.color(hex: "36acff"),
                                  font: UIFont.systemFont(ofSize: 14),
                                  isExpression: false)
        let str = "欢迎使用迎使用！我们非常《用户服务协议》重视您《隐私政策》的您同意并接受全部条款后方可开始使用。"
        guard let attr = modal.getAttributedString(with: str, textColor: UIColor.lx.color(hex: "666666"), textFont: UIFont.systemFont(ofSize: 14), regexTypes: [r1,r2]) else { return }
        modal.show(with: "温馨提示", content: attr)
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 50 }
    func numberOfSections(in tableView: UITableView) -> Int { datas.count }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { datas[section].count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueSwiftReusableCell(indexPath: indexPath, as: LXTableViewViewCell.self)
        cell.textStr = datas[indexPath.section][indexPath.row]
        return cell
    }
       
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let menu = SwiftMenuCenterView()
                menu.yType = .midRotate
                let view = UIView(frame: CGRect(x: 0, y: 0, width: 260, height: 400))
                let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
                view1.backgroundColor = UIColor.red
                view.addSubview(view1)
                view.backgroundColor = UIColor.purple
                menu.content = view
                menu.show()
            case 1:
                let menu = SwiftMenuCenterView()
                menu.yType = .top
                let view = UIView(frame: CGRect(x: 0, y: 0, width: 260, height: 400))
                let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
                view1.backgroundColor = UIColor.red
                view.addSubview(view1)
                view.backgroundColor = UIColor.purple
                menu.content = view
                menu.show()
            case 2:
                let menu = SwiftMenuCenterView()
                menu.yType = .mid
                let view = UIView(frame: CGRect(x: 0, y: 0, width: 260, height: 400))
                let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
                view1.backgroundColor = UIColor.red
                view.addSubview(view1)
                view.backgroundColor = UIColor.purple
                menu.content = view
                menu.show()
            case 3:
                let menu = SwiftMenuCenterView()
                menu.yType = .bottom
                let view = UIView(frame: CGRect(x: 0, y: 0, width: 260, height: 400))
                let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
                view1.backgroundColor = UIColor.red
                view.addSubview(view1)
                view.backgroundColor = UIColor.purple
                menu.content = view
                menu.show()
            case 4:
                let menu = SwiftMenuUpView()
                let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH_TO_WIDTH, height: 400))
                view.backgroundColor = UIColor.purple
                menu.content = view
                menu.show()
            case 5:
                let menu = SwiftMenuCenterView()
                menu.yType = .gradual
                let view = UIView(frame: CGRect(x: 0, y: 0, width: 260, height: 400))
                let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
                view1.backgroundColor = UIColor.red
                view.addSubview(view1)
                view.backgroundColor = UIColor.purple
                menu.content = view
                menu.show()
            case 6:
                let vc = PickerViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            case 7:
                showModal()
            default: break
            }
            
        case 1:
            switch indexPath.row {
            case 0:
                let vc = WebViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                self.navigationController?.pushViewController(TextViewViewController(), animated: true)
            default: break
            }
        default:  break
        }
    }
}

class LXTableViewViewCell: SwiftTableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 00, y: 0, width: SCREEN_WIDTH_TO_WIDTH, height: 50))
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.lx.font(withBold: 16)
        return label
    }()
    
    override func setupUI() {
        contentView.addSubview(titleLabel)
    }
    
    public var textStr: String? {
        didSet {
            titleLabel.text = textStr
        }
    }
}
