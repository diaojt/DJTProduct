//
//  DJTRefreshFooter.m
//  DJTProduct
//
//  Created by Smy_D on 2018/12/6.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "DJTRefreshFooter.h"

@interface DJTRefreshFooter()
// 箭头样式
@property (strong, nonatomic) UIImageView *arrowView;
@property (strong, nonatomic) UIImageView *loadingView;

@end

@implementation DJTRefreshFooter

#pragma mark - 懒加载子控件
- (UIImageView *)arrowView
{
    if (!_arrowView) {
        
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh_up_arrow"]];
        [self addSubview:_arrowView = arrowView];
    }
    return _arrowView;
}


- (UIImageView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh_rotate"]];
        [self addSubview:_loadingView];
    }
    return _loadingView;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    
    self.loadingView = nil;
    [self setNeedsLayout];
}


#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    // 初始化文字
    [self setTitle:@"上拉加载" forState:MJRefreshStateIdle];
    [self setTitle:@"松开显示" forState:MJRefreshStatePulling];
    [self setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [self setTitle:@"加载完毕" forState:MJRefreshStateNoMoreData];
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.labelLeftInset = 10;
    [self.stateLabel setFont:[UIFont systemFontOfSize:14]];
    self.stateLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    // 箭头的中心点
    CGFloat arrowCenterX = self.mj_w * 0.5;
    if (!self.stateLabel.hidden) {
        arrowCenterX -= self.labelLeftInset + self.stateLabel.mj_textWith * 0.5;
    }
    CGFloat arrowCenterY = self.mj_h * 0.5;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    
    // 箭头
    if (self.arrowView.constraints.count == 0) {
        self.arrowView.mj_size = self.arrowView.image.size;
        self.arrowView.center = arrowCenter;
    }
    
    // 圈圈
    if (self.loadingView.constraints.count == 0) {
        self.loadingView.center = arrowCenter;
    }
    
    self.arrowView.tintColor = self.stateLabel.textColor;
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing) {
           self.arrowView.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.loadingView.alpha = 0.0;
            } completion:^(BOOL finished) {
                // 防止动画结束后，状态已经不是MJRefreshStateIdle
                if (state != MJRefreshStateIdle) return;
                self.loadingView.alpha = 1.0;
                [self loadingViewStopAnimating];
                self.arrowView.hidden = NO;
            }];
        } else {
            self.arrowView.hidden = NO;
            [self loadingViewStopAnimating];
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.arrowView.transform = CGAffineTransformIdentity;
            }];
             
        }
    } else if (state == MJRefreshStatePulling) {
        self.arrowView.hidden = NO;
        [self loadingViewStopAnimating];
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            
            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
        }];
    } else if (state == MJRefreshStateRefreshing) {
        self.arrowView.hidden = YES;
        [self loadingViewStartAnimating];
    } else if (state == MJRefreshStateNoMoreData) {
        self.arrowView.hidden = YES;
        [self loadingViewStopAnimating];
    }
}


- (void)loadingViewStartAnimating{
    [self.loadingView.layer removeAllAnimations];
    self.loadingView.hidden = NO;
    CABasicAnimation *anima3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anima3.toValue = [NSNumber numberWithFloat:M_PI*2];
    anima3.duration = 0.6f;
    anima3.repeatCount = MAXFLOAT;
    [self.loadingView.layer addAnimation:anima3 forKey:@"rotaionAniamtion"];
}
- (void)loadingViewStopAnimating{
    [self.loadingView.layer removeAllAnimations];
    self.loadingView.hidden = YES;
}

@end
