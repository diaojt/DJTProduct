//
//  DJTViewFeatureViewController.m
//  DJTProduct
//
//  Created by Smy_D on 2018/7/12.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "DJTViewFeatureViewController.h"
#import "DJTViewFeatureNavBar.h"
#import "DJTitleScrollView.h"

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


// 测试代码
- (void)setupContentView
{
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.frame = self.view.bounds;
    contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    contentView.delegate = self;
    contentView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 1000);
    [self.view addSubview:contentView];
    self.contentView = contentView;
    CGFloat topInset = self.contentView.contentInset.top + NavigationBarHeightIncrease;
    self.contentView.contentInset = UIEdgeInsetsMake(topInset, 0, NavigationBarHeightIncrease, 0);
    self.contentView.contentOffset = CGPointMake(0, self.contentView.contentOffset.y-NavigationBarHeightIncrease);
    
    
    YYLabel *yylabel = [[YYLabel alloc] initWithFrame:CGRectMake(50, 150, 300, 40)];
    yylabel.font = [UIFont systemFontOfSize:20];
    yylabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    yylabel.numberOfLines = 2;
    yylabel.backgroundColor = [UIColor yellowColor];
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.firstLineHeadIndent = 10;
    NSString *text = [NSString stringWithFormat:@"精华"];
    NSString *totaltext = [NSString stringWithFormat:@"%@  哈哈哈哈",text];
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:totaltext attributes:@{NSParagraphStyleAttributeName:style}];

    YYTextBorder *border = [YYTextBorder new];
    border.cornerRadius = 0.5;
    border.strokeWidth = 0.5;
    border.strokeColor = [UIColor redColor];
    border.insets = UIEdgeInsetsMake(0.5, -2, 0.5, -2);
    border.lineStyle = YYTextLineStyleSingle;
    [attText setTextBorder:border range:NSMakeRange(0, text.length)];
    [attText setColor:[UIColor redColor] range:NSMakeRange(0, text.length)];
    [attText setFont:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(0, text.length)];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    button.backgroundColor = [UIColor redColor];
    NSMutableAttributedString *att = [NSMutableAttributedString attachmentStringWithContent:button contentMode:UIViewContentModeScaleAspectFit attachmentSize:button.frame.size alignToFont:[UIFont systemFontOfSize:20] alignment:YYTextVerticalAlignmentCenter];
    [attText insertAttributedString:att atIndex:0];

    [attText setBaselineOffset:[NSNumber numberWithInt:4] range:NSMakeRange(0, att.length)];
    yylabel.attributedText = attText;
    [self.contentView addSubview:yylabel];
    
  
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 300, 60, 40)];
    button2.backgroundColor = [UIColor redColor];
    [button2 addTarget:self action:@selector(toucheBtn2) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button2];
    
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



- (void)toucheBtn2
{
    NSString *weather = @"大雨";
    [self setAppIconWithName:weather];
}

- (void)setAppIconWithName:(NSString *)iconName {
    if (![[UIApplication sharedApplication] supportsAlternateIcons]) {
        return;
    }
    
    if ([iconName isEqualToString:@""]) {
        iconName = nil;
    }
    [[UIApplication sharedApplication] setAlternateIconName:iconName completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"更换app图标发生错误了 ： %@",error);
        }
    }];
}


@end
