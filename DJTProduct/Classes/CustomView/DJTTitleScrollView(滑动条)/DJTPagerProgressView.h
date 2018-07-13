//
//  DJTPagerProgressView.h
//  DJTProduct
//
//  Created by Smy_D on 2018/7/13.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJTPagerProgressView : UIView

//进度条
@property (nonatomic, assign) CGFloat progress;
//尺寸
@property (nonatomic, strong) NSMutableArray *itemFrames;
//颜色
@property (nonatomic, assign) CGColorRef color;
//是否拉伸
@property (nonatomic, assign) BOOL isStretch;

@end
