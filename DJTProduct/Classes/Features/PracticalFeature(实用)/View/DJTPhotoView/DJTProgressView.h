//
//  DJTProgressView.h
//  DJTProduct
//
//  Created by Smy_D on 2019/1/24.
//  Copyright © 2019年 Smy_D. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DJTProgressView : UIView

/**
 线条背景色
 */
@property (nonatomic, strong) UIColor *pathBackColor;

/**
 线条填充色
 */
@property (nonatomic, strong) UIColor *pathFillColor;

/**
 起点角度。角度从水平右侧开始为0，顺时针为增加角度。直接传度数 如-90
 */
@property (nonatomic, assign) CGFloat startAngle;

/**
 减少的角度 直接传度数 如30
 */
@property (nonatomic, assign) CGFloat reduceValue;

/**
 线宽
 */
@property (nonatomic, assign) CGFloat strokeWidth;


/**
 是否显示小圆点
 */
@property (nonatomic, assign) BOOL showPoint;

/**
 是否显示文字
 */
@property (nonatomic, assign) BOOL showProgressText;

/**
 进度 0-1
 */
@property (nonatomic, assign) CGFloat progress;


//初始化 坐标 线条背景色 填充色 起始角度 线宽
- (instancetype)initWithFrame:(CGRect)frame
                pathBackColor:(UIColor *)pathBackColor
                pathFillColor:(UIColor *)pathFillColor
                   startAngle:(CGFloat)startAngle
                  strokeWidth:(CGFloat)strokeWidth;


/**
 删除
 */
- (void)removeProgressView;

@end

NS_ASSUME_NONNULL_END
