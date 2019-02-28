//
//  ENEcrytFile.h
//  coyote
//
//  Created by LiuPW on 2017/8/31.
//  Copyright © 2017年 500wan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EN_EncrytFile : NSObject

//需要加密的接口
@property (nonatomic, strong) NSMutableArray *needEncryArray;

//存储私钥
@property (nonatomic, strong) NSMutableDictionary *securyKeyDictionary;

+ (instancetype)shareInstance;

//获取当前时间戳
+ (NSInteger) currentTimeStamp;


/**
 生成密钥算法

 @param urlPath 当前urlpath
 @return @{secretKey:key
           timestamp:time}
 */
+ (NSDictionary *)generateSecretKey:(NSString *)urlPath;


//混淆参数
+ (NSString *)mixUpSecretKey:(NSString *)key;



// v4.0
//参数加密 dic -> string -> nsdata -> aes/cfb8/128bit -> base64
+ (NSString *)encodeheadParms:(NSDictionary *)headParams bodyParams:(NSDictionary *)bodyParams withSecretKey:(NSString *)secretKey;

// v4.0
//参数加密 dic -> string -> nsdata -> rc4 -> base64
+ (NSString *)encodeParams:(NSDictionary *)params withSecretKey:(NSString *)secretKey;

//rc4解密
+(NSString *)decodeData:(NSString *)encodedString withKey:(NSString *)key;


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
