//
//  LXAudioView.h
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/10/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 绘制音频波形图的View
@interface LXAudioView : UIView

@property(nonatomic, strong)NSArray *lines;
@property(nonatomic, strong)UIColor *lineColor;

@end

NS_ASSUME_NONNULL_END
