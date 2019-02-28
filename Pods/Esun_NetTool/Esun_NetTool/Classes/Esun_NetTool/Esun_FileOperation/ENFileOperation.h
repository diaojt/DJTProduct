//
//  FileOperation.h
//  ToolYu
//
//  Created by LiuPW on 16/7/19.
//  Copyright © 2016年 LiuPW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ENFileOperation : NSObject

+ (NSString *)cacheFilePath;

+ (NSString*)filePath:(NSString *)filePath;

+ (void)clearCachePath;


+ (BOOL)copyFileName:(NSString *)fileName sourcePath:(NSString *)sourcePath;


@end
