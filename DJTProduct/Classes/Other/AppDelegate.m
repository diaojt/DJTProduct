//
//  AppDelegate.m
//  DJTProduct
//
//  Created by Smy_D on 2018/7/6.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "AppDelegate.h"
#import "DJTMainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //设置根控制器
    self.window.rootViewController = [[DJTMainViewController alloc] init];
    
    //显示窗口
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}


- (void)applicationDidBecomeActive:(UIApplication *)application {

}


- (void)applicationWillTerminate:(UIApplication *)application {
   
}


@end
