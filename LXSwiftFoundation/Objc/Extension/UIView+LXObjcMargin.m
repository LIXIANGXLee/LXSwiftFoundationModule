//
//  UIView+LXObjcMargin.m
//  LXSwiftFoundation
//
//  Created by 李响 on 2018/8/9.
//

#import "UIView+LXObjcMargin.h"

@implementation UIView (LXObjcMargin)

- (void)setLx_x:(CGFloat)lx_x {
    CGRect frame = self.frame;
    frame.origin.x = lx_x;
    self.frame = frame;
}

-(CGFloat)lx_x {
    return self.frame.origin.x;
}

- (void)setLx_y:(CGFloat)lx_y {
    CGRect frame = self.frame;
    frame.origin.y = lx_y;
    self.frame = frame;
}

- (CGFloat)lx_y {
    return self.frame.origin.y;
}

- (void)setLx_center_x:(CGFloat)lx_center_x {
    CGPoint center = self.center;
    center.x = lx_center_x;
    self.center = center;
}

- (CGFloat)lx_center_x {
    return self.center.x;
}

- (void)setLx_center_y:(CGFloat)lx_center_y {
    CGPoint center = self.center;
    center.y = lx_center_y;
    self.center = center;
}

- (CGFloat)lx_center_y {
    return self.center.y;
}

- (void)setLx_width:(CGFloat)lx_width {
    CGRect frame = self.frame;
    frame.size.width = lx_width;
    self.frame = frame;
}

- (CGFloat)lx_width {
    return self.frame.size.width;
}

- (void)setLx_height:(CGFloat)lx_height {
    CGRect frame = self.frame;
    frame.size.height = lx_height;
    self.frame = frame;
}

- (CGFloat)lx_height {
    return self.frame.size.height;
}

-(void)setLx_origin:(CGPoint)lx_origin {
    CGRect frame = self.frame;
    frame.origin = lx_origin;
    self.frame = frame;
}

-(CGPoint)lx_origin {
    return self.frame.origin;
}

- (void)setLx_size:(CGSize)lx_size {
    CGRect frame = self.frame;
    frame.size = lx_size;
    self.frame = frame;
}

- (CGSize)lx_size {
    return self.frame.size;
}

-(void)setLx_right:(CGFloat)lx_right {
    CGRect frame = self.frame;
    frame.origin.x = lx_right - frame.size.width;
    self.frame = frame;
}

-(CGFloat)lx_right {
    return CGRectGetMaxX(self.frame);
}

-(void)setLx_bottom:(CGFloat)lx_bottom {
    CGRect frame = self.frame;
    frame.origin.y = lx_bottom - frame.size.height;
    self.frame = frame;
}

-(CGFloat)lx_bottom {
    return CGRectGetMaxY(self.frame);
}

-(void)setLx_top:(CGFloat)lx_top {
    CGRect frame = self.frame;
    frame.origin.y = lx_top;
    self.frame = frame;
}

-(CGFloat)lx_top {
    return self.frame.origin.y;
}

- (void)setLx_left:(CGFloat)lx_left {
    CGRect frame = self.frame;
    frame.origin.x = lx_left;
    self.frame = frame;
}

- (CGFloat)lx_left {
    return self.frame.origin.x;
}

@end
