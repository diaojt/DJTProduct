//
//  UIView+Custom.m
//  DJTProduct
//
//  Created by Smy_D on 2018/7/12.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "UIView+Custom.h"

@implementation UIView (Custom)
- (void)setCst_x:(CGFloat)cst_x
{
    CGRect frame = self.frame;
    frame.origin.x = cst_x;
    self.frame = frame;
}

- (void)setCst_y:(CGFloat)cst_y
{
    CGRect frame = self.frame;
    frame.origin.y = cst_y;
    self.frame = frame;
}

- (void)setCst_width:(CGFloat)cst_width
{
    CGRect frame = self.frame;
    frame.size.width = cst_width;
    self.frame = frame;
}

- (void)setCst_height:(CGFloat)cst_height
{
    CGRect frame = self.frame;
    frame.size.height = cst_height;
    self.frame = frame;
}

- (CGFloat)cst_x
{
    return self.frame.origin.x;
}

- (CGFloat)cst_y
{
    return self.frame.origin.y;
}

- (CGFloat)cst_width
{
    return self.frame.size.width;
}

- (CGFloat)cst_height
{
    return self.frame.size.height;
}

- (void)setCst_centerX:(CGFloat)cst_centerX
{
    CGPoint center = self.center;
    center.x = cst_centerX;
    self.center = center;
}

- (void)setCst_centerY:(CGFloat)cst_centerY
{
    CGPoint center = self.center;
    center.y = cst_centerY;
    self.center = center;
}

- (CGFloat)cst_centerX
{
    return self.center.x;
}

- (CGFloat)cst_centerY
{
    return self.center.y;
}
@end
