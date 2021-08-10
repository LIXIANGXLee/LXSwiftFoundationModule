//
//  NSData+LXObjcAdd.m
//  LXSwiftFoundation
//
//  Created by 李响 on 2021/8/10.
//

#import "NSData+LXObjcAdd.h"

@implementation NSData (LXObjcAdd)

- (NSString *)lx_jsonDataToString {
    if (!self) return nil;

    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if (error) { return nil; }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
