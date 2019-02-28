//
//  EsunLog.m
//  Esun_LogKit_Example
//
//  Created by LiuPW on 2018/10/11.
//  Copyright © 2018年 liupw. All rights reserved.
//

#import "EsunLog.h"
#import "EL_DeviceInfo.h"
#import "EL_CustomLogFormatter.h"

@implementation EsunLog

+ (void)catchException
{
    //未捕捉到的异常 比如数组越界
    InstallUncaughtExceptionHandler();
    
    //捕捉信号异常
    InstallSignalHandler();
}

+ (void)saveFileRollingFrequency:(NSInteger)frequency maxFileNum:(NSInteger)fileNum andLogLevel:(DDLogLevel)level
{
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24* frequency; // 每个文件超过24小时后会被新的日志覆盖
    fileLogger.logFileManager.maximumNumberOfLogFiles = fileNum;  //最多保存7个日志文件
    [DDLog addLogger:fileLogger withLevel:level];//将对应等级信息写入文件
    fileLogger.logFormatter = [[EL_CustomLogFormatter alloc]init];
}

+ (void)saveDeviceAndUserInfo:(NSDictionary *)userInfo
{
    NSMutableDictionary *deviceAndUserInfoDic = [NSMutableDictionary dictionary];
    [deviceAndUserInfoDic setDictionary:userInfo];
    
     //e.g. @"iPhone", @"iPod touch"
    NSString *deviceModel = [EL_DeviceInfo getMobileModel];
    [deviceAndUserInfoDic setObject:deviceModel forKey:@"deviceModel"];
    
    //手机系统版本号
    NSString *mobileSystem = [EL_DeviceInfo getMobileSysName];
    [deviceAndUserInfoDic setObject:mobileSystem forKey:@"mobileSystem"];
    
    //systemVersion
    NSString *systemVersion = [EL_DeviceInfo getMobileSysVersion];
    [deviceAndUserInfoDic setObject:systemVersion forKey:@"systemVersion"];
    
    //分辨率
    NSString *resolution = [EL_DeviceInfo getScreenSize];
    [deviceAndUserInfoDic setObject:resolution forKey:@"resolution"];
    
    //idfa
    NSString *idfaString = [EL_DeviceInfo getIdfa];
    [deviceAndUserInfoDic setObject:idfaString forKey:@"idfa"];
    
    //BundelID
    NSString *bundleId = [EL_DeviceInfo getBundelId];
    [deviceAndUserInfoDic setObject:bundleId forKey:@"bundleID"];
    
    DDLogInfo(@"DeviceAndUserInfo:%@",deviceAndUserInfoDic);
}

+ (void)useDDLog
{
    [DDLog addLogger: [DDTTYLogger sharedInstance]];
    [DDTTYLogger sharedInstance].logFormatter = [[EL_CustomLogFormatter alloc]init];
}
@end
