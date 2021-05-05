//
//  CADisplayLink+Block.h
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/5/5.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LXDisplayLinkBlock) (CADisplayLink *displayLink);

@interface CADisplayLink (Block)

@property (nonatomic, copy)LXDisplayLinkBlock executeBlock;

+ (CADisplayLink *)displayLinkWithBlock:(LXDisplayLinkBlock)block;

@end

NS_ASSUME_NONNULL_END
