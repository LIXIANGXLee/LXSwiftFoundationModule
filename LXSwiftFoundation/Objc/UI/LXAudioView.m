//
//  LXAudioView.m
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/10/26.
//

#import "LXAudioView.h"

@implementation LXAudioView

- (void)drawRect:(CGRect)rect {
    
    if (!self.lines || self.lines.count == 0) return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    /// 得到中心y的坐标
    CGFloat midY = CGRectGetMidY(rect);
    /// 绘制路径
    CGMutablePathRef halfPath = CGPathCreateMutable();
    /// 在路径上移动当前画笔的位置到一个点，这个点由CGPoint 类型的参数指定。
    CGPathMoveToPoint(halfPath, NULL, 0.0f, midY);
    [self.lines enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        /// 从当前的画笔位置向指定位置（同样由CGPoint类型的值指定）绘制线段
        CGPathAddLineToPoint(halfPath, NULL, idx, midY - [obj floatValue]);
    }];
    /// 重置起点
    CGPathAddLineToPoint(halfPath, NULL, self.lines.count, midY);
    /// 实现波形图反转
    CGMutablePathRef fullPath = CGPathCreateMutable();
    /// 合并路径
    CGPathAddPath(fullPath, NULL, halfPath);
    /// 反转波形图
    CGAffineTransform transform = CGAffineTransformIdentity;
    /// 反转配置
    transform = CGAffineTransformTranslate(transform, 0, CGRectGetHeight(rect));
    transform = CGAffineTransformScale(transform, 1.0, -1.0);
    /// 将路径添加到上下文中
    CGPathAddPath(fullPath, &transform, halfPath);
    CGContextAddPath(context, fullPath);
    /// 绘制颜色
    CGContextSetFillColorWithColor(context, self.lineColor.CGColor);
    /// 开始绘制上下文
    CGContextDrawPath(context, kCGPathFill);
    /// 移除路径
    CGPathRelease(halfPath);
    CGPathRelease(fullPath);
}

@end
