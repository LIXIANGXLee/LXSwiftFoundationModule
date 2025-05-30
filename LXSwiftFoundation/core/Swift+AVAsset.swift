//
//  Swift+AVAsset.swift
//  Pods
//
//  Created by xrj on 2025/5/30.
//

import AVFoundation

extension SwiftBasics where Base: AVURLAsset {
    
    // MARK: - 视频处理
    
    /// 获取视频文件的原始显示尺寸（自动校正旋转方向）
    /// - 说明：视频元数据中可能包含旋转信息（如90°旋转），此时自然尺寸(naturalSize)需要结合变换矩阵计算实际显示尺寸
    /// - 重要：当视频轨道包含旋转变换时，直接使用naturalSize会得到错误宽高（如竖屏视频显示为横屏尺寸）
    /// - 处理逻辑：1.获取视频轨道 → 2.应用变换矩阵 → 3.取绝对值消除负值
    /// - 返回值：已校正旋转的视频实际显示尺寸（单位：像素），无视频轨道时返回nil
    public var videoSize: CGSize? {
        // 1. 获取首个视频轨道
        // 注意：AVAsset可能包含多个轨道（如画中画），通常取第一条有效视频轨道
        guard let videoTrack = base.tracks(withMediaType: .video).first else {
            return nil  // 无视频轨道时返回nil
        }
        
        // 2. 应用变换矩阵计算实际尺寸
        // preferredTransform包含旋转信息，例如：
        //   - 竖屏拍摄视频：可能包含90°旋转矩阵，导致宽高值互换
        //   - 翻转视频：可能导致宽/高出现负值
        let transformedSize = videoTrack.naturalSize.applying(videoTrack.preferredTransform)
        
        // 3. 对宽高取绝对值
        // 原因：旋转变换可能产生负值（如180°旋转会生成负宽高）
        // 注意：负值仅表示方向，实际显示尺寸需取正
        return CGSize(
            width: abs(transformedSize.width),
            height: abs(transformedSize.height)
        )
    }
}

extension SwiftBasics where Base: AVAsset {

    
    /// 获取旋转校正后的视频显示尺寸（自动处理90/270度旋转的宽高交换）
    /// - 说明: 视频元数据中可能包含旋转信息(如手机竖拍视频)，实际显示时需要校正方向
    /// - Parameter asset: 视频资源对象
    /// - Returns: 校正后的显示尺寸（当视频需要90/270度旋转时自动交换宽高）
    public func videoTransformSize(from asset: AVAsset) -> CGSize {
        // 1. 获取视频轨道
        guard let videoTrack = asset.tracks(withMediaType: .video).first else {
            // 无视频轨道时返回零尺寸
            return .zero
        }
        
        // 2. 获取视频原始尺寸（未校正旋转的尺寸）
        let naturalSize = videoTrack.naturalSize
        
        // 3. 获取视频旋转角度（从元数据中解析出的实际旋转角度）
        let rotationDegrees = asset.lx.videoDegrees
        
        // 4. 根据旋转角度校正显示尺寸
        switch rotationDegrees {
        case 90, 270:
            // 90度/270度旋转需要交换宽高
            // 示例: 竖屏拍摄的1920x1080视频，实际应显示为1080x1920
            return CGSize(width: naturalSize.height, height: naturalSize.width)
        default:
            // 其他角度（0/180度）保持原始宽高
            // 注意：0度和180度虽然方向不同，但宽高比例不变
            return naturalSize
        }
    }
    
    /// 获取视频轨道的旋转角度（标准化为0°、90°、180°、270°）
    ///
    /// 计算原理：
    /// 1. 从视频轨道获取变换矩阵（preferredTransform）
    /// 2. 通过矩阵的a/b分量计算旋转弧度
    /// 3. 将弧度转换为0-360°范围内的角度值
    /// 4. 标准化到最接近的预设角度（容差±0.5°）
    ///
    /// - Returns: 标准化旋转角度，默认返回0（当无视频轨道或角度异常时）
    public var videoDegrees: Int {
        // 1. 获取首个视频轨道
        guard let track = base.tracks(withMediaType: .video).first else {
            return 0  // 无视频轨道返回默认0°
        }
        
        // 2. 提取变换矩阵
        let transform = track.preferredTransform
        
        /* 变换矩阵结构说明:
         [ a  b  0 ]
         [ c  d  0 ]
         [ tx ty 1 ]
         
         旋转角度计算原理：
         atan2(b, a) 可计算出绕Z轴的旋转弧度
         */
        
        // 3. 计算旋转弧度（使用矩阵的b和a分量）
        let radians = atan2(transform.b, transform.a)
        
        // 4. 弧度转角度（0-360°范围）
        var degrees = radians * (180 / .pi)  // 弧度 -> 角度
        if degrees < 0 { degrees += 360 }    // 负角度转正（0-360范围）
        
        /* 5. 角度标准化处理（容差±0.5°）
         预设角度: 0°, 90°, 180°, 270°
         处理逻辑：
         a) 计算当前角度与各标准角度的差值
         b) 若差值在容差范围内，则返回该标准角度
         c) 无匹配时返回默认0°
         */
        let standardAngles = [0.0, 90.0, 180.0, 270.0]
        for angle in standardAngles {
            let difference = abs(degrees - angle)
            // 处理360°边界（如359.5°应视为0°）
            let cyclicDifference = min(difference, 360 - difference)
            
            if cyclicDifference <= 0.5 {  // 容差范围±0.5°
                return Int(angle)
            }
        }
        
        return 0  // 异常角度返回默认0°
    }
}
