//
//  testViewController.m
//  DJTProduct
//
//  Created by Smy_D on 2018/11/7.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "testViewController.h"

@interface testViewController ()

@end

@implementation testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self setUpData];
	[self setUpUI];

	[self setSubViewContraints];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Initial Method

/**
  添加视图
 */
- (void)setUpUI
{
    
}


/**
 数据初始化
 */
- (void)setUpData
{
    
}

#pragma mark -TargetAction


#pragma mark -privateMethod


#pragma mark -publicMethod


#pragma mark -UITableViewDataSource &UITableViewDelegate


#pragma mark -OtherDelegate


#pragma mark - lazyLoad

#pragma mark -layOut
- (void)setSubViewContraints
{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
