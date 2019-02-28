//
//  CacheData.m
//  ToolYu
//
//  Created by LiuPW on 16/7/20.
//  Copyright © 2016年 LiuPW. All rights reserved.
//

#import "EN_CacheData.h"
#import "NSString+ENNetWorking.h"
#import "ENFileOperation.h"

#import "NSString+ENEncrypt.h"
#import "NSString+ENCheck.h"

@implementation EN_CacheData

+ (void)cacheResponseObject:(id)responseObject
                    request:(NSURLRequest *)request
                 parameters:(NSDictionary *)params
{
    if (request && responseObject && ![responseObject isKindOfClass:[NSNull class]]) {
        NSString *directoryPath = [ENFileOperation cacheFilePath];
        
        NSError *error = nil;
        
        
        if (![[NSFileManager defaultManager]fileExistsAtPath:directoryPath isDirectory:nil]) {
            [[NSFileManager defaultManager]createDirectoryAtPath:directoryPath
                                     withIntermediateDirectories:YES
                                                      attributes:nil
                                                           error:&error];
            
            if (error) {
                NSLog(@"create cache dir error: %@\n",error);
                return;
            }
        }
        
        NSString *absoluteURL = [NSString generateGetAbsoluteURL:request.URL.absoluteString
                                                          params:params];
        
        NSString *key = [NSString en_md5:absoluteURL];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        
        
        NSData *data = nil;
        
        if ([responseObject isKindOfClass:[NSData class]]) {
            data = responseObject;
        }
        else
        {
            data = [NSJSONSerialization dataWithJSONObject:responseObject
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
        }
        
        if (data && error==nil) {
            BOOL isOK = [[NSFileManager defaultManager]createFileAtPath:path
                                                               contents:data
                                                             attributes:nil];
            
            if (isOK) {
                NSLog(@"cache File ok for response");
            }
            else
            {
                NSLog(@"cache File error for response");
            }
        }
    }
}

//读取缓存
+ (id)readCacheResponseWithURL:(NSString *)url params:(NSDictionary *)params
{
    id cacheData = nil;
    
    if (url) {
        //try to get Data from Disk
        NSString *directoryPath = [ENFileOperation cacheFilePath];
        
        
        [NSString generateGetAbsoluteURL:url params:params];
        
        NSString *absoluteURL = [NSString generateGetAbsoluteURL:url params:params];
        NSString *key = [NSString en_md5:absoluteURL];
        
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        
        NSData *data = [[NSFileManager defaultManager]contentsAtPath:path];
        
        if (data) {
            cacheData = data;
            NSLog( @"Read data from cache for url :%@\n",url);
        }
    }
    
    return cacheData;
}

+ (void)clearCaches
{
    NSString *directoryPath = [ENFileOperation cacheFilePath];
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:directoryPath isDirectory:nil]) {
        NSError *error = nil;
        [[NSFileManager defaultManager]removeItemAtPath:directoryPath error:&error];
        if (error) {
            NSLog(@"清除缓存发生错误");
        }
        else
        {
            NSLog(@"clear Caches Success");
        }
    }
}


+ (unsigned long long)totalCacheSize
{
    NSString *directoryPath = [ENFileOperation cacheFilePath];
    BOOL isDir = NO;
    unsigned long long total = 0;
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDir]) {
            if (isDir) {
                NSError *error = nil;
                NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
                
                if (error == nil) {
                    for (NSString *subPath in array) {
                        NSString *path = [directoryPath stringByAppendingString:subPath];
                        NSDictionary *dict = [[NSFileManager defaultManager]attributesOfItemAtPath:path error:&error];
                        
                        if (!error) {
                            total += [dict[NSFileSize] unsignedIntegerValue ];
                        }
                    }
                }
            }
    }
    
    return total;
}
@end
