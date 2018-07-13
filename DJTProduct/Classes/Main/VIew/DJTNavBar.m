//
//  DJTNavBar.m
//  DJTProduct
//
//  Created by Smy_D on 2018/7/12.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "DJTNavBar.h"

// NavigationBar增加的高度
CGFloat const NavigationBarHeightIncrease = 40.f;

@implementation DJTNavBar

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    [self setTransform:CGAffineTransformMakeTranslation(0, -(NavigationBarHeightIncrease))];
}


- (void)layoutSubviews
{
    [super layoutSubviews];

    NSArray *classNamesToReposition = @[@"_UIBarBackground",@"_UINavigationBarContentView"];
    for (UIView *view in [self subviews]) {
        if ([classNamesToReposition containsObject:NSStringFromClass([view class])]) {

            CGRect bounds = [self bounds];
            CGRect frame = [view frame];
            
            bounds.size.height += NavigationBarHeightIncrease;
            frame.size.height += NavigationBarHeightIncrease;
            
            [view setBounds:bounds];
            [view setFrame:frame];
        }
    }
}


- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize navigationBarSize = [super sizeThatFits:size];
    navigationBarSize.height += NavigationBarHeightIncrease;
    return navigationBarSize;
}
@end
