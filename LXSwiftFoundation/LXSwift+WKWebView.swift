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

    ///Capture the long picture, you can capture the picture for Scrollview
    public func snapShotContentScroll(callBack: @escaping (UIImage?) -> ()) {
        base.scrollView.snapShotContentScroll { (image) in
            callBack(image)
        }
    }
}
