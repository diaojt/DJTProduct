//
//  PrintLog.m
//  ToolYu
//
//  Created by LiuPW on 16/7/20.
//  Copyright © 2016年 LiuPW. All rights reserved.
//

#import "EN_PrintLog.h"
#import "NSString+ENNetWorking.h"


@implementation EN_PrintLog

+ (void)logWithSuccessResponse:(id)response url:(NSString *)url params:(NSDictionary *)params{
    NSLog(@"\n 查询成功");
    NSLog(@"\nRequest success,URL: %@\n prams:%@\n  response:%@\n",
             url,params,response);
}

@end
