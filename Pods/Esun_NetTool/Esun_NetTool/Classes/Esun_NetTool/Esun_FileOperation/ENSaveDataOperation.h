//
//  ENSaveDataOperation.h
//  
//
//  Created by LiuPW on 2017/10/18.
//  Copyright © 2017年 LiuPW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CFBase.h>

@interface ENSaveDataOperation : NSObject

+ (instancetype)shareInstrance;

//MARK: - NSUserDefault 相关
/**
 @desc      保存对象到userDefault
 @param     object  要保存的对象
 @param     key     对象对应的key
 @authorCreated by LeoHao on 2014-08-21
 */
+(void)userDefault_setObject:(NSObject*)object forKey:(NSString *)key;

/**
 @desc      保存 整数 到userDefault
 @param     integer  要保存的数字
 @param     key     对象对应的key
 @authorCreated by LeoHao on 2014-08-21
 */
+(void)userDefault_setInteger:(NSInteger)integer forKey:(NSString *)key;

/**
 @desc      保存 浮点数 到userDefault
 @param     floatValue  要保存的数字
 @param     key     对象对应的key
 @authorCreated by LeoHao on 2014-08-21
 */
+(void)userDefault_setFloat:(float)floatValue forKey:(NSString *)key;

/**
 @desc      保存 double 到userDefault
 @param     doubleValue  要保存的数字
 @param     key     对象对应的key
 @authorCreated by LeoHao on 2015-05-25
 */
+(void)userDefault_setDouble:(double)doubleValue forKey:(NSString *)key;

/**
 @desc      保存 Bool 到userDefault
 @param     boolValue    要保存的bool值
 @param     key     对象对应的key
 @authorCreated by LeoHao on 2014-08-21
 */
+(void)userDefault_setBool:(BOOL)boolValue forKey:(NSString *)key;

/**
 @desc      从userDefault中移除一个对象
 @param     key     对象对应的key
 @authorCreated by LeoHao on 2014-08-21
 */
+(void)userDefault_removeObjectForKey:(NSString *)key;

/**
 @desc   获取UserDefault中对应key的值
 @author Created by LeoHao on 2014-12-19
 */
+(id)userDefault_objectForKey:(NSString *)key;

/**
 @desc   获取UserDefault中对应key的值
 @author Created by LeoHao on 2014-12-19
 */
+(BOOL)userDefault_boolForKey:(NSString *)key;


/**
 @desc   获取UserDefault中对应key的值
 @author Created by LeoHao on 2015-5-25
 */
+(double)userDefault_doubleForKey:(NSString *)key;


/**
 获取UserDefault中对应key的值

 @param key 键名
 @return float值
 */
+ (float)userDefault_floatForKey:(NSString *)key;



/**
 获取UserDefault中对应key的值

 @param key 键名
 @return Int值
 */
+ (NSInteger)userDefault_intForKey:(NSString *)key;

@end
