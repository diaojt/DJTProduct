//
//  DJTPracticalFeatureViewController.m
//  DJTProduct
//
//  Created by Smy_D on 2018/7/12.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "DJTPracticalFeatureViewController.h"

@interface DJTPracticalFeatureViewController ()

@end

@implementation DJTPracticalFeatureViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];

    [self setupNavBar];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

- (void)setupNavBar
{
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    self.navigationController.navigationBar.translucent = YES;
}
@end
