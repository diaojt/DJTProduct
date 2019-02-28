//
//  ES_UserDefaults.h
//  Esun_DataPersistence_Example
//
//  Created by LiuPW on 2018/10/29.
//  Copyright © 2018 liupw. All rights reserved.
//

/**
 存储应用偏好设置及非敏感用户信息
 数据自动保存在沙盒的Library/Preferences目录下
 NSUserDefaults将输入的数据存储在.plist格式的文件下，这种存储方式决定了数据没有进行加密，安全性低，
 所有不建议存储一些敏感信息，如用户密码、token、加密私钥等！
 可以存储的数据类型为：NSNmuber（NSInteger，float，double，Bool）、NSString、NSData、NSArray、
 NSDictionary，保存对象均为不可变数据类型
 不支持自定义对象的存储，自定义对象需要归档为NSData进行存储
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ES_UserDefaults : NSObject


/**
 单例对象

 @return userDefaults
 */
+ (instancetype)shareInstance;


/**
 保存字符串对象到NSUserDefaults中

 @param object 被保存的对象NSString
 @param key 对象对应的key
 */
- (void)setStringObject:(NSString *)string forKey:(NSString *)key;


/**
 保存数组对象到NSUserDefaults中

 @param array 被保存的array
 @param key 对应的key
 */
- (void)setArrayObject:(NSArray *)array forKey:(NSString *)key;

/**
 保存字典对象到NSUserDefaults中

 @param dictionary 被保存的dictionary
 @param key 对应的key
 */
- (void)setDictionaryObject:(NSDictionary *)dictionary forKey:(NSString *)key;

/**
 保存data到userDefaults中

 @param data 被保存的对象
 @param key 对应的key
 */
- (void)setDataObject:(NSData *)data forKey:(NSString *)key;

/**
 存储NSInteger到userDefaults中

 @param integerValue 被保存的整形数据
 @param key 对应的key
 */
- (void)setInteger:(NSInteger)integerValue forKey:(NSString *)key;

/**
 存储CGFloat到userDefaults中

 @param floatValue 被保存的浮点数
 @param key 对应的key
 */
- (void)setFloatValue:(CGFloat)floatValue forKey:(NSString *)key;

/**
 保存双精度数据到userDefaults中

 @param doubleValue 被保存的双精度浮点数
 @param key 对应的key
 */
- (void)setDoubleValue:(double)doubleValue forKey:(NSString *)key;

/**
 保存bool数据到userDefaults中

 @param boolValue 被保存的值
 @param key 对应的key
 */
- (void)setBoolValue:(BOOL)boolValue forKey:(NSString *)key;

/**
 删除userDefaults中某个key的值

 @param key 键
 */
- (void)removeObjectForKey:(NSString *)key;

/**
 获取key对应的字符串

 @param aKey 键
 @return 对应的字符串
 */
- (NSString *)stringForKey:(NSString *)aKey;

/**
 获取aKey对应的数组

 @param aKey 键
 @return 对应的数组
 */
- (NSArray *)arrayForKey:(NSString *)aKey;

/**
 获取aKey对应的字典

 @param aKey 键
 @return 对应的字典
 */
- (NSDictionary *)dictionaryForKey:(NSString *)aKey;

/**
 获取key对应的NSData类型数据

 @param akey 键
 @return 对应的data
 */
- (NSData *)dataObjectForKey:(NSString *)akey;

/**
 获取aKey对应的整形数据

 @param akey 键
 @return 对应的value
 */
- (NSInteger)integerValueForKey:(NSString *)akey;

/**
 获取aKey对应的浮点数

 @param aKey 键
 @return 对应的value
 */
- (CGFloat)floatValueForKey:(NSString *)aKey;

/**
 获取aKey对应的v双精度浮点数

 @param aKey 键
 @return 对应的value
 */
- (double)doubleValueForKey:(NSString *)aKey;

/**
 获取aKey对应的value

 @param aKey 键
 @return 对应的value
 */
- (BOOL)boolValueForKey:(NSString *)aKey;

@end

NS_ASSUME_NONNULL_END
