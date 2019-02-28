//
//  NSDictionary+Check.m
//  FBSDK
//
//  Created by LiuPW on 2017/10/16.
//  Copyright © 2017年 LiuPW. All rights reserved.
//

#import "NSDictionary+ENCheck.h"

@implementation NSDictionary (ENCheck)


/**
 检查字典是否为有效字典

 @param dictionary 被检查的字典
 @return 有效返回YES，无效返回NO
 */
+ (BOOL)isAvailableDictionary:(id)dictionary
{
    if (dictionary == nil) {
        return NO;
    }
    
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    
    if ([[dictionary allKeys] count] <= 0) {
        return NO;
    }
    
    return YES;
}

@end
