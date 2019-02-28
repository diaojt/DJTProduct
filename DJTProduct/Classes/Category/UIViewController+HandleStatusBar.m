//
//  UIViewController+HandleStatusBar.m
//  DJTProduct
//
//  Created by Smy_D on 2018/12/12.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "UIViewController+HandleStatusBar.h"
#import <objc/runtime.h>
@implementation UIViewController (HandleStatusBar)

- (void)setHideNum:(NSNumber *)hideNum
{
    objc_setAssociatedObject(self, @selector(hideNum), hideNum, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (NSNumber *)hideNum
{
    NSNumber *num = objc_getAssociatedObject(self, _cmd);
    return num;
}

- (void)setStatusBarAppearanceHidden:(BOOL)isHided{
    
    self.hideNum = [NSNumber numberWithBool:isHided];
    
}


@end
