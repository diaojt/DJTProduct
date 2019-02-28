//
//  DJTStatusHelper.h
//  DJTProduct
//
//  Created by Smy_D on 2019/1/21.
//  Copyright © 2019年 Smy_D. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DJTStatusHelper : NSObject

/// 表情资源 bundle
+ (NSBundle *)emoticonBundle;

/// 表情正则 例如 [偷笑]
+ (NSRegularExpression *)regexEmoticon;

/// 表情字典 key:[偷笑] value:ImagePath
+ (NSMutableDictionary *)emoticonDic;

/// 图片 cache
+ (YYMemoryCache *)imageCache;

/// 从 bundle 里获取图片 (有缓存)
+ (UIImage *)imageNamed:(NSString *)name;

/// 从path创建图片 (有缓存)
+ (UIImage *)imageWithPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
