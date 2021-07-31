//
//  LXSwift+WKWebView.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2020/10/24.
//

import UIKit
import WebKit

//MARK: -  Extending properties for UIScrollView
extension LXSwiftBasics where Base: WKWebView {
  
    /// 捕获长图片，您可以捕获用于滚动查看的图片
    public func snapShotContentScroll(callBack: @escaping (UIImage?) -> ()) {
        base.scrollView.snapShotContentScroll { (image) in
            callBack(image)
        }
    }
}
