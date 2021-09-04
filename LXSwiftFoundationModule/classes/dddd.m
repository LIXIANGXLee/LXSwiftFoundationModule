//
//  dddd.m
//  LXSwiftFoundationModule
//
//  Created by 李响 on 2021/4/29.
//  Copyright © 2021 李响. All rights reserved.
//

#import "dddd.h"
#import <LXSwiftFoundation/LXObjcProxy.h>
#import <LXSwiftFoundation-Swift.h>

#import <LXSwiftFoundation/LXObjcFoundation.h>

@implementation dddd

- (instancetype)init
{
    self = [super init];
    if (self) {
               
        NSLog(@"-=-=-=-=-=-%f",SCREEN_HEIGHT_TO_HEIGHT);
        NSLog(@"-=-=-=-=-=-%f",SCREEN_WIDTH_TO_WIDTH);
        NSLog(@"-=-=-=-=-=-%f",SCREEN_HEIGHT_TO_NAVBARHEIGHT);
        NSLog(@"-=-=-=-=-=-%f",SCREEN_HEIGHT_TO_STATUSHEIGHT);
        NSLog(@"-=-=-=-=-=-%f",SCREEN_HEIGHT_TO_TOUCHBARHEIGHT);
        NSLog(@"-=-=-=-=-=-%f",SCREEN_HEIGHT_TO_TABBARHEIGHT);
        NSLog(@"-=-=-=-=-=-%f",SCALE_IP6_WIDTH_TO_WIDTH(20));
        NSLog(@"-=-=-=-=-=-%f",SCALE_IP6_HEIGHT_TO_HEIGHT(20));
        NSLog(@"-=-=-=-=-=-%f",SCALE_IPAD129_WIDTH_TO_WIDTH(20));
        NSLog(@"-=-=-=-=-=-%f",SCALE_IPAD129_HEIGHT_TO_HEIGHT(20));

    }
    return self;
}



@end
