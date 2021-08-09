//
//  UIView+LXObjcMargin.m
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/8/9.
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

-(void)setLx_Origin:(CGPoint)lx_Origin {
    CGRect frame = self.frame;
    frame.origin = lx_Origin;
    self.frame = frame;
}

-(CGPoint)lx_Origin {
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

-(void)setLx_Right:(CGFloat)lx_Right {
    CGRect frame = self.frame;
    frame.origin.x = lx_Right - frame.size.width;
    self.frame = frame;
}

-(CGFloat)lx_Right {
    return CGRectGetMaxX(self.frame);
}

-(void)setLx_Bottom:(CGFloat)lx_Bottom {
    CGRect frame = self.frame;
    frame.origin.y = lx_Bottom - frame.size.height;
    self.frame = frame;
}

-(CGFloat)lx_Bottom {
    return CGRectGetMaxY(self.frame);
}

-(void)setLx_Top:(CGFloat)lx_Top {
    CGRect frame = self.frame;
    frame.origin.y = lx_Top;
    self.frame = frame;
}

-(CGFloat)lx_Top {
    return self.frame.origin.y;
}

- (void)setLx_Left:(CGFloat)lx_Left {
    CGRect frame = self.frame;
    frame.origin.x = lx_Left;
    self.frame = frame;
}

- (CGFloat)lx_Left {
    return self.frame.origin.x;
}

@end
