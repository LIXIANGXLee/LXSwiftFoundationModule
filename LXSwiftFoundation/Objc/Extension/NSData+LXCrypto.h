//
//  NSData+LXCrypto.h
//  LXSwiftFoundation
//
//  Created by 李响 on 2022/3/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (LXCrypto)

- (NSData * _Nullable)lx_AES128EncryptWithKey:(NSString *)key;   //加密
- (NSData * _Nullable)lx_AES128DecryptWithKey:(NSString *)key;   //解密

@end

NS_ASSUME_NONNULL_END
