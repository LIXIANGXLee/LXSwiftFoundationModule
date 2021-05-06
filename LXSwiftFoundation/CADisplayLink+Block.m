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

- (void)setLx_executeBlock:(LXDisplayLinkBlock)lx_executeBlock {
    objc_setAssociatedObject(self,
                             @selector(lx_executeBlock),
                             lx_executeBlock,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);

}

- (LXDisplayLinkBlock)lx_executeBlock {
    return objc_getAssociatedObject(self,
                                    @selector(lx_executeBlock));
}

+ (CADisplayLink *)lx_displayLinkWithBlock:(LXDisplayLinkBlock)block {
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:[LXObjcProxy proxyWithTarget:self] selector:@selector(lx_displayLink:)];
    displayLink.lx_executeBlock = [block copy];
    return displayLink;
}

+ (void)lx_displayLink:(CADisplayLink *)displayLink {
    if (displayLink.lx_executeBlock) {
        displayLink.lx_executeBlock(displayLink);
    }
}

@end
