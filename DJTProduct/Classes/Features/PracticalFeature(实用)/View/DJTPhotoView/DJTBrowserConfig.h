//
//  DJTBrowserConfig.h
//  DJTProduct
//
//  Created by Smy_D on 2019/1/23.
//  Copyright © 2019年 Smy_D. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 样式
typedef NS_ENUM(NSUInteger, DJTBrowserLayoutStyle) {
    DJTBrowserLayoutStyleTimeline = 0, ///< 列表页
    DJTBrowserLayoutStyleDetail,       ///< 详情页
};

@interface DJTBrowserConfig : NSObject

/**
 大图图片数组
 */
@property (nonatomic, strong) NSArray<NSString *> *originalUrls;

/**
 小的图片数组
 */
@property (nonatomic, strong) NSArray<NSString *> *smallUrls;

/**
 图片间距
 */
@property (nonatomic, assign) CGFloat margin;

/**
 控件宽度
 */
@property (nonatomic, assign) CGFloat width;

/**
 图片尺寸
 */
@property (nonatomic, assign) CGSize picSize;
/**
 控件尺寸
 */
@property (nonatomic, assign) CGSize size;

/**
 控件内容尺寸
 */
@property (nonatomic, assign) CGSize contentSize;


/**
 背景颜色
 */
@property (nonatomic,strong) UIColor *collectionViewBackgroundColor;

/**
 进度条的颜色
 */
@property (nonatomic,strong) UIColor *progressPathFillColor;

/**
 进度条的背景视图的颜色
 */
@property (nonatomic,strong) UIColor *progressBackgroundColor;

/**
 进度条的宽度
 */
@property (nonatomic,assign) NSInteger progressPathWidth;

/**
 样式: 列表页 or 详情页
 */
@property (nonatomic,assign) DJTBrowserLayoutStyle browserStyle;

@end

NS_ASSUME_NONNULL_END
