//
//  DJTMainViewController.m
//  DJTProduct
//
//  Created by Smy_D on 2018/7/6.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "DJTMainViewController.h"
#import "DJTTabBar.h"
#import "DJTNavigationViewController.h"
#import "DJTNetFeatureViewController.h"
#import "DJTViewFeatureViewController.h"
#import "DJTPracticalFeatureViewController.h"
#import "DJTTripartiteFeatureViewController.h"

@implementation DJTMainViewController

+ (void)initialize
{
    UITabBarItem *appearance = [UITabBarItem appearance];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    [appearance setTitleTextAttributes:attrs forState                                                                                                    :UIControlStateSelected];
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 替换tabbar
    [self setValue:[[DJTTabBar alloc] init] forKey:@"tabBar"];
    
    // 初始化所有的子控制器
    [self setupChildViewControllers];
}



/**
 初始化所有的子控制器
 */
- (void)setupChildViewControllers
{
    DJTViewFeatureViewController *viewfeature = [[DJTViewFeatureViewController alloc] init];
    [self setupOneChildViewController:viewfeature title:@"视图" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
                                            
    DJTPracticalFeatureViewController *practicalfeature = [[DJTPracticalFeatureViewController alloc] init];
    [self setupOneChildViewController:practicalfeature title:@"实用" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
    
    DJTNetFeatureViewController *netfeature = [[DJTNetFeatureViewController alloc] init];
    [self setupOneChildViewController:netfeature title:@"网络" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
                                            
    DJTTripartiteFeatureViewController *tripartitefeature = [[DJTTripartiteFeatureViewController alloc] init];
    [self setupOneChildViewController:tripartitefeature title:@"三方" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
    
}

- (void)setupOneChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    [self addChildViewController:[[DJTNavigationViewController alloc]initWithRootViewController:vc]];
}


@end
