//
//  LXSwift+Button.swift
//  LXSwiftFoundation
//
//  Created by XL on 2020/9/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

//MARK: -  Extending properties for UIButton
extension LXSwiftBasics where Base: UIButton {
    
    /// 将文字级别设置为“居中” space 间距大小
    public func horizontalCenterImageAndTitle(space: CGFloat) {
        guard let imageView = base.imageView,
              let titleLabel = base.titleLabel else { return }
        let imageHeight = imageView.intrinsicContentSize.height
        let imageWidth = imageView.intrinsicContentSize.width
        let titleHeight = titleLabel.intrinsicContentSize.height
        let titleWitdh = titleLabel.intrinsicContentSize.width
        let totalHeight = imageHeight + titleHeight + space
        base.imageEdgeInsets = UIEdgeInsets(top: -(totalHeight - imageHeight),
                                            left: 0,
                                            bottom: 0,
                                            right: -titleWitdh)
        base.titleEdgeInsets = UIEdgeInsets(top: 0,
                                            left: -imageWidth,
                                            bottom: -(totalHeight - titleHeight),
                                            right: 0)
    }
    
    /// 将图像文本设置为垂直居中 space 间距大小
    public func verticalCenterImageAndTitle(space: CGFloat,
                                            isLeftImage: Bool = true) {
        guard let imageView = base.imageView,
              let titleLabel = base.titleLabel else { return }
        let imageWidth = imageView.intrinsicContentSize.width
        let titleWitdh = titleLabel.intrinsicContentSize.width
        let imageSpace = isLeftImage ? space * 0.5 : (space * 0.5 + titleWitdh)
        let titleSpace = isLeftImage ? space * 0.5 : (space * 0.5 + imageWidth)

        base.imageEdgeInsets = UIEdgeInsets(top: 0,
                                            left:isLeftImage ? -imageSpace : imageSpace,
                                            bottom: 0,
                                            right: isLeftImage ? imageSpace : -imageSpace)
        base.titleEdgeInsets = UIEdgeInsets(top: 0,
                                            left: isLeftImage ? titleSpace : -titleSpace,
                                            bottom:0,
                                            right: isLeftImage ? -titleSpace : titleSpace)
    }
    
    /// Width for button
    public var bestWidth: CGFloat {
        return base.sizeThatFits(CGSize.zero).width
    }
    
    /// Height  for button
    public var bestHeight: CGFloat {
        return base.sizeThatFits(CGSize.zero).height
    }
    
    /// 提供了一种设置uibutton属性的方便方法 （字体大小、字体颜色）
    public func set(font: UIFont, titleColor: UIColor?) {
        base.titleLabel?.font = font
        if let titleColor = titleColor {
            base.setTitleColor(titleColor, for: .normal)
        }
    }
    
    /// 提供了一种设置uibutton属性的方便方法 （标题、图片、状态）
    public func set(title: String?, image: UIImage?, state: UIControl.State = .normal) {
        if let title = title { base.setTitle(title, for: state) }
        if let image = image { base.setImage(image, for: state) }
    }
}

//MARK: -  Extending properties and methods for UIButton
extension LXSwiftBasics where Base : UIButton {
    
    public func setHandle(buttonCallBack: ((_ button: UIButton) -> ())?){
        base.swiftCallBack = buttonCallBack
        base.addTarget(base, action: #selector(base.swiftButtonAction(_:)), for: .touchUpInside)
    }
}

private var buttonCallBackKey: Void?
extension UIButton: LXSwiftPropertyCompatible {
    public typealias T = UIButton
    var swiftCallBack: SwiftCallBack? {
        get { return lx_getAssociatedObject(self, &buttonCallBackKey) }
        set { lx_setRetainedAssociatedObject(self, &buttonCallBackKey, newValue) }
    }
    
    @objc func swiftButtonAction(_ button: UIButton) {
        self.swiftCallBack?(button)
    }
}
