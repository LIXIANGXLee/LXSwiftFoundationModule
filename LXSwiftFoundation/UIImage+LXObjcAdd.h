//
//  UIImage+LXObjcUtils.h
//  LXSwiftFoundation
//
//  Created by 李响 on 2016/8/9.
//

#import <UIKit/UIKit.h>
#include <CoreMedia/CMSampleBuffer.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (LXObjcUtils)
/**
 * 将UIImage转换为CVPixelBufferRef

 * @param size 转化后的大小
 * @return 返回CVPixelBufferRef
 */
- (nullable CVPixelBufferRef)lx_pixelBufferRefWithSize:(CGSize)size;

/**
 * 将CMSampleBufferRef转换为UIImage

 * @param sampleBuffer  sampleBuffer数据
 * @return 返回UIImage
 */
+ (nullable UIImage *)lx_imageWithSampleBuffer:(CMSampleBufferRef)sampleBuffer;


/**
 * 将CVPixelBufferRef转换为UIImage

 * @param pixelBuffer pixelBuffer 数据
 * @return 返回UIImage
 */
+ (nullable UIImage*)lx_imageWithPixelBuffer:(CVPixelBufferRef)pixelBuffer;

/**
 * 将图片切割多个图片

 * @param row 行个数
 * @param column 列个数
 * @return 返回数组图片
 */
- (NSArray<UIImage *> *)lx_imageWithCutImageRow:(int)row column:(int)column;

/**
 * 图片裁剪成圆形图片
 */
- (nullable UIImage *)lx_imageClipCircle;

/**
 * 根据颜色生成一张图片
 */
+ (nullable UIImage *)lx_imageWithColor:(UIColor *)color;

/**
 * 根据颜色生成一张图片
 */
+ (nullable UIImage *)lx_imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 * 图片压缩

 * @param size 压缩的尺寸
 */
- (nullable UIImage *)lx_fitImageWithSize:(CGSize)size;

/**
 * 截图

 * @param view 截图的view
 */
+ (nullable UIImage *)lx_imageWithShotView:(UIView *)view;

/**

 * 使用GIF数据创建动画图像。创建后，您可以访问通过属性“.images”获取图像。如果数据不是动画gif，则函数与[UIImage imageWithData:data scale:scale]；
 * @讨论它有更好的显示性能，但需要更多的内存（宽度*高度*帧字节）。它只适合显示小gif，如动画表情。如果你想显示大gif
 * @返回由GIF创建的新图像，或在出现错误时返回零。
*/
+ (nullable UIImage *)lx_imageWithSmallGIFData:(NSData *)data scale:(CGFloat)scale;

/**
 * 创建并返回带有自定义绘图代码的图像。
*/
+ (nullable UIImage *)lx_imageWithSize:(CGSize)size drawBlock:(void (^)(CGContextRef context))drawBlock;

/**
 * 图像是否有alpha通道
*/
- (BOOL)lx_hasAlphaChannel;

/**
 * 在指定的矩形中绘制整个图像，内容随更改内容模式。
*/
- (void)lx_drawInRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode clipsToBounds:(BOOL)clips;

/**
 * 返回从此图像缩放的新图像，图像将根据需要拉伸。
*/
- (nullable UIImage *)lx_imageByResizeToSize:(CGSize)size;

/**
 * 返回从此图像缩放的新图像，图像内容将使用ContentMode更改。
*/
- (nullable UIImage *)lx_imageByResizeToSize:(CGSize)size contentMode:(UIViewContentMode)contentMode;

/**
 * 返回从此图像中剪切的新图像
*/
- (nullable UIImage *)lx_imageByCropToRect:(CGRect)rect;

/**
 * 获取灰色图片
 */
- (nullable UIImage *)lx_imageWithGrary;

/**
 *  美白图片
 *  @param whiteness  美白系数 建议 10-150之间  越大越白
 */
- (nullable UIImage *)lx_imageWithWhiteness:(int)whiteness;

/**
 *  磨皮美白图片
 *  @param touch        touch view上的点击点
 *  @param view         view 点击所在的View
 */
- (nullable UIImage *)lx_dermabrasionImageWithTouch:(UITouch *)touch view:(UIView *)view;

/**
 *用给定的颜色在alpha通道中对图像着色。
 *@param color 颜色
*/
- (nullable UIImage *)lx_imageByTintColor:(UIColor *)color;

/**
 *  合成后的图片 (以坐标为参考点，准确)
 *  @param mainImage        背景图
 *  @param mainImageFrame   背景图尺寸
 *  @param subImages        子图片数组
 *  @param subImageFrames   子图片尺寸数组
 */
+ (nullable UIImage *)lx_composeImagesToImage:(UIImage *)mainImage
                            mainImageFrame:(CGRect)mainImageFrame
                                 subImages:(NSArray *)subImages
                            subImageFrames:(NSArray<NSString *> *)subImageFrames;

/**
 * 返回一个新图像，该图像是从该图像中插入的边。

 * @参数insets Inset（正）对于每个边，值可以是负的“开始”。
 * @param color Extend edge的填充颜色，nil表示清晰的颜色。
 * @返回新图像，如果出现错误则返回nil。
*/
- (nullable UIImage *)lx_imageByInsetEdge:(UIEdgeInsets)insets withColor:(nullable UIColor *)color;

/**
 * 使用给定的角大小环绕新图像。
 
 * @参数半径每个角椭圆的半径。大于一半的值矩形的宽度或高度适当地夹在一半宽度或高度。
*/
- (nullable UIImage *)lx_imageByRoundCornerRadius:(CGFloat)radius;

/**
 * 用给定的角大小圆化新图像。

 * @param radius 每个角椭圆的半径。值大于矩形的宽度或高度被适当地钳制为一半宽度或高度的一半。
 * @param borderWidth 插入的边框线条宽度。值大于矩形的一半宽度或高度被适当地夹紧到宽度的一半或者身高。
 * @param borderColor 边框笔划颜色。nil表示清晰的颜色。
*/
- (nullable UIImage *)lx_imageByRoundCornerRadius:(CGFloat)radius
                                      borderWidth:(CGFloat)borderWidth
                                      borderColor:(nullable UIColor *)borderColor;
/**
 * 用给定的角大小圆化新图像。

 * @param radius 每个角椭圆的半径。值大于矩形的宽度或高度被适当地钳制为一半宽度或高度的一半。
 * @param corners 位掩码值，用于标识所需的角点四舍五入。可以使用此参数仅舍入子集矩形的角。
 * @param borderWidth 插入的边框线条宽度。值大于矩形的一半宽度或高度被适当地夹紧到宽度的一半或者身高。
 * @param borderColor 边框笔划颜色。nil表示清晰的颜色。
 * @param borderLineJoin 边界线连接。
*/
- (nullable UIImage *)lx_imageByRoundCornerRadius:(CGFloat)radius
                                          corners:(UIRectCorner)corners
                                      borderWidth:(CGFloat)borderWidth
                                      borderColor:(nullable UIColor *)borderColor
                                   borderLineJoin:(CGLineJoin)borderLineJoin;
/**
 * 返回一个新的旋转图像（相对于中心
 
 * @参数弧度逆时针旋转弧度。⟲
 * @param fitSize YES：新图像的大小扩展到适合所有内容，否：图像的大小不会改变，内容可能会被剪辑。
*/
- (nullable UIImage *)lx_imageByRotate:(CGFloat)radians fitSize:(BOOL)fitSize;

/**
 * 返回一个新的垂直或者水平图像
*/
- (UIImage *)lx_flipHorizontal:(BOOL)horizontal vertical:(BOOL)vertical;

/*
 * 占用的内存开销Memory
*/
- (NSUInteger)lx_imageCost;

@end

NS_ASSUME_NONNULL_END
