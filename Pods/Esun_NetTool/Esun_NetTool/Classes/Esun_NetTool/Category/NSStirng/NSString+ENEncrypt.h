//
//  NSString+MD5.h
//  ToolYu
//
//  Created by LiuPW on 16/7/19.
//  Copyright © 2016年 LiuPW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ENEncrypt)

/**
 md5加密

 @param sourceString 需要加密字符串
 @return 加密后结果
 */
+ (NSString *)en_md5:(NSString *)sourceString;


/**
 AES 128位 CFB8加密模式

 @param sourceStr 被加密字符串
 @param key 秘钥
 @return 加密后的密文
 */
+ (NSString *)aesEncryptSourceString:(NSString *)sourceStr secretKey:(NSString*)key;


/**
 AES 128位 CFB8解密模式

 @param secretStr 被解密的字符串
 @param key 秘钥
 @return 解密后的内容
 */
+ (NSString *)aesDencryptString:(NSString *)secretStr secretKey:(NSString *)key;


//字符串逆序 v4.0
-(NSMutableString*)reverseString;


//URLDecoding
- (NSString*)URLDecodedString;

@end
