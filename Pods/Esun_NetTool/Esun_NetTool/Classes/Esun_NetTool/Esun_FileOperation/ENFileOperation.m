//
//  FileOperation.m
//  ToolYu
//
//  Created by LiuPW on 16/7/19.
//  Copyright © 2016年 LiuPW. All rights reserved.
//

#import "ENFileOperation.h"

static NSString *CACHEPATH = @"networkingCachePath";

@implementation ENFileOperation

+ (NSString *)filePath:(NSString *)filePath
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [documentPath stringByAppendingPathComponent:filePath];
}

+ (NSString *)cacheFilePath
{
    return [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",CACHEPATH]];
}

+ (void)clearCachePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *cachePath = [self cacheFilePath];
    if ([manager fileExistsAtPath:cachePath]) {
        NSError *error = nil;
        
        [manager removeItemAtPath:cachePath error:&error];
        if (error) {
            NSLog(@"clear cache error:%@",error);
        }
        else
        {
            NSLog(@"clear cache Success");
        }
    }
}

+ (BOOL)copyFileName:(NSString *)fileName sourcePath:(NSString *)sourcePath
{
    BOOL copySuccess = YES;
    // 设定要拷贝文件的路径及名称
    NSString *postPlistSandBoxPath = [self filePath:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 判断文件是否已经存在
    BOOL isExisting = [fileManager fileExistsAtPath:postPlistSandBoxPath];
    
    if (!isExisting) {
        // 本地无此文件，则将此文件拷贝到本地目录。
        NSError *err;
        // 将Bundle中的文件拷贝至沙盒目录下
        [fileManager copyItemAtPath:sourcePath toPath:postPlistSandBoxPath error:&err];
        
        if (err) {
            NSLog(@"拷贝文件出错");
            copySuccess = NO;
        }
    }
    return copySuccess;
}
@end
