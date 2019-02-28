//
//  ENRequestConfig.m
//  CSLPaySDK
//
//  Created by LiuPW on 2017/10/20.
//  Copyright © 2017年 LiuPW. All rights reserved.
//

#import "EN_StartConfig.h"
#import "EN_NetWorking.h"
#import "ENCommonData.h"

#import "ENReachability.h"
#import "EN_StartConfig.h"
#import "NSString+ENCheck.h"

@interface EN_StartConfig()

@property (nonatomic, strong) ENReachability *reachability;

@end

@implementation EN_StartConfig


+ (instancetype)shareInstance
{
    static EN_StartConfig *startConfig = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        startConfig = [[EN_StartConfig alloc]init];
    });
    
    return startConfig;
}

- (void)networkConfigBaseUrl:(NSString *)baseUrl port:(NSString *)port
{
    //监听网络状态
    self.networkReachability = YES;
    [self obseverNetWork];
    
    //domain
    
    if ([NSString isAvailableString:port]) {
        baseUrl = [[NSString alloc]initWithFormat:@"%@:%@",baseUrl,port];
    }
    
    [EN_NetWorking updateBaseUrl:baseUrl];
    
    //开启网络请求调试日志
    [EN_NetWorking enableInterfaceDebug:NO];
}

- (void)obseverNetWork
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kENReachabilityChangedNotification object:nil];

    self.reachability = [ENReachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    ENReachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[ENReachability class]]);
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    switch (netStatus) {
        case NotReachable:
        {
            self.networkReachability = NO;
            
        }
            break;
            
        default:
        {
            self.networkReachability = YES;
        }
            break;
    }
}

@end
