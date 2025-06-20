//
//  ViewController.swift
//  LXSwiftFoundationModule
//
//  Created by XL on 2020/9/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
//import LXSwiftFoundation
import Photos
import AVFoundation

class ViewController: UIViewController {
     
    private var datas: [[String]] = [[]]
    
    fileprivate lazy var tableView: SwiftTableView = {
        let tableView = SwiftTableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerSwiftCell(cellType: LXTableViewViewCell.self)
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
    private var switchCallBackKey: Void?
    private var switchCallBacka: Void?
    private var player: AVPlayer?
     override func viewDidLoad() {
        super.viewDidLoad()
         view.backgroundColor = UIColor.white
      
//        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
//         try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
//         try? AVAudioSession.sharedInstance().setActive(true)
//  
//         let url = URL(string: "https://cn.rich.my-imcloud.com/download/7days_1600046091_eHJfdXNlcl8xMg_5690aeca97f0a1da96c62a29874437f7-5BEECACB191C9BC13827D772C034FDD6.audio?auth=4tBhMfaVcY_ljjV2Kj6oFfJuPwAb-Phc8Dpn0Myz9AjalzPk4JO-O9T8lnAYUGUH6yXY4srOpX7AzALTalBGgJtNUIhJfFakOvw1fjybJyHT2--yfCAa4MxwJK95bMLMziAfF2sfmSPaDEYzkH7bAcfm10oTRVoQNwJWilxFPg8FFe9-b72DGthBmQijOGKC7XU89TGFxLYaQVCN4enEFalA1co1NDltzz3ftGASo2s")
//
//         // 创建AVPlayer实例
//         player = AVPlayer(url: url!)
//     
//         player?.play()
//         
         
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
               "戴超链接的弹窗",
               "图片",
               "KVO"
           ],
            [
                "wkwebview加载网页，截取长图",
                "textview和textfield",
                "NotificationTest"
                
            ]
        ]

        tableView.frame = CGRect(x: 0,
                                 y: SCREEN_HEIGHT_TO_NAVBARHEIGHT,
                                 width: SCREEN_WIDTH_TO_WIDTH,
                                 height: SCREEN_HEIGHT_TO_HEIGHT - SCREEN_HEIGHT_TO_NAVBARHEIGHT - SCREEN_HEIGHT_TO_BOTTOMSAFEHEIGHT)
         

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
        let config = SwiftHyperlinksConfig()
        config.contentMidViewHeight = SCALE_IP6_WIDTH_TO_WIDTH(260)
        config.titleFont = UIFont.lx.font(withMedium: 16)
        config.titleColor = UIColor.black
        config.isDismissBackground = true
        let itemCancel = SwiftItem(title: "不同意",
                                         titleColor: UIColor.blue,
                                         titleFont: UIFont.systemFont(ofSize: 17, weight: .medium)) { }
        let itemTrue =  SwiftItem(title: "同意",
                                         titleColor: UIColor.blue,
                                        titleFont: UIFont.systemFont(ofSize: 17, weight: .medium)) {
            let str = Bundle.main.path(forResource: "lxQrCodeVoice", ofType: "wav")
            UIApplication.lx.playSound(with: str)
        }
        
        
        let color = UIColor.lx.color(hex: "36acff")
        let font = UIFont.systemFont(ofSize: SCALE_IP6_WIDTH_TO_WIDTH(14))
        let r1 = SwiftRegexType(regexPattern: "《用户服务协议》", color: color, font: font,isExpression: false)
        let r2 = SwiftRegexType(regexPattern: "《隐私政策》", color: color, font: font,isExpression: false)
        let r3 = SwiftRegexType(regexPattern: SwiftRegexType.defaultHttpRegex, color: color, font: font,isExpression: false)

        let str = "欢迎使用迎使用！我们非常《用户服务协议》重视您《隐私政策》的您同意https://chat.deepseek.com并接受全部条款后方可开始使用。欢迎使用迎使用！我们非常《用户服务协议》重视您《隐私政策》的您同意https://chat.deepseek.com并接受全部条款后方可开始使用。欢迎使用迎使用！我们非常《用户服务协议》重视您《隐私政策》的您同意https://chat.deepseek.com并接受全部条款后方可开始使用。欢迎使用迎使用！我们非常《用户服务协议》重视您《隐私政策》的您同意https://chat.deepseek.com并接受全部条款后方可开始使用。欢迎使用迎使用！我们非常《用户服务协议》重视您《隐私政策》的您同意https://chat.deepseek.com并接受全部条款后方可开始使用。"
        
        let modal = SwiftHyperlinksController()
        modal.tapHandler = { text in
            SwiftLog.log("-=-=-=-=-=\(text)")
        }

        guard let attr = modal.getAttributedString(str, regexTypes: [r1,r2,r3]) else { return }
        modal.show(with: "温馨提示",
                   content: attr,
                   config: config,
                   items: [itemCancel,itemTrue])
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
            case 8:
                let vc = ImageTestViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            case 9:
                let vc = KVOViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            default: break
            }
            
        case 1:
            switch indexPath.row {
            case 0:
                let vc = WebViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                self.navigationController?.pushViewController(TextViewViewController(), animated: true)
            case 2:
                self.navigationController?.pushViewController(NotificationTest(), animated: true)
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
        contentView.backgroundColor = UIColor.white
    }
    
    public var textStr: String? {
        didSet {
            titleLabel.text = textStr
        }
    }
}
