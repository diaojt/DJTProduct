//
//  ES_UserDefaults.m
//  Esun_DataPersistence_Example
//
//  Created by LiuPW on 2018/10/29.
//  Copyright © 2018 liupw. All rights reserved.
//

#import "ES_UserDefaults.h"

static NSUserDefaults *userDefaults = nil;
static ES_UserDefaults *es_userDefaults = nil;

@implementation ES_UserDefaults

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        es_userDefaults = [[ES_UserDefaults alloc]init];
        userDefaults = [NSUserDefaults standardUserDefaults];
    });
    return es_userDefaults;
}

#pragma mark - write
- (void)setStringObject:(NSString *)string forKey:(NSString *)key
{
    [userDefaults setObject:string forKey:key];
    [userDefaults synchronize];
}

- (void)setArrayObject:(NSArray *)array forKey:(NSString *)key
{
    [userDefaults setObject:array forKey:key];
    [userDefaults synchronize];
}

- (void)setDictionaryObject:(NSDictionary *)dictionary forKey:(NSString *)key
{
    [userDefaults setObject:dictionary forKey:key];
    [userDefaults synchronize];
}

- (void)setDataObject:(NSData *)data forKey:(NSString *)key
{
    [userDefaults setObject:data forKey:key];
    [userDefaults synchronize];
}

- (void)setInteger:(NSInteger)integerValue forKey:(NSString *)key
{
    [userDefaults setInteger:integerValue forKey:key];
    [userDefaults synchronize];
}

- (void)setFloatValue:(CGFloat)floatValue forKey:(NSString *)key
{
    [userDefaults setFloat:floatValue forKey:key];
    [userDefaults synchronize];
}

- (void)setDoubleValue:(double)doubleValue forKey:(NSString *)key
{
    [userDefaults setDouble:doubleValue forKey:key];
    [userDefaults synchronize];
}

- (void)setBoolValue:(BOOL)boolValue forKey:(NSString *)key
{
    [userDefaults setBool:boolValue forKey:key];
    [userDefaults synchronize];
}

- (void)removeObjectForKey:(NSString *)key
{
    [userDefaults removeObjectForKey:key];
}

#pragma mark -read
- (NSString *)stringForKey:(NSString *)aKey
{
    return [userDefaults objectForKey:aKey];
}

- (NSArray *)arrayForKey:(NSString *)aKey
{
    return [userDefaults arrayForKey:aKey];
}

- (NSDictionary *)dictionaryForKey:(NSString *)aKey
{
    return [userDefaults dictionaryForKey:aKey];
}

- (NSData *)dataObjectForKey:(NSString *)akey
{
    return [userDefaults dataForKey:akey];
}

- (NSInteger)integerValueForKey:(NSString *)akey
{
    return [userDefaults integerForKey:akey];
}

- (CGFloat)floatValueForKey:(NSString *)aKey
{
    return [userDefaults floatForKey:aKey];
}

- (double)doubleValueForKey:(NSString *)aKey
{
    return [userDefaults doubleForKey:aKey];
}

- (BOOL)boolValueForKey:(NSString *)aKey
{
    return [userDefaults boolForKey:aKey];
}
@end
