#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CADisplayLink+Block.h"
#import "LXObjcProxy.h"
#import "LXObjcThreadActive.h"
#import "LXObjcUtils.h"
#import "LXSwiftFoundation.h"
#import "UIView+LXObjcPerformance.h"

FOUNDATION_EXPORT double LXSwiftFoundationVersionNumber;
FOUNDATION_EXPORT const unsigned char LXSwiftFoundationVersionString[];

