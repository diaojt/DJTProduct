//
//  NSString+MD5.m
//  ToolYu
//
//  Created by LiuPW on 16/7/19.
//  Copyright © 2016年 LiuPW. All rights reserved.
//

#import "NSString+ENEncrypt.h"
#import "NSData+ENEncrypt.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString+ENCheck.h"

#define AESCFB8IVSTR        @"aaaaaaaaaaaaaaaa"

@implementation NSString (ENEncrypt)

+ (NSString *)en_md5:(NSString *)sourceString
{
    if (sourceString == nil || sourceString.length == 0) {
        return nil;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH],i;
    CC_MD5([sourceString UTF8String],(int)[sourceString lengthOfBytesUsingEncoding:NSUTF8StringEncoding],digest);
    
    NSMutableString *ms = [NSMutableString string];
    for (i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x",(int)(digest[i])];
    }
    
    return [ms copy];
}

+ (NSString *)aesEncryptSourceString:(NSString *)sourceStr secretKey:(NSString *)key
{
    NSData *sourceData = [sourceStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *ivData = [AESCFB8IVSTR dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *encryptData = [sourceData AES128OperationWithEncriptionMode:kCCEncrypt key:keyData iv:ivData];
    
    NSString *encryptString = [encryptData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return encryptString;
}

+ (NSString *)aesDencryptString:(NSString *)secretStr secretKey:(NSString *)key
{
    
    NSData *encryptData = [[NSData alloc]initWithBase64EncodedString:secretStr options:NSDataBase64DecodingIgnoreUnknownCharacters];

    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *ivData = [AESCFB8IVSTR dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *dencryptData = [encryptData AES128OperationWithEncriptionMode:kCCDecrypt key:keyData iv:ivData];
    
    NSString *dencryptString = [[NSString alloc]initWithData:dencryptData encoding:NSUTF8StringEncoding];
//    NSLog(@"jieMi:%@",dencryptString);
    
    return dencryptString;
}


//字符串逆序
-(NSMutableString*)reverseString
{
    NSUInteger length = [self length];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:length];
    
    for(long i=length-1; i>=0; i--)
    {
        unichar c = [self characterAtIndex:i];
        [array addObject:[NSString stringWithFormat:@"%c",c]];
    }
    
    NSMutableString *str = [NSMutableString stringWithCapacity:length];
    for(int i=0; i<=length-1; i++)
    {
        [str appendString:array[i]];
    }
    return str;
}


- (NSString *)URLDecodedString
{
    if (![NSString isAvailableString:self]) {
        return @"";
    }
    
    
    NSString *result = self,*str_toDecode = self;
    BOOL bl_isUrl = true;
    if (![str_toDecode hasPrefix:@"http"]) {
        str_toDecode = [NSString stringWithFormat:@"http://encodeSeparator%@",str_toDecode];
        bl_isUrl = false;
    }
    
    @try {
        result = (NSString *)
        CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                  (CFStringRef)str_toDecode,
                                                                                  CFSTR(""),
                                                                                  kCFStringEncodingUTF8));
    }
    @catch (NSException *exception) {
        
    }
    if (bl_isUrl == false) {
        result = [result componentsSeparatedByString:@"encodeSeparator"][1];
    }
    
    return result;
}

@end
