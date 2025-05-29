//
//  PickerViewController.swift
//  LXSwiftFoundationModule
//
//  Created by 李响 on 2021/9/1.
//  Copyright © 2021 李响. All rights reserved.
//

import UIKit
import LXSwiftFoundation

class PickerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "两段式滑动弹窗,点击屏幕显示弹窗"
        
        self.view.backgroundColor = UIColor.white
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let picker = SwiftPickerView(style: .grouped)

        picker.delegate = self
        picker.dataSource = self
        
        picker.minHeight = SCREEN_HEIGHT_TO_HEIGHT * 0.4
        picker.maxHeight = SCREEN_HEIGHT_TO_HEIGHT * 0.8
        
        picker.tViewAllCornerRadii = 20
        
//        picker.isDismissOfDidSelectBgView = false
        
        let tableheader = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
        tableheader.isUserInteractionEnabled = true
        tableheader.image = UIImage(named: "timg")
        picker.tHeaderView = tableheader
        picker.tHeaderViewTopCornerRadii = 20

        let tableFooter = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        tableFooter.isUserInteractionEnabled = true
        tableFooter.image = UIImage(named: "timg")
        picker.tFooterView = tableFooter
        picker.tFooterViewBottomCornerRadii = 20

        picker.show {
            SwiftLog.log("-=-=-=-=--=-=show-----===")
        }
    }
    
}

extension PickerViewController: SwiftPickerViewDelegate {
    func pickerView(_ pickerView: SwiftPickerView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func pickerView(_ pickerView: SwiftPickerView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func pickerView(_ pickerView: SwiftPickerView, tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    func pickerView(didDismissView pickerView: SwiftPickerView) {
        SwiftLog.log("-=-=-=-=-=didDismissView-=-=-=-=\(pickerView)")
    }
    
    func pickerView(_ pickerView: SwiftPickerView, didSelectRowAt indexPath: IndexPath) {
        pickerView.dismiss()
        SwiftLog.log("-=-=-=-=-=didSelectRowAt-=-=-=-=\(indexPath)")

    }
    
    func pickerView(_ pickerView: SwiftPickerView, scrollViewDidScroll offSetY: CGFloat, scrollType: SwiftPickerView.ScrollType) {
        SwiftLog.log("-=-=-=-=-=-=-=\(offSetY)==\(scrollType.rawValue)")
    }
}


extension PickerViewController: SwiftPickerViewDataSource {

    func pickerView(_ pickerView: SwiftPickerView, registerClass tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func pickerView(_ pickerView: SwiftPickerView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func pickerView(numberOfSections pickerView: SwiftPickerView) -> Int {
        return 4
    }
    
    
    func pickerView(_ pickerView: SwiftPickerView, tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "你是谁\(indexPath.section)组，排行\(indexPath.row)"

        return cell
    }
    
    func pickerView(_ pickerView: SwiftPickerView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        header.text  = "我是第\(section)组头部标题"
        header.textAlignment = .center
        header.font = UIFont.systemFont(ofSize: 20)
        header.textColor = UIColor.white
        header.backgroundColor = UIColor.blue
        return header
    }
    
    func pickerView(_ pickerView: SwiftPickerView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        footer.text  = "我是第\(section)组尾部标题"
        footer.textAlignment = .center
        footer.font = UIFont.systemFont(ofSize: 20)
        footer.textColor = UIColor.white
     
       footer.backgroundColor = UIColor.orange
       return footer
    }
}
