//
//  LXSegmentView.swift
//  LXSwiftFoundationModule
//
//  Created by 李响 on 2021/9/18.
//  Copyright © 2021 李响. All rights reserved.
//

import UIKit
import LXSwiftFoundation
class LXSegmentView: LXSwiftView {
    override func setupUI() {
        
    }

}

extension LXSegmentView {
    public func setConfig(_ items: [String]) {
        
    }
}

public class LXSegmentItem: NSObject {
    var title: String
    var image: UIImage?
    public init(_ title: String, image: UIImage? = nil) {
        self.title = title
        self.image = image
    }
}
