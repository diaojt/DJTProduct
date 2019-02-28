//
//  ENCommonData.h
//  CSLPaySDK
//
//  Created by LiuPW on 2017/10/23.
//  Copyright © 2017年 LiuPW. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kENTimestampLocal;  ///< 保存本地时间戳

extern NSString * const kENTimestampService; ///< 保存服务端时间戳

@interface ENCommonData : NSObject

//获取硬件型号 iPhone5/5S
+ (NSString *)getDeviceName;

//获取系统版本号
+ (NSString *)getSystemVersion;

//获取UUID
+ (NSString *)getDeviceUUID;

//获取服务端时间戳
+ (void)fetchTimeStamp;

//获取当前时间戳
+ (NSInteger)fetchCurrentTimeStamp;

@end
