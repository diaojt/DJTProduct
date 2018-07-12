//
//  DJTTabBar.m
//  DJTProduct
//
//  Created by Smy_D on 2018/7/6.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "DJTTabBar.h"

@implementation DJTTabBar

- (nonnull instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        UIButton *publishButton = [[UIButton alloc] init];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [self addSubview:publishButton];
        
        WS(weakSelf);
        [publishButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf);
            make.size.mas_equalTo([publishButton backgroundImageForState:UIControlStateNormal].size);
        }];
        [publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)publishClick
{
    DJTLog(@"publishClick");
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //原来的4个
    CGFloat width = self.cst_width / 5;
    int index = 0;
    for (UIControl *control in self.subviews) {
        if (![control isKindOfClass:[UIControl class]] || [control isKindOfClass:[UIButton class]]) continue;
        control.cst_width = width;
        control.cst_x = index > 1 ? width * (index + 1) : width * index;
        index ++;
    }
}

@end
