//
//  DJTPhotoBrowserCollectionViewCell.m
//  DJTProduct
//
//  Created by Smy_D on 2019/1/28.
//  Copyright © 2019年 Smy_D. All rights reserved.
//

#import "DJTPhotoBrowserCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import <SDWebImageManager.h>
#import "DJTPhotoListModel.h"
#import "DJTProgressView.h"
#import "DJTBrowserConfig.h"
#define ImageW ([UIScreen mainScreen].bounds.size.width - 4)

@interface DJTPhotoBrowserCollectionViewCell()<UIScrollViewDelegate, UIGestureRecognizerDelegate>
// 要上下滑动 所以要设置 scrollView
@property (nonatomic, strong) UIScrollView *scrollView;

// 添加拖动手势
@property (nonatomic, strong) UIPanGestureRecognizer *panGes;

// 添加点击手势
@property (nonatomic, strong) UITapGestureRecognizer *tapGes;

// 添加长按手势
@property (nonatomic, strong) UILongPressGestureRecognizer *lpGes;

// 进度条
@property (nonatomic, strong) DJTProgressView *progressView;


@end


@implementation DJTPhotoBrowserCollectionViewCell
{
    CGPoint firstTouchPoint;    // 手指第一次按的位置 用来判断方向
    CGPoint moveImgFirstPoint;  // 记录移动图片的第一次接触的位置
    NSTimer *_timer;            // 计时器 根据时长来判断是否删除图片
    CGFloat timeCount;          // 记录手指在图片上按压的时间 来判断是否继续展示 还是缩小
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        // 拖动手势
        self.panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewPressAction:)];
        self.panGes.delegate = self;
        
        
        // 点击手势
        self.tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapAction:)];
        self.tapGes.delegate = self;
        [self.scrollView addGestureRecognizer:self.tapGes];
        
        // 长按手势
        self.lpGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewLongPressAction:)];
        self.lpGes.minimumPressDuration = 1.5;
        self.lpGes.delegate = self;
        [self.imageView addGestureRecognizer:self.lpGes];
        
    }
    
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 记录刚接触时的坐标 记录这个坐标 与移动的坐标 两个点来判断滑动方向
    firstTouchPoint = [touch locationInView:self.window];
    return YES;
    
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return YES;
    }
    
    // 判断是否是左右滑动 滑动区间设置为 +-10
    CGPoint touchPoint = [gestureRecognizer locationInView:self.window];
    CGFloat dirTop = firstTouchPoint.y - touchPoint.y;
    if (dirTop > -10 && dirTop < 10) {
        return NO;
    }
    
    // 判断是否是上下滑动
    CGFloat dirLift = firstTouchPoint.x - touchPoint.x;
    if (dirLift > -10 && dirLift < 10 && self.imageView.frame.size.height > [UIScreen mainScreen].bounds.size.height) {
        return NO;
    }
    
    return YES;
    
}

/**
 缩放图片的时候将图片放在中间
 
 @param scrollView 背景scrollView
 */
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                        scrollView.contentSize.height * 0.5 + offsetY);
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // 返回需要缩放的 view
    return self.imageView;
}

// 图片各种手势的处理
- (void)imageViewPressAction:(UIPanGestureRecognizer *)ges
{
    // 获取手势坐标
    CGPoint movePoint = [ges locationInView:self.window];
    
    // 判断手势状态
    switch (ges.state) {
        case UIGestureRecognizerStateBegan:
            // 创建_timer 记录手指停留时间 判断是否隐藏图片
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(redurecd) userInfo:nil repeats:YES];
            // 第一次接触的点 根据该点坐标计算缩放比例
            moveImgFirstPoint = [ges locationInView:self.window];
            break;
        case UIGestureRecognizerStateChanged:
        {
            // 缩放比例（背景渐变比例）
            CGFloat offset = fmin((1-(fabs(movePoint.y - moveImgFirstPoint.y)/(0.5*[UIScreen mainScreen].bounds.size.height))), 1);
            
            // 设置最小的缩放比例为 0.5
            CGFloat offset_y = fmax(offset, 0.5);
            
            // 仿射变换
            CGAffineTransform transform1 = CGAffineTransformMakeTranslation((movePoint.x - moveImgFirstPoint.x), (movePoint.y - moveImgFirstPoint.y));
            self.imageView.transform = CGAffineTransformScale(transform1, offset_y, offset_y);
            
            // 设置alpha的值
            [self.delegate backgroundAlpha:offset_y];
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            // 触摸结束
            // 如果手指停留时间大于1秒 那么就恢复大图状态
            // 否则就缩小隐藏图片
            if (timeCount > 1) {
                [UIView animateWithDuration:0.2 animations:^{
                    CGAffineTransform transform1 = CGAffineTransformMakeTranslation(0, 0);
                    self.imageView.transform = CGAffineTransformScale(transform1, 1, 1);
                    [self.delegate backgroundAlpha:1];
                }];
            }else{
                [self hiddenAction];
            }
            // 清除_timer
            timeCount = 0;
            [_timer invalidate];
            _timer = nil;
            
        }
            break;
            
        default:
            break;
    }
}

// 记录手指停留时间
- (void)redurecd
{
    timeCount += 0.1;
}


// 点击手势
- (void)imageViewTapAction:(UITapGestureRecognizer *)ges
{
    [self.scrollView setZoomScale:1];
    [self.scrollView setContentOffset:CGPointZero];
    [self hiddenAction];
    
}


// 隐藏
- (void)hiddenAction
{
    if (self.progressView) {
        [self.progressView removeProgressView];
    }
    [self.delegate hiddenAction:self];
}

- (void)imageViewLongPressAction:(UILongPressGestureRecognizer *)ges
{
    NSLog(@"Long Press");
}

- (void)setPhotoModel:(DJTPhotoModel *)photoModel
{
    _photoModel = photoModel;
    UIImage *cacheImg = [self sdCacheImg:self.photoModel.picURL];
    [self loadImage:self.photoModel.picURL cacheImg:cacheImg];
}

- (void)loadImage:(NSString *)picurl cacheImg:(UIImage *)cacheImg
{
    // 下载图片
    if ([self.scrollView.gestureRecognizers containsObject:self.panGes]) {
        [self.scrollView removeGestureRecognizer:self.panGes];
    }
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:picurl] placeholderImage:cacheImg options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.progress = (float)receivedSize/(float)expectedSize;
        });
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (![self.scrollView.gestureRecognizers containsObject:self.panGes]) {
            [self.scrollView addGestureRecognizer:self.panGes];
        }
        [self.progressView removeProgressView];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateImageViewWithImage:image];
        });
    }];
}

// 更新图片的位置
- (void)updateImageViewWithImage:(UIImage *)image
{
    // 如果 image 等于空 说明下载失败 可在此处设置下载失败的背景图片
    if (!image) {
        UIImage *errorImg = [UIImage imageNamed:@"DJTBroswerImg.bundle/imageerror"];
        self.imageView.frame = [self configImageSize:errorImg];
        self.imageView.image = errorImg;
    }
    else{
        // 根据手机宽度适配图片大小
        self.imageView.frame = [self configImageSize:image];
        
    }
    self.scrollView.contentSize = CGSizeMake(self.imageView.frame.size.width, self.imageView.frame.size.height);
    
}


// 从SDWebImage中获取缓存的图片
- (UIImage *)sdCacheImg:(NSString *)picurl
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString *key = [manager cacheKeyForURL:[NSURL URLWithString:picurl]];
    SDImageCache *cache = [SDImageCache sharedImageCache];
    return [cache imageFromDiskCacheForKey:key];
}

// 根据图片大小 适配手机 更改图片大小
- (CGRect)configImageSize:(UIImage *)image
{
    CGFloat imageViewY = 0;
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    CGFloat fitWidth = ImageW;
    CGFloat fitHeight = fitWidth * imageHeight / imageWidth;
    
    if (fitHeight < [UIScreen mainScreen].bounds.size.height) {
        imageViewY = ([UIScreen mainScreen].bounds.size.height - fitHeight) * 0.5;
    }
    
    return CGRectMake(2, imageViewY, fitWidth, fitHeight);
}

// 注销_timer
- (void)dealloc
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}


- (DJTProgressView *)progressView
{
    if (_progressView == nil) {
        _progressView = [[DJTProgressView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 80)/2, ([UIScreen mainScreen].bounds.size.height - 80)/2, 80, 80) pathBackColor:self.photoModel.config.progressBackgroundColor?:[UIColor grayColor] pathFillColor:self.photoModel.config.progressPathFillColor?:[UIColor whiteColor] startAngle:90 strokeWidth:self.photoModel.config.progressPathWidth?:3];
        [self.contentView addSubview:_progressView];
    }
    return _progressView;
}


- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        [self.scrollView addSubview:_imageView];
        _imageView.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - 300)/2, [UIScreen mainScreen].bounds.size.width, 300);
        _imageView.backgroundColor = [UIColor grayColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.userInteractionEnabled = YES;
        
    }
    return _imageView;
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.maximumZoomScale = 2;
        _scrollView.minimumZoomScale = 1;
        
    }
    return _scrollView;
    
}

@end
