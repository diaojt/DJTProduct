//
//  UIViewController+HandleStatusBar.h
//  DJTProduct
//
//  Created by Smy_D on 2018/12/12.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (HandleStatusBar)

@property (nonatomic, strong) NSNumber *hideNum; ///< 0:隐藏 1:显示

- (void)setStatusBarAppearanceHidden:(BOOL)hided;

@end

NS_ASSUME_NONNULL_END
