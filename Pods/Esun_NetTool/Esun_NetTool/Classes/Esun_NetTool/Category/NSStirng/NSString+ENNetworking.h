//
//  NSString+ENNetworking.h
//
//
//  Created by LiuPW on 2017/10/16.
//  Copyright © 2017年 LiuPW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ENNetworking)

//将Get请求转换为URL格式
//仅对一级字典起作用
+ (NSString *)generateGetAbsoluteURL:(NSString *)url params:(NSDictionary *)params;

//encodeURL
+ (NSString *)encodeToPercentEscapeString: (NSString *) input;

//dic->String
+ (NSString *)DataToJsonString:(NSDictionary *)dic;

@end
