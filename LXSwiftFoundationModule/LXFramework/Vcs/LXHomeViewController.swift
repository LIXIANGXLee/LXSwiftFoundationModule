//
//  LXHomeViewController.swift
//  LXSwiftFoundationModule
//
//  Created by 李响 on 2021/9/24.
//  Copyright © 2021 李响. All rights reserved.
//

import UIKit
import LXSwiftFoundation

class LXHomeViewController: UIViewController {
    
    fileprivate var viewCell: LXHomeViewCell?
    fileprivate var isScroll = true
    fileprivate var isSubScroll = false

    lazy var headerView: LXSwiftView = {
        let rect = CGRect(x: 0,
                          y: 0,
                          width: SCREEN_WIDTH_TO_WIDTH,
                          height: 200)
        let headerView = LXSwiftView(frame: rect)
        headerView.backgroundColor = UIColor.red
        return headerView
    }()
    
    lazy var tableView: LXSwiftTableView = {
        let rect = CGRect(x: 0,
                          y: SCREEN_HEIGHT_TO_NAVBARHEIGHT,
                          width: SCREEN_WIDTH_TO_WIDTH,
                          height: SCREEN_HEIGHT_TO_HEIGHT)
        let tableView = LXSwiftTableView(frame: rect, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registSwiftCell(LXHomeViewCell.self)
        tableView.tableHeaderView = headerView
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
    }
}

extension LXHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { SCREEN_HEIGHT_TO_HEIGHT }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {  80 }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY >= headerView.lx.height {
            isScroll = false
            isSubScroll = true
        } else {
            /// tableView的滑动距离小于等于0时 让sub滑动，目的可以下拉刷新
            if offsetY <= 0 {
                isSubScroll = true
                scrollView.contentOffset = CGPoint.zero
                return
            }

            isSubScroll = false
        }
        
        if !isScroll {
            scrollView.contentOffset = CGPoint(x: 0, y: headerView.lx.height)
        }
    }
}

extension LXHomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH_TO_WIDTH, height: 80))
        view.backgroundColor = UIColor.blue
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueSwiftReusableCell(indexPath: indexPath) as LXHomeViewCell
        viewCell = cell
        cell.sDelegate = self
        return cell
    }
    
}

extension LXHomeViewController: LXSubPageDelegate {
   
    func subPageDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y

        if offsetY <= 0 {
            isScroll = true
        }
        
        if !isSubScroll {
            scrollView.contentOffset = CGPoint.zero
        }
    }
}
