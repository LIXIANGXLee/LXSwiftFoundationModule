//
//  LXSwift+WKWebView.swift
//  DDGScreenShot
//
//  Created by XL on 2020/10/24.
//

import UIKit
import WebKit

//MARK: -  Extending properties for UIScrollView
extension LXSwiftBasics where Base: WKWebView {
 
    public func snapShotContentScroll(callBack: @escaping (UIImage?) -> ()) {
        base.scrollView.snapShotContentScroll { (image) in
            callBack(image)
        }
    }
    
}
