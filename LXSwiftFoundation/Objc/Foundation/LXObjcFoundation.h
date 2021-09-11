//
//  LXSwiftFoundation.h
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/4/29.
//

#ifndef LXObjcFoundation_h
#define LXObjcFoundation_h

#define SCREEN_WIDTH_TO_WIDTH LXObjcApp.screenWidth
#define SCREEN_HEIGHT_TO_HEIGHT LXObjcApp.screenHeight
#define SCREEN_HEIGHT_TO_TOUCHBARHEIGHT LXObjcApp.touchBarHeight
#define SCREEN_HEIGHT_TO_STATUSHEIGHT LXObjcApp.statusBarHeight
#define SCREEN_HEIGHT_TO_TABBARHEIGHT LXObjcApp.tabBarHeight
#define SCREEN_HEIGHT_TO_NAVBARHEIGHT LXObjcApp.navBarHeight
#define SCALE_IP6_WIDTH_TO_WIDTH(w) [LXObjcApp flat:w * (SCREEN_WIDTH_TO_WIDTH / 375)]
#define SCALE_IP6_HEIGHT_TO_HEIGHT(h) [LXObjcApp flat:h * (SCREEN_HEIGHT_TO_HEIGHT / 667)]
#define SCALE_IPAD129_WIDTH_TO_WIDTH(w) [LXObjcApp flat:w * (SCREEN_WIDTH_TO_WIDTH / 1024)]
#define SCALE_IPAD129_HEIGHT_TO_HEIGHT(h) [LXObjcApp flat:h * (SCREEN_HEIGHT_TO_HEIGHT / 1366)]
#define SCALE_GET_CENTER_WIDTH_AND_WIDTH(p , c) [LXObjcApp flat:(p - c) / 2.0]

#import "UIGestureRecognizer+LXObjcAdd.h"
#import "UIView+LXObjcPerformance.h"
#import "LXDrawerViewController.h"
#import "CADisplayLink+Block.h"
#import "UIControl+LXObjcAdd.h"
#import "UIView+LXObjcMargin.h"
#import "NSString+LXObjcAdd.h"
#import "LXObjcThreadActive.h"
#import "NSObject+LXObjcKVO.h"
#import "UIColor+LXObjcAdd.h"
#import "LXWaterFlowLayout.h"
#import "UIImage+LXObjcAdd.h"
#import "NSTimer+LXObjcAdd.h"
#import "LXObjcLinkedList.h"
#import "LXLineFlowLayout.h"
#import "LXObjcGCDTimer.h"
#import "LXObjcProxy.h"
#import "LXObjcUtils.h"

#endif /* LXSwiftFoundation_h */
