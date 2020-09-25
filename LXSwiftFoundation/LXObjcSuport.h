//
//  LXObjcSuport.h
//  LXSwiftFoundation
//
//  Created by Mac on 2020/9/26.
//  Copyright © 2020 李响. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 比较版本号大小C语言实现算法
 
 @param v1 第一个版本号
 @param v2 第二个版本号
 @return 0:相等,-1:第一个小,1:第二个小
 */
int _compareVersion(const char *v1, const char *v2);
