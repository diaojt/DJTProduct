//
//  ENCommonData.m
//  CSLPaySDK
//
//  Created by LiuPW on 2017/10/23.
//  Copyright © 2017年 LiuPW. All rights reserved.
//

#import "ENCommonData.h"
#import <UIKit/UIKit.h>
#import "EN_StartConfig.h"
#import "NSDictionary+ENCheck.h"
#import "ENSaveDataOperation.h"

NSString *const kENTimestampLocal = @"kENTimestampLocal";
NSString *const kENTimestampService = @"kENTimestampService";

@implementation ENCommonData

//获取设备型号
+ (NSString *)getDeviceName
{
    NSString *deviceName = [[UIDevice currentDevice] localizedModel];
    return deviceName;
}

//获取设备系统版本
+ (NSString *)getSystemVersion
{
    NSString *str_mobileSysVersion = [UIDevice currentDevice].systemVersion;
    return str_mobileSysVersion;
}

//获取UUID
+ (NSString *)getDeviceUUID
{
    NSString *uuidString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return uuidString;
}

+ (NSInteger)fetchCurrentTimeStamp
{
    //timeStamp
    NSInteger serviceTimeStamp = [ENSaveDataOperation userDefault_intForKey:kENTimestampService];
    
    NSDate *localdate = [ENSaveDataOperation userDefault_objectForKey:kENTimestampLocal];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval interval = [nowDate timeIntervalSinceDate:localdate];
    
    NSInteger nowTimeStamp = interval + serviceTimeStamp;
    return nowTimeStamp;
}

@end
