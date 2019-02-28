//
//  EL_DeviceInfo.m
//  Esun_LogKit_Example
//
//  Created by LiuPW on 2018/10/11.
//  Copyright © 2018年 liupw. All rights reserved.
//

#import "EL_DeviceInfo.h"
#import <AdSupport/ASIdentifierManager.h>

@implementation EL_DeviceInfo

/**
 @desc   获取屏幕大小
 @author Created by LeoHao on 2014-08-20
 */
+(NSString*)getScreenSize{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width*[UIScreen mainScreen].scale;
    CGFloat height = size.height*[UIScreen mainScreen].scale;
    
    NSString* strReturn = [NSString stringWithFormat:@"%.0f*%.0f" , width , height];
    
    return strReturn;
}

//获取屏幕精度
+ (NSInteger)getScreenPrecision
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width*[UIScreen mainScreen].scale;
    CGFloat height = size.height*[UIScreen mainScreen].scale;
    
    NSInteger precision = 2;
    if (width * height > (1920*1080)-100) {
        precision = 3;
    }
    return precision;
}

/**
 获取广告标示符（IDFA-identifierForIdentifier）
 ios6及以上才可以用
 @author    Created by Leo Hao on 2014-5-13
 */
+(NSString *)getIdfa{
    
    NSString *str_idfa = @"";
    if ([ASIdentifierManager sharedManager].advertisingTrackingEnabled) {
        str_idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
    
    return str_idfa;
}

/**
 @desc   获取app当前版本
 @return String  app版本
 @author Created by Leo Hao on 2014-8-19
 */
+(NSString *)getAppVersion{
    //获取系统info.plist文件中的键值对
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    //获取软件的版本号
    NSString *version = [infoDict objectForKey:@"CFBundleShortVersionString"];
    return version;
}

/**
 @desc   获取app当前版本，不含小数点
 @return String  app版本
 @author Created by Leo Hao on 2014-8-19
 */
+ (NSString *)fetchAppVersionWithNoDecimal
{
    NSString *appVersionString = [self getAppVersion];
    NSString *versionNoDecimal = [appVersionString stringByReplacingOccurrencesOfString:@"." withString:@""];
    return versionNoDecimal;
}

/**
 @desc   获取手机系统版本
 @return NSString  当前手机系统的版本
 @author Created by Leo Hao on 2014-8-19
 */
+(NSString *)getMobileSysVersion{
    NSString *str_mobileSysVersion = [UIDevice currentDevice].systemVersion;
    return str_mobileSysVersion;
}


/**
 @desc   获取手机系统名
 @return String  当前手机系统的名称
 @author Created by Leo Hao on 2014-7-24
 */
+(NSString *)getMobileName{
    NSString *str_mobileName = [UIDevice currentDevice].name;
    return str_mobileName;
}


/**
 @desc   获取手机系统名
 @return String  当前手机系统的名称
 @author Created by Leo Hao on 2014-7-24
 */
+(NSString *)getMobileSysName{
    NSString *str_mobileSysName = [UIDevice currentDevice].systemName;
    return str_mobileSysName;
}


/**
 @desc   获取手机类型：真机，模拟器
 @return String  当前手机系统的名称
 @author Created by Leo Hao on 2014-7-24
  e.g. @"iPhone", @"iPod touch"
 */
+(NSString *)getMobileModel{
    return [UIDevice currentDevice].model;
}

+ (NSString *)getBundelId
{
    return [[NSBundle mainBundle]bundleIdentifier];
}

@end
