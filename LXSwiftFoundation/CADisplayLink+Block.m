//
//  CADisplayLink+Block.m
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/5/5.
//

#import "CADisplayLink+Block.h"
#import <objc/runtime.h>
#import "LXObjcProxy.h"

@implementation CADisplayLink (Block)

- (void)setExecuteBlock:(LXDisplayLinkBlock)executeBlock {
    objc_setAssociatedObject(self,
                             @selector(executeBlock),
                             executeBlock,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (LXDisplayLinkBlock)executeBlock {
    return objc_getAssociatedObject(self,
                                    @selector(executeBlock));
}

+ (CADisplayLink *)displayLinkWithBlock:(LXDisplayLinkBlock)block {
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:[LXObjcProxy proxyWithTarget:self] selector:@selector(lx_displayLink:)];
    displayLink.executeBlock = [block copy];
    return displayLink;
}

+ (void)lx_displayLink:(CADisplayLink *)displayLink {
    if (displayLink.executeBlock) {
        displayLink.executeBlock(displayLink);
    }
}

@end
