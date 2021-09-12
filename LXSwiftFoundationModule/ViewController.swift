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
    
    private var datas: [String] = []
    
    fileprivate lazy var tableView: LXSwiftTableView = {
        let tableView = LXSwiftTableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registSwiftCell(LXTableViewViewCell.self)
        return tableView
    }()
    
    private var switchCallBackKey: Void?
    private var switchCallBacka: Void?

     override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "UI展示"
            
        ViewController.lx_classRespond(to: #selector(btnClick(_:)))
        
        datas.append("两段式滑动弹窗")
        datas.append("戴超链接的弹窗")
        datas.append("wkwebview加载网页，截取长图")
        datas.append("弹窗1")
        datas.append("弹窗2")
        datas.append("弹窗3")
        datas.append("弹窗4")
        datas.append("弹窗5")
        datas.append("textview和textfield")

        tableView.frame = CGRect(x: 0,
                                 y: SCREEN_HEIGHT_TO_NAVBARHEIGHT,
                                 width: LXSwiftApp.screenW,
                                 height: LXSwiftApp.screenH - SCREEN_HEIGHT_TO_NAVBARHEIGHT - SCREEN_HEIGHT_TO_TOUCHBARHEIGHT)
        view.addSubview(tableView)
        
        
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.red
        btn.frame = CGRect(x: SCREEN_WIDTH_TO_WIDTH - 100, y: SCREEN_HEIGHT_TO_NAVBARHEIGHT, width: 60, height: 60)
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(btnClick(_:)), for: UIControl.Event.touchUpInside)
     }
    
    @objc func btnClick(_ btn: UIButton) {
        
        let menu = LXSwiftMenuDownView()
        menu.xType = .right
        menu.animateDuration = 0.25
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 400))
        view.backgroundColor = UIColor.green
        menu.content = view
        menu.show(from: btn)
    
    }
    func showModal() {
        let config = LXSwiftModalConfig()
        config.isDismissBg = false
        config.contentMidViewH = SCALE_IP6_WIDTH_TO_WIDTH(260)
        config.titleFont = UIFont.lx.font(withMedium: 16)
        config.titleColor = UIColor.black
        let itemCancel = LXSwiftItem(title: "不同意",
                                         titleColor: UIColor.blue,
                                         titleFont: UIFont.systemFont(ofSize: 17, weight: .medium)) { }
        let itemTrue =  LXSwiftItem(title: "同意",
                                         titleColor: UIColor.blue,
                                        titleFont: UIFont.systemFont(ofSize: 17, weight: .medium)) {
            let str = Bundle.main.path(forResource: "lxQrCodeVoice", ofType: "wav")
            LXSwiftUtils.playSound(with: str)
        }
        
        let modal = LXSwiftHyperlinksModalController()
        modal.setModal(config, modalItems: [itemCancel,itemTrue]) { (text) -> (Void) in
            print("-=-=-=-=-=\(text)")
        }
        let r1 = LXSwiftRegexType(with: "《用户服务协议》",
                                  color: UIColor.lx.color(hex: "36acff"),
                                  font: UIFont.systemFont(ofSize: 14),
                                  isExpression: false)
        let r2 = LXSwiftRegexType(with: "《隐私政策》",
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueSwiftReusableCell(indexPath: indexPath) as LXTableViewViewCell
        tableView.roundSwiftSectionCell(cell, forRowAt: indexPath, cornerRadius: 20, backgroundColor: UIColor.blue)
        
        cell.textStr = datas[indexPath.row]
        return cell
    }
       
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = PickerViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            showModal()
        case 2:
            let vc = WebViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let menu = LXSwiftMenuCenterView()
            menu.yType = .midRotate
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 260, height: 400))
            let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
            view1.backgroundColor = UIColor.red
            view.addSubview(view1)
            view.backgroundColor = UIColor.purple
            menu.content = view
            menu.show()
        case 4:
            let menu = LXSwiftMenuCenterView()
            menu.yType = .top
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 260, height: 400))
            let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
            view1.backgroundColor = UIColor.red
            view.addSubview(view1)
            view.backgroundColor = UIColor.purple
            menu.content = view
            menu.show()
        case 5:
            let menu = LXSwiftMenuCenterView()
            menu.yType = .mid
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 260, height: 400))
            let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
            view1.backgroundColor = UIColor.red
            view.addSubview(view1)
            view.backgroundColor = UIColor.purple
            menu.content = view
            menu.show()
        case 6:
            let menu = LXSwiftMenuCenterView()
            menu.yType = .bottom
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 260, height: 400))
            let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
            view1.backgroundColor = UIColor.red
            view.addSubview(view1)
            view.backgroundColor = UIColor.purple
            menu.content = view
            menu.show()
        case 7:
            let menu = LXSwiftMenuUpView()
            let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH_TO_WIDTH, height: 400))
            view.backgroundColor = UIColor.purple
            menu.content = view
            menu.show()
        case 8:
            self.navigationController?.pushViewController(TextViewViewController(), animated: true)
        default:  break
        }    
    }
}

class LXTableViewViewCell: LXSwiftTableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 00, y: 0, width: SCREEN_WIDTH_TO_WIDTH, height: 50))
        label.textColor = UIColor.white
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
//    
}
