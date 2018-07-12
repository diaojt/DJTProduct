//
//  DJTViewFeatureViewController.m
//  DJTProduct
//
//  Created by Smy_D on 2018/7/12.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "DJTViewFeatureViewController.h"



@interface DJTViewFeatureViewController ()<UIScrollViewDelegate>
@property(strong, nonatomic) UIScrollView *contentView;
@end

@implementation DJTViewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavBar];
    [self setupContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)setupNavBar
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.backgroundColor = [UIColor purpleColor];
}

- (void)setupContentView
{
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.backgroundColor = [UIColor orangeColor];
    contentView.frame = self.view.bounds;
    contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    contentView.delegate = self;
    contentView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 1000);
    UIView *tmp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    tmp.backgroundColor = [UIColor blueColor];
    [contentView addSubview:tmp];
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    DJTLog(@"test1-----%f",scrollView.contentOffset.y);
    NSInteger num = scrollView.contentOffset.y + 64;
    if (num < 0) {
        num = 0;
    }
    if (num > 64) {
        num = 64;
    }
    DJTLog(@"test2-----%ld",num);
    //0-64之间就是-num
    self.navigationController.navigationBar.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.f, -num);
}

@end
