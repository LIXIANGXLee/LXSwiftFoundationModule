//
//  AppDelegate.swift
//  LXSwiftFoundationModule
//
//  Created by XL on 2020/9/23.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UINavigationController(rootViewController: ViewController())
        self.window?.makeKeyAndVisible()
 
        enum AppSettings: String, SwiftUserDefaultsProtocol {
            case userToken
            case darkModeEnabled
        }

        // 2. 安全存储（自动添加命名空间）
        SwiftUserDefaults[AppSettings.userToken] = "a1b2c3d4"

        SwiftUserDefaults[AppSettings.darkModeEnabled] = "ewewewewew"
        let imageStr = UIImage(named: "timg")?.lx.base64EncodingImageString ?? ""
        SwiftLog.log(imageStr);
        SwiftLog.log(imageStr.lx.base64DecodingImage);

        let aaa = "asd".lx.base64EncodingString ?? ""
        SwiftLog.log(aaa);
        
        SwiftLog.log(aaa.lx.base64DecodingString);

        return true
    }
}

