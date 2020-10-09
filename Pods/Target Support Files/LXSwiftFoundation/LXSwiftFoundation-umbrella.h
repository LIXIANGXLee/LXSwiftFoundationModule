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

#import "LXObjcProxy.h"
#import "LXObjcSuport.h"
#import "LXObjcThreadActive.h"
#import "UIView+ObjcPerformance.h"

FOUNDATION_EXPORT double LXSwiftFoundationVersionNumber;
FOUNDATION_EXPORT const unsigned char LXSwiftFoundationVersionString[];

