//
//  ENRequestConfig.h
//  CSLPaySDK
//
//  Created by LiuPW on 2017/10/20.
//  Copyright © 2017年 LiuPW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EN_StartConfig : NSObject

//定时请求时间戳 每隔5分钟请求一次
@property (nonatomic, strong) NSTimer *timeStampTimer;

//判断网络连接状态
@property (nonatomic, assign) BOOL networkReachability;

+ (instancetype)shareInstance;

//网络相关配置

/**
 配置基准URL和端口号

 @param baseUrl 基准URL一般是域名
 @param port 请求端口号
 */
- (void)networkConfigBaseUrl:(NSString *)baseUrl port:(NSString *)port;

@end
