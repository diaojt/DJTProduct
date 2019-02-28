//
//  EL_DeviceInfo.h
//  Esun_LogKit_Example
//
//  Created by LiuPW on 2018/10/11.
//  Copyright © 2018年 liupw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EL_DeviceInfo : NSObject

/**
 屏幕大小
 @returns 屏幕大小
 */
+(NSString*)getScreenSize;

//获取屏幕精度
+ (NSInteger)getScreenPrecision;

/**
 获取广告标示符（IDFA-identifierForIdentifier）
 @author    Created by Leo Hao on 2014-5-13
 */
+(NSString *)getIdfa;

/**
 @desc   获取app当前版本
 @param  nil
 @return String  app版本
 @author Created by Leo Hao on 2014-8-19
 */
+(NSString *)getAppVersion;

///获取当前版本号，不含小数点格式
+ (NSString *)fetchAppVersionWithNoDecimal;

/**
 @desc   获取手机系统版本
 @param  nil
 @return NSString  当前手机系统的版本
 @author Created by Leo Hao on 2014-8-19
 */
+(NSString *)getMobileSysVersion;


/**
 @desc   获取手机系统名
 @param  nil
 @return String  当前手机系统的名称
 
 @author Created by Leo Hao on 2014-7-24
 */
+(NSString *)getMobileName;


/**
 @desc   获取手机系统名
 @param  nil
 @return String  当前手机系统的名称
 
 @author Created by Leo Hao on 2014-7-24
 */
+(NSString *)getMobileSysName;


/**
 @desc   获取手机类型：真机，模拟器
 @param  nil
 @return String  当前手机系统的名称
 
 @author Created by Leo Hao on 2014-7-24
 */
+(NSString *)getMobileModel;



/**
 获取bundleID
 
 @return bundleID
 */
+ (NSString *)getBundelId;

@end

NS_ASSUME_NONNULL_END
