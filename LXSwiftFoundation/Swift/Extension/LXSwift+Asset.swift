//
//  LXSwift+Asset.swift
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/10/27.
//

import UIKit

extension AVAsset: LXSwiftCompatible { }
extension LXSwiftBasics where Base: AVAsset {
   
    /// 读取音频采样数据
    public var audioSamples: Data? { LXObjcUtils.readAudioSamples(fromAVsset: base) }
  
    /// 获取声音波形图数据
    public func soundWave(for size: CGSize) -> [Int]? { LXObjcUtils.soundWave(fromAVsset: base, for: size) as? [Int] }
    
}
