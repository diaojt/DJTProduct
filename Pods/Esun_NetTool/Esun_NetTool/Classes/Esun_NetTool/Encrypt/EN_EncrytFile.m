//
//  ENEcrytFile.m
//  coyote
//
//  Created by LiuPW on 2017/8/31.
//  Copyright © 2017年 500wan. All rights reserved.
//

#import "EN_EncrytFile.h"
#import "NSString+ENEncrypt.h"
#import "ENCommonData.h"
#import "NSString+ENCheck.h"
#import "ENSaveDataOperation.h"
#import "NSDictionary+ENCheck.h"
#import "ENCommonData.h"
//#import "ESRC4_Encryption.h"
//#import "ESRB_EncriptUtil.h"

@implementation EN_EncrytFile

- (NSMutableArray *)needEncryArray
{
    if (!_needEncryArray) {
        _needEncryArray = [NSMutableArray arrayWithObjects:
                           @"url", nil];
    }
    return _needEncryArray;
}

- (NSMutableDictionary *)securyKeyDictionary
{
    if (!_securyKeyDictionary) {
        _securyKeyDictionary = [[NSMutableDictionary alloc]init];
    }
    return _securyKeyDictionary;
}

+ (instancetype)shareInstance
{
    static EN_EncrytFile *encryFile;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        encryFile = [[EN_EncrytFile alloc]init];
    });
    
    return encryFile;
}

+ (NSInteger)currentTimeStamp
{
    //timeStamp
    NSInteger serviceTimeStamp = [ENSaveDataOperation userDefault_intForKey:kENTimestampService];

    NSDate *localdate = [ENSaveDataOperation userDefault_objectForKey:kENTimestampLocal];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval interval = [nowDate timeIntervalSinceDate:localdate];

    NSInteger nowTimeStamp = interval + serviceTimeStamp;
    return nowTimeStamp;
}

+ (NSDictionary *)generateSecretKey:(NSString *)urlPath
{
//    设备码，取UUID
    NSString *deviceId = [ENCommonData getDeviceUUID];

    NSString *secretDeviceId = [NSString en_md5:deviceId];

    //salt
    NSString *saltValue = @"CSLSDK";

    //获取当前时间戳
    NSInteger nowTimeStamp = [self currentTimeStamp];
    NSString *nowTimeString = [NSString stringWithFormat:@"%ld",(long)nowTimeStamp];

    //拼接
    NSString *originSecretString = [NSString stringWithFormat:@"/%@%@%@%@",urlPath,secretDeviceId,saltValue,nowTimeString];

    NSString *secretKey = [NSString en_md5:originSecretString];

    return @{@"secretKey":secretKey,
             @"timestamp":nowTimeString};
}


//逆序 置换位置
+ (NSString *)mixUpSecretKey:(NSString *)key
{
    NSMutableString *reverseString = [key reverseString];

    NSString *preFourString = [reverseString substringToIndex:4];
    NSString *tailFourString = [reverseString substringFromIndex:(key.length - 4)];

    [reverseString replaceCharactersInRange:NSMakeRange(0, 4) withString:tailFourString];
    [reverseString replaceCharactersInRange:NSMakeRange(key.length -4, 4) withString:preFourString];

    return reverseString;
}


// MARK: - 数据处理
/**
 @desc   为网络请求组装参数
 @param params   需要序列化的数据源
 @return     直接修改数据源
 
 @author Created by LiuPW on 2017-8-31 周四
 */

+ (NSString *) getSortedDataFromParams:(NSDictionary *)params
{
    if ([NSDictionary isAvailableDictionary:params]) {
        NSMutableString *str_postParams = [NSMutableString stringWithString:@""];
        for (NSString *key in params.allKeys){
            [str_postParams appendFormat:@"%@=%@&",key,params[key]];
        }
        NSInteger index = str_postParams.length - 1;
        
        return [str_postParams substringToIndex:index];
    }
    else
    {
        return @"";
    }
}

+ (NSString *)encodeheadParms:(NSDictionary *)headParams bodyParams:(NSDictionary *)bodyParams withSecretKey:(NSString *)secretKey
{
    NSString *paramsString = nil;
    //[self getSortedDataFromParams:params];
    
    NSDictionary *params = @{@"head":headParams,
                             @"body":bodyParams};
    //dic to json
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"dic to json fail:%@",error);
        return @"error";
    }
    else
    {
        paramsString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    //AES加密
    NSString *aesEncodeString = [NSString aesEncryptSourceString:paramsString secretKey:secretKey];

    //解密
//    NSString *decodeString = [NSString aesDencryptString:aesEncodeString secretKey:secretKey];
    
    return aesEncodeString;
}


+ (NSString *)encodeParams:(NSDictionary *)params withSecretKey:(NSString *)secretKey
{
    NSString *paramsString = @"";
    
    //dic to json
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"dic to json fail:%@",error);
        return @"error";
    }
    else
    {
        paramsString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    //rc4 加密
    NSString *rc4EncodeString = [self encodeSourceString:paramsString withKey:secretKey];
    //    NSString *base64EncodeString = [ESRB_EncriptUtil base64Encode:rc4EncodeString];
    
    return rc4EncodeString;
}


/**
 解密RC4加密过的NSData数据,获取NSData
 @author    Created by Leo Hao on 2014-7-30
 */
+(NSString *)decodeData:(NSString *)encodedString withKey:(NSString *)key
{
    if ([NSString isAvailableString:encodedString]) {
//        ESRC4_Encryption *rc4Test = [[ESRC4_Encryption alloc] initWithKey:key];
//
//        char *buff = calloc(1, encodedString.length);
//
//
//        NSData *encodedData = [[NSData alloc]initWithBase64EncodedString:encodedString options:NSDataBase64DecodingIgnoreUnknownCharacters];
//
//        [rc4Test encryptData:encodedData outbuff:buff];
//
//        NSString *decode = [NSString stringWithCString:buff encoding:NSUTF8StringEncoding];


//        return decode;
        return @"";
    }
    else
    {
        return @"";
    }
}


/**
 RC4加密 结果已经做过base64

 @param sourceString 需要加密的数据源
 @param key 私钥
 @return 返回加密后的数据
 */
+ (NSString *)encodeSourceString:(NSString *)sourceString withKey:(NSString *)key
{
//    ESRC4_Encryption *rc4Test = [[ESRC4_Encryption alloc] initWithKey:key];
//    char *buff = calloc(1, [sourceString length]);
//
//    NSData * data = [[NSData alloc] initWithBytes:[rc4Test encryptString:sourceString outbuff:buff] length:([sourceString lengthOfBytesUsingEncoding:NSUTF8StringEncoding])];
//    NSString *strEncode = [ESRB_EncriptUtil base64Encode:data length:[sourceString length]];
////    free(buff);
//
//    return strEncode;
    
    return @"syrEncode";
}


/**
 String To Json

 @param jsonString 需要转换的字符串
 @return json格式
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (![NSString isAvailableString:jsonString]) {
        return nil;
    }
    
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
//    NSLog(@"data:%@",dic);
    
    return dic;
}

@end
