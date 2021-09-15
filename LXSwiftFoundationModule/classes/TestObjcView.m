//
//  TestObjcView.m
//  LXSwiftFoundationModule
//
//  Created by Mac on 2021/9/4.
//  Copyright © 2021 李响. All rights reserved.
//

#import "TestObjcView.h"

@implementation TestObjcView

- (instancetype)init{
    self = [super init];
    if (self) {
        NSLog(@"-=-=-=-=-=-%f",SCREEN_HEIGHT_TO_HEIGHT);
        NSLog(@"-=-=-=-=-=-%f",SCREEN_WIDTH_TO_WIDTH);
        NSLog(@"-=-=-=-=-=-%f",SCREEN_HEIGHT_TO_NAVBARHEIGHT);
        NSLog(@"-=-=-=-=-=-%f",SCREEN_HEIGHT_TO_STATUSHEIGHT);
        NSLog(@"-=-=-=-=-=-%f",SCREEN_HEIGHT_TO_TOUCHBARHEIGHT);
        NSLog(@"-=-=-=-=-=-%f",SCREEN_HEIGHT_TO_TABBARHEIGHT);
        NSLog(@"-=-=-=-=-=-%f",SCALE_IP6_HEIGHT_TO_HEIGHT(20));
        NSLog(@"-=-=-=-=-=-%f",SCALE_IPAD129_WIDTH_TO_WIDTH(20));
        NSLog(@"-=-=-=-=-=-%f",SCALE_IPAD129_HEIGHT_TO_HEIGHT(20));
        NSLog(@"-=-=-=-=-=-%f",SCALE_IP6_WIDTH_TO_WIDTH(20));
        NSLog(@"-=-=-=-=-=-%f", [LXObjcApp statusBarHeight]);

    }
    return self;
}


@end
