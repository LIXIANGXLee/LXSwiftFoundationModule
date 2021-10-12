//
//  LXHomeViewCell.swift
//  LXSwiftFoundationModule
//
//  Created by 李响 on 2021/9/24.
//  Copyright © 2021 李响. All rights reserved.
//

import UIKit
import LXSwiftFoundation

class LXHomeViewCell: LXSwiftTableViewCell {
    
    public var sDelegate: LXSubPageDelegate?
    
    lazy var scrollView: LXSwiftScrollView = {
        let scrollView = LXSwiftScrollView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH_TO_WIDTH, height: SCREEN_HEIGHT_TO_HEIGHT))
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH_TO_WIDTH, height: 0)
        return scrollView
    }()
    
    lazy var collectionView: LXSwiftCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: SCREEN_WIDTH_TO_WIDTH, height: SCREEN_HEIGHT_TO_HEIGHT)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = LXSwiftCollectionView(frame: CGRect(x: 0,
                                                                 y: 0,
                                                                 width: SCREEN_WIDTH_TO_WIDTH,
                                                                 height: SCREEN_HEIGHT_TO_HEIGHT - 200),
                                                   collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.registSwiftCell(LXHomeViewSubCell.self)
        collectionView.setShouldRecognizeSimultaneously { (gesture1, gesture2) -> Bool in
            return true
        }
        return collectionView
    }()
    
    override func setupUI() {
        
        contentView.addSubview(scrollView)
        scrollView.addSubview(collectionView)
    }
}

extension LXHomeViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueSwiftReusableCell(indexPath: indexPath) as LXHomeViewSubCell
        return cell
    }
}

extension LXHomeViewCell: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == collectionView {
            self.sDelegate?.subPageDidScroll(scrollView)

        }
    }

}
