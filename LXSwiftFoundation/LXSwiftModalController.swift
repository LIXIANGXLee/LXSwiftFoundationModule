//
//  LXModalController.swift
//  LXSwiftFoundation
//
//  Created by Mac on 2020/4/28.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

// MARK: - public
open class LXSwiftModalController: UIViewController {

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        //modal
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addSubview(contentView)


        //self.view
        view.addGestureRecognizer(tapGesture)
        
        //contentView
        contentView.addGestureRecognizer(contentGesture)
        
    }
    
     /// content view action click
      open lazy var contentGesture: UITapGestureRecognizer = {
          return  UITapGestureRecognizer(target: self, action: #selector(contentViewTaped(tap:)))
      }()
    
    /// allscreen UITapGestureRecognizer
      open lazy var tapGesture: UITapGestureRecognizer = {
          return UITapGestureRecognizer(target: self, action: #selector(backgroundViewTap))
      }()
    
    /// content view
      open lazy var contentView: UIView = {
           let contentView = UIView()
           contentView.backgroundColor = UIColor.white
           return contentView
       }()
   
}

// MARK: - public
extension LXSwiftModalController {
    
    /// dismiss modal
    @objc open func backgroundViewTap() {
        self.lx.dismissViewController()
    }

     /// write bgviw action
    @objc open func contentViewTaped(tap: UITapGestureRecognizer) { }
    
}
