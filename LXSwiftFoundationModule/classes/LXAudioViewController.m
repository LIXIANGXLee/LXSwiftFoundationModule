//
//  LXAudioViewController.m
//  LXSwiftFoundationModule
//
//  Created by 李响 on 2021/10/27.
//  Copyright © 2021 李响. All rights reserved.
//

#import "LXAudioViewController.h"
#import <LXSwiftFoundation/LXSwiftFoundation-Swift.h>
#import <LXSwiftFoundation/LXObjcFoundation.h>
#import "LXAudioView.h"

@interface LXAudioViewController ()
@property(nonatomic, strong)LXAudioView *audioView;

@end

@implementation LXAudioViewController

- (LXAudioView *)audioView {
    if (!_audioView) {
        _audioView = [[LXAudioView alloc]initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH_TO_WIDTH - 40, 60)];
        _audioView.lineColor = [UIColor redColor];
        _audioView.backgroundColor = [UIColor clearColor];
    }
    return _audioView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title = @"声音波形图";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.audioView];
    
    NSString *url = [[NSBundle mainBundle]pathForResource:@"lxQrCodeVoice" ofType:@"wav"];
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:url]];
    NSArray *lines = [LXObjcUtils soundWaveFromAVsset:asset forSize:self.audioView.frame.size];
    
    self.audioView.lines = lines;
    
}

@end
