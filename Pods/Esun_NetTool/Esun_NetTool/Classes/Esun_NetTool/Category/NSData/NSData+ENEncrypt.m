//
//  NSData+ENEncrypt.m
//  CSLPaySDK
//
//  Created by LiuPW on 2017/10/23.
//  Copyright © 2017年 LiuPW. All rights reserved.
//

#import "NSData+ENEncrypt.h"

@implementation NSData (ENEncrypt)

- (NSData *)AES128OperationWithEncriptionMode:(CCOperation)operation key:(NSData *)key iv:(NSData *)iv {
    
    CCCryptorRef cryptor = NULL;
    // 1. Create a cryptographic context.
    CCCryptorStatus status = CCCryptorCreateWithMode(operation, kCCModeCFB8, kCCAlgorithmAES, ccNoPadding, [iv bytes], [key bytes], [key length], NULL, 0, 0, kCCModeOptionCTR_BE, &cryptor);
    
    NSAssert(status == kCCSuccess, @"Failed to create a cryptographic context.");
    
    NSMutableData *retData = [NSMutableData new];
    
    // 2. Encrypt or decrypt data.
    NSMutableData *buffer = [NSMutableData data];
    [buffer setLength:CCCryptorGetOutputLength(cryptor, [self length], true)]; // We'll reuse the buffer in -finish
    
    size_t dataOutMoved;
    status = CCCryptorUpdate(cryptor, self.bytes, self.length, buffer.mutableBytes, buffer.length, &dataOutMoved);
    NSAssert(status == kCCSuccess, @"Failed to encrypt or decrypt data");
    [retData appendData:[buffer subdataWithRange:NSMakeRange(0, dataOutMoved)]];
    
    // 3. Finish the encrypt or decrypt operation.
    status = CCCryptorFinal(cryptor, buffer.mutableBytes, buffer.length, &dataOutMoved);
    NSAssert(status == kCCSuccess, @"Failed to finish the encrypt or decrypt operation");
    [retData appendData:[buffer subdataWithRange:NSMakeRange(0, dataOutMoved)]];
    CCCryptorRelease(cryptor);
    
    return [retData copy];
}

@end
