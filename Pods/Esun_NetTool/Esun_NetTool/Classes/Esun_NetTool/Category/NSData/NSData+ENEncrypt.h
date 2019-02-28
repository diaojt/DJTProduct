//
//  NSData+ENEncrypt.h
//  CSLPaySDK
//
//  Created by LiuPW on 2017/10/23.
//  Copyright © 2017年 LiuPW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData (ENEncrypt)


/**
 AES/CFB8/128位加解密

 @param operation AES加密
 @param keyData 秘钥
 @param ivData 偏移值
 @return 加密后字节流
 */
- (NSData *)AES128OperationWithEncriptionMode:(CCOperation)operation key:(NSData *)keyData iv:(NSData *)ivData;

@end
