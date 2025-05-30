//
//  ImageTestViewController.swift
//  LXSwiftFoundationModule
//
//  Created by xrj on 2025/5/30.
//  Copyright © 2025 李响. All rights reserved.
//

import UIKit

class ImageTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let image = UIImage.lx.image(with: UIColor.white,size: CGSize(width: 100, height: 100))
        let imgView = UIImageView(frame: CGRect(x: 100, y: 50, width: 100, height: 100))
        
//        let image = UIImage.lx.image(with: URL(string: "https://compliancefiles.xiaoroujiankang.com/video/20240923/1727078996218_transcode_xr.mp4"))!
//        
        imgView.image = UIImage(named: "test")!.lx.zoomTo(by: 0.5)

        view.addSubview(imgView)
        
        let imgView1 = UIImageView(frame: CGRect(x: 100, y: 200, width: 100, height: 100))
        imgView1.image = UIImage(named: "test")!.lx.imageFilter(with: "CISepiaTone")
       
        view.addSubview(imgView1)
        
        
        let imgView2 = UIImageView(frame: CGRect(x: 100, y: 350, width: 100, height: 100))
        imgView2.image =  UIImage(named: "test")
//        imgView2.backgroundColor = UIColor.blue
        view.addSubview(imgView2)

        
        let imgView3 = UIImageView(frame: CGRect(x: 100, y: 500, width: 100, height: 100))
        imgView3.image = imgView2.image!.lx.imageByRound(with: 50, corners: UIRectCorner.allCorners)
//        imgView3.backgroundColor = UIColor.blue
        view.addSubview(imgView3)
        
        
        let imgView4 = UIImageView(frame: CGRect(x: 100, y: 650, width: 100, height: 100))
        imgView4.image = imgView2.image!.lx.imageByRound(with: 50, corners: UIRectCorner.allCorners, borderWidth: 10, borderColor: UIColor.red)?.lx.grayImage
        imgView4.backgroundColor = UIColor.blue
        view.addSubview(imgView4)

        
        
//        
//        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
