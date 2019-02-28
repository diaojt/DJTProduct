//
//  NSString+ENNetworking.m
//  
//
//  Created by LiuPW on 2017/10/16.
//  Copyright © 2017年 LiuPW. All rights reserved.
//

#import "NSString+ENNetworking.h"

@implementation NSString (ENNetworking)

+ (NSString *)generateGetAbsoluteURL:(NSString *)url params:(NSDictionary *)params
{
    if (params == nil || [params count]==0 ||![params isKindOfClass:[NSDictionary class]]) {
        return url;
    }
    
    NSString *queries = @"";
    
    //仅对一级字典起作用
    for (NSString *key in params) {
        
        id value = params[key];
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        if ([value isKindOfClass:[NSArray class]]) {
            continue;
        }
        if ([value isKindOfClass:[NSSet class]]) {
            continue;
        }
        else
        {
            queries = [NSString stringWithFormat:@"%@%@=%@&",
                       queries.length == 0?@"&":queries,
                       key,
                       value];
        }
    }
    
    //去掉最后一个&
    if (queries.length>1) {
        queries = [queries substringToIndex:queries.length-1];
    }
    
    if (([url hasPrefix:@"http://"]||[url hasPrefix:@"https://"])&&[queries length]>1) {
        //? & 连接符
        //# 定位到网页中的具体位置，不会向服务器发起请求，但是会在浏览器产生记录，点击后退按钮，会回到原来的位置
        if ([url rangeOfString:@"?"].location != NSNotFound || [url rangeOfString:@"#"].location != NSNotFound) {
            url = [NSString stringWithFormat:@"%@%@",url,queries];
        }
        
        else
        {
            //去掉queries开头的&
            queries = [queries substringFromIndex:1];
            url = [NSString stringWithFormat:@"%@?%@",url,queries];
        }
    }
    
    return url.length == 0 ? queries:url;
}

+ (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString*
    outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                             
                                                                             NULL, /* allocator */
                                                                             
                                                                             (__bridge CFStringRef)input,
                                                                             
                                                                             NULL, /* charactersToLeaveUnescaped */
                                                                             
                                                                             (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                             
                                                                             kCFStringEncodingUTF8);
    
    
    return outputStr ;
}

+ (NSString *)DataToJsonString:(NSDictionary *)dic
{
    if (!dic) {
        return @"";
    }
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    
    NSString *jsonString = [[NSString alloc]initWithData:data
                                                encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (NSDictionary *)securityTheRequestParams:(NSDictionary *)sourceParams withRequestUrl:(NSString *)url
{
    //    NSString *jsonString = [NSString DataToJsonString:sourceParams] ;
    //
    //    if (jsonString.length == 0) {
    //        jsonString = @"{}";
    //    }
    //    NSString *utf8String = [NSString encodeToPercentEscapeString:jsonString];
    
    //3.拼接
    //    NSString *pinjie = [NSString stringWithFormat:@"#appkey=%@#param=%@#ts=%@",APPKey,utf8String,GETSTORAGE(TIMESTAMP)];
    //
    //    NSString *jiayuanchuan = [NSString stringWithFormat:@"%@%@",url,pinjie];
    //
    //    NSString *signNum = [jiayuanchuan md5String];
    //
    //    NSString *sourceStr = [NSString stringWithFormat:@"%@#%@#",signNum,APPKey];
    //    NSString *signResult = [sourceStr md5String];
    //
    //    NSMutableDictionary *resultParamsDic = [[NSMutableDictionary alloc]init];
    //    [resultParamsDic setValue:APPKey forKey:@"appkey"];
    //    [resultParamsDic setValue:utf8String forKey:@"param"];
    //    [resultParamsDic setValue:GETSTORAGE(TIMESTAMP) forKey:@"ts"];
    //    [resultParamsDic setValue:signResult forKey:@"sign"];
    
    //    return resultParamsDic;
    return @{};
}

@end
