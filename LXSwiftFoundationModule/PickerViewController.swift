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

        self.view.backgroundColor = UIColor.red
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let picker = LXSwiftPickerView(style: .grouped)

        picker.delegate = self
        picker.dataSource = self
        
        picker.minHeight = 400
        picker.maxHeight = SCREEN_HEIGHT_TO_HEIGHT
        
        picker.setTViewAllCornerRadii = 20
        
//        picker.isDismissOfDidSelectBgView = false
        
        let tableheader = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
        tableheader.isUserInteractionEnabled = true
        tableheader.image = UIImage(named: "timg")
        picker.tHeaderView = tableheader
        picker.setTHeaderViewTopCornerRadii = 20

        let tableFooter = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        tableFooter.isUserInteractionEnabled = true
        tableFooter.image = UIImage(named: "timg")
        picker.tFooterView = tableFooter
        picker.setTFooterViewBottomCornerRadii = 20

        picker.show {
            print("-=-=-=-=--=-=show-----===")
        }
    }
    
}

extension PickerViewController: LXSwiftPickerViewDelegate {
    func pickerView(_ pickerView: LXSwiftPickerView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func pickerView(_ pickerView: LXSwiftPickerView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func pickerView(_ pickerView: LXSwiftPickerView, tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    func pickerView(didDismissView pickerView: LXSwiftPickerView) {
        print("-=-=-=-=-=didDismissView-=-=-=-=\(pickerView)")
    }
    
    func pickerView(_ pickerView: LXSwiftPickerView, didSelectRowAt indexPath: IndexPath) {
        pickerView.dismiss()
        print("-=-=-=-=-=didSelectRowAt-=-=-=-=\(indexPath)")

    }
    
    func pickerView(_ pickerView: LXSwiftPickerView, scrollViewDidScroll offSetY: CGFloat, scrollType: LXSwiftPickerView.ScrollType) {
        print("-=-=-=-=-=-=-=\(offSetY)==\(scrollType.rawValue)")
    }
}


extension PickerViewController: LXSwiftPickerViewDataSource {

    func pickerView(_ pickerView: LXSwiftPickerView, registerClass tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func pickerView(_ pickerView: LXSwiftPickerView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func pickerView(numberOfSections pickerView: LXSwiftPickerView) -> Int {
        return 4
    }
    
    
    func pickerView(_ pickerView: LXSwiftPickerView, tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "你是谁\(indexPath.section)组，排行\(indexPath.row)"

        return cell
    }
    
    func pickerView(_ pickerView: LXSwiftPickerView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        header.text  = "我是第\(section)组头部标题"
        header.textAlignment = .center
        header.font = UIFont.systemFont(ofSize: 20)
        header.textColor = UIColor.white
        header.backgroundColor = UIColor.blue
        return header
    }
    
    func pickerView(_ pickerView: LXSwiftPickerView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        footer.text  = "我是第\(section)组尾部标题"
        footer.textAlignment = .center
        footer.font = UIFont.systemFont(ofSize: 20)
        footer.textColor = UIColor.white
     
       footer.backgroundColor = UIColor.orange
       return footer
    }
}
