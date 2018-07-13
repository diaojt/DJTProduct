//
//  DJTViewFeatureViewController.m
//  DJTProduct
//
//  Created by Smy_D on 2018/7/12.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "DJTViewFeatureViewController.h"
#import "DJTViewFeatureNavBar.h"

/**
 navBar向上滑动的距离，非iphoneX时为44+20，iphoneX时是44+10，因为刘海底部到navbar顶部有点缝隙，iphoneX的statusBar高度为44，但底部在刘海底部下边一点，并不是对齐刘海底部
 */
#define scrollUpHeight  (CGFloat)(kIs_iPhoneX?(54.0):(64.0))

extern CGFloat const NavigationBarHeightIncrease;

@interface DJTViewFeatureViewController ()<UIScrollViewDelegate>
@property(strong, nonatomic) UIScrollView *contentView;
@end

@implementation DJTViewFeatureViewController

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    [self setupContentView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupTitleView];
}

#pragma mark - 设置视图
- (void)setupNavBar
{
    //替换navBar
    [self.navigationController setValue:[[DJTViewFeatureNavBar alloc] init] forKey:@"navigationBar"];
}

- (void)setupTitleView
{
    //设置navigationBar的titleView
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    self.navigationController.navigationBar.translucent = YES;
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
    
    CGFloat topInset = self.contentView.contentInset.top + NavigationBarHeightIncrease;
    self.contentView.contentInset = UIEdgeInsetsMake(topInset, 0, NavigationBarHeightIncrease, 0);
    self.contentView.contentOffset = CGPointMake(0, self.contentView.contentOffset.y-NavigationBarHeightIncrease);
    
}



#pragma mark - UIScrollViewDelegate 代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat num = scrollView.contentOffset.y + kNavBarAndStatusBarHeight + NavigationBarHeightIncrease;
    if (num < 0) {
        num = 0;
    }
    if (num > scrollUpHeight) {
        num = scrollUpHeight;
    }
    // 0-scrollUpHeight 之间就是 -num
    self.navigationController.navigationBar.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.f, -num);
}

@end
