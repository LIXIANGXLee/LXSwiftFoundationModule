//
//  LXSwiftLabel.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

open class LXSwiftLabel<U>: UILabel, LXSwiftUICompatible {
    public typealias T = U
    public var swiftModel: U?
}

