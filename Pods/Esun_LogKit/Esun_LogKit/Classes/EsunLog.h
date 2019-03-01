//
//  EsunLog.h
//  Esun_LogKit_Example
//
//  Created by LiuPW on 2018/10/11.
//  Copyright © 2018年 liupw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Esun_LogKit/EL_LogLevel.h>

NS_ASSUME_NONNULL_BEGIN

@interface EsunLog : NSObject

@property (nonatomic, strong) DDFileLogger *fileLoger;

+ (instancetype)shareInstance;

/**
 捕捉崩溃日志，包含SIGException和UNCaughtException
 */
+ (void)catchException;


/**
 将日志写入文件的配置信息

 @param frequency 日志保存时间 以天为单位
 @param fileNum 保存最大的日志数量
 @param level 记录日志等级
 */
+ (void)saveFileRollingFrequency:(NSInteger)frequency maxFileNum:(NSInteger)fileNum andLogLevel:(DDLogLevel)level;



/**
 记录当前用户的硬件设备信息和用户信息

 @param userInfo 用户信息
 */
+ (void)saveDeviceAndUserInfo:(NSDictionary *)userInfo;


/**
 使用ddlog
 */
+ (void)useDDLog;


@end

NS_ASSUME_NONNULL_END
