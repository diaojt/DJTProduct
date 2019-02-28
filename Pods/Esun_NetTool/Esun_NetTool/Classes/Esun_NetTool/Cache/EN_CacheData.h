//
//  CacheData.h
//  ToolYu
//
//  Created by LiuPW on 16/7/20.
//  Copyright © 2016年 LiuPW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EN_CacheData : NSObject

//将服务器响应数据保存至本地
+ (void)cacheResponseObject:(id)responseObject
                    request:(NSURLRequest *)request
                 parameters:(NSDictionary *)params;

//从本地读取缓存数据
+ (id)readCacheResponseWithURL:(NSString *)url
                          params:(NSDictionary *)params;

//清除缓存
+ (void)clearCaches;

/**
 *  @author LiuPW, 16-07-20 19:07:15
 *
 *  计算缓存大小
 *
 *  @return 缓存值
 */
+ (unsigned long long)totalCacheSize;
@end
