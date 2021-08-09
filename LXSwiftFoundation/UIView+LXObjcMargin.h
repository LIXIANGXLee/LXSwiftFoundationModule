//
//  UIView+LXObjcMargin.h
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/8/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LXObjcMargin)

@property (nonatomic, assign) CGFloat lx_x;
@property (nonatomic, assign) CGFloat lx_y;
@property (nonatomic, assign) CGFloat lx_center_x;
@property (nonatomic, assign) CGFloat lx_center_y;
@property (nonatomic, assign) CGFloat lx_width;
@property (nonatomic, assign) CGFloat lx_height;
@property (nonatomic, assign) CGSize lx_size;

@property (nonatomic, assign) CGPoint lx_Origin;
@property (nonatomic, assign) CGFloat lx_Right;
@property (nonatomic, assign) CGFloat lx_Bottom;
@property (nonatomic, assign) CGFloat lx_Left;
@property (nonatomic, assign) CGFloat lx_Top;

@end

NS_ASSUME_NONNULL_END
