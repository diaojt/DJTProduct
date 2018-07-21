//
//  DJTitleScrollView.m
//  DJTProduct
//
//  Created by Smy_D on 2018/7/13.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "DJTitleScrollView.h"
#import "DJTPagerProgressView.h"


//常数量
CGFloat const DJTPagerMargin = 10;
//按钮tag附加值
CGFloat const DJTButtonTagValue = 120;
//默认标题栏高度
CGFloat const DJTNormalTitleViewH = 41;
//下划线默认高度
CGFloat const DJTUnderLineH = 3;
//距离屏幕左边距
CGFloat const DJTLeftMargin = 15;

@interface DJTitleScrollView()<UIScrollViewDelegate>
{
    //未选中颜色
    UIColor *_norColor;
    //选中颜色
    UIColor *_selColor;
    //背景颜色
    UIColor *_titleScrollViewBgColor;
}

//标题滚动视图
@property (strong , nonatomic)UIScrollView *titleScrollView;

//滚动条
@property (nonatomic, strong) DJTPagerProgressView *pregressView;

//标题按钮
@property (strong , nonatomic)UIButton *titleButton;

//上一次选择的按钮
@property (weak , nonatomic)UIButton *lastSelectButton;

//指示条的frames
@property (nonatomic, strong) NSMutableArray *pregressFrames;

//是否加载过标题
@property (nonatomic,assign)BOOL isLoadTitles;


//标题背景色
@property (nonatomic, strong) UIColor *titleScrollViewBgColor;
//正常标题颜色
@property (nonatomic, strong) UIColor *norColor;
//选中标题颜色
@property (nonatomic, strong) UIColor *selColor;
//指示器颜色
@property (nonatomic, strong) UIColor *proColor;
//标题字体
@property (nonatomic, strong) UIFont *titleFont;
//字体缩放比例
@property (nonatomic, assign) CGFloat titleScale;
//指示器的长度
@property (nonatomic, assign) CGFloat progressLength;
//指示器的宽度
@property (nonatomic, assign) CGFloat progressHeight;


//是否显示底部指示器
@property (nonatomic, assign) BOOL isShowPregressView;
//是否加载弹簧动画
@property (nonatomic, assign) BOOL isOpenStretch;
//是否开启渐变
@property (nonatomic, assign) BOOL isOpenShade;



//开始颜色,取值范围0~1

@property (nonatomic, assign) CGFloat startR;

@property (nonatomic, assign) CGFloat startG;

@property (nonatomic, assign) CGFloat startB;


//完成颜色,取值范围0~1

@property (nonatomic, assign) CGFloat endR;

@property (nonatomic, assign) CGFloat endG;

@property (nonatomic, assign) CGFloat endB;

@end

@implementation DJTitleScrollView

#pragma mark - 初始化
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleScrollView.frame = CGRectMake(0, 0, kScreenWidth, DJTNormalTitleViewH);
        [self addSubview:self.titleScrollView];
        
        WS(weakSelf);
        [self.titleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.mas_top);
            make.left.mas_equalTo(weakSelf.mas_left);
            make.right.mas_equalTo(weakSelf.mas_right);
            make.height.mas_equalTo(weakSelf.mas_height);

        }];
        
    }
    
    return self;
}


#pragma mark - 提供外部接口
#pragma mark - 标题缩放处理
- (void)setUpTitleScale:(void(^)(CGFloat *titleScale))titleScaleBlock
{
    //titleScaleBlock回调
    !titleScaleBlock ? : titleScaleBlock(&_titleScale);
}

#pragma mark - Progress属性设置
- (void)setUpProgressAttribute:(void(^)(CGFloat *progressLength, CGFloat *progressHeight))settingProgressBlock
{
    //如果隐藏Progress指示器则返回
    if (_isShowPregressView == NO) return;
    //指示器属性设置Block
    !settingProgressBlock ? : settingProgressBlock(&_progressLength,&_progressHeight);
}

#pragma mark - 初始化
- (void)setUpDisplayStyle:(void(^)(UIColor **titleScrollViewBgColor,UIColor **norColor,UIColor **selColor,UIColor **proColor,UIFont **titleFont,BOOL *isShowPregressView,BOOL *isOpenStretch,BOOL *isOpenShade))BaseSettingBlock
{
    UIColor *titleScrollViewBgColor;
    UIColor *norColor;
    UIColor *selColor;
    UIColor *proColor;
    UIFont *titleFont;
    
    BOOL isShowPregressView = YES;
    BOOL isOpenStretch;
    BOOL isOpenShade;
    
    if (BaseSettingBlock) { //属性
        BaseSettingBlock(&titleScrollViewBgColor,&norColor,&selColor,&proColor,&titleFont,&isShowPregressView,&isOpenStretch,&isOpenShade);
        
        self.titleScrollViewBgColor = titleScrollViewBgColor;
        self.norColor = norColor;
        self.selColor = selColor;
        self.proColor = proColor;
        self.titleFont = titleFont;
        
        self.isOpenShade = isOpenShade;
        self.isOpenStretch = isOpenStretch;
        self.isShowPregressView = isShowPregressView;
    }
}


//设置所有标题
- (void)setUpAllTitleWithArray:(NSMutableArray *)titleArr
{
    if (self.titleButtonArray.count > 0) {
        for (UIButton *btn in self.titleButtonArray) {
            [btn removeFromSuperview];
        }
    }
    [self.titleButtonArray removeAllObjects];
    [self.pregressFrames removeAllObjects];
    [self.pregressView removeFromSuperview];
    
    NSInteger titleCount =  titleArr.count;
    //标题长度和
    CGFloat screenTitleWidth = 0;
    CGFloat sumTitleWidth = 0;
    for (int i= 0; i < titleArr.count; i++) {
        NSString *tmpTitle = titleArr[i];
        CGSize titleSize = [tmpTitle sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
        sumTitleWidth += titleSize.width;
    }
    //标题间的间距,计算出来
    CGFloat titleSpacing = 0;
    if (titleCount < 6) {
        titleSpacing = (kScreenWidth - sumTitleWidth - 2*DJTLeftMargin) / (titleCount - 1);
    }else{
        for (int i = 0; i < 5; i++) {
            //一屏最多显示5个
            NSString *tmpTitle = titleArr[i];
            CGSize  titleSize = [tmpTitle sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
            screenTitleWidth += titleSize.width;
        }
        titleSpacing = (kScreenWidth - screenTitleWidth - 2*DJTLeftMargin) / 4.0 ;
    }
    
    
    CGFloat buttonX = 15;
    CGFloat buttonY = 4;
    CGFloat buttonH = _titleScrollView.cst_height - 8;
    CGFloat buttonW = 0;
    CGFloat progressH = (_progressHeight && _progressHeight < DJTPagerMargin && _progressHeight > 0) ?  _progressHeight : DJTUnderLineH;
    
    
    for (NSInteger i = 0; i < titleCount; i++) {
        
        _titleButton = [UIButton buttonWithType:UIButtonTypeSystem];
        
        NSString *tmpTitle = titleArr[i];
        CGSize  titleSize = [tmpTitle sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
        buttonW = titleSize.width;
        
        [_titleButton setTitle:tmpTitle forState:UIControlStateNormal];
        [_titleButton setTitleColor:self.norColor forState:UIControlStateNormal];
        _titleButton.titleLabel.font = (!_titleFont) ? [UIFont systemFontOfSize:11] : _titleFont;
        //绑定tag(增加额外值)
        _titleButton.tag = i + DJTButtonTagValue;
        _titleButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        _titleButton.backgroundColor = [UIColor clearColor];
        //进度条比button短多少
        CGFloat pace = (_progressLength && _progressLength < titleSize.width) ? (titleSize.width - _progressLength) / 2 : titleSize.width * 0.1;
        
        CGFloat framex = buttonX + pace;
        CGFloat frameWidth = buttonW - 2 * pace;
        CGFloat frameY = buttonH - (progressH - 3);
        CGRect frame = CGRectMake(framex,frameY, frameWidth, progressH);
        [self.pregressFrames addObject:[NSValue valueWithCGRect:frame]];
        [_titleScrollView addSubview:_titleButton];
        [_titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleButtonArray addObject:_titleButton];
        buttonX += titleSize.width + titleSpacing;
        
    }
    
    if (_isShowPregressView) {
        
        _pregressView = [[DJTPagerProgressView alloc] initWithFrame:CGRectMake(0, buttonH - (progressH - 4), sumTitleWidth + titleSpacing * (titleCount - 1) + 2*DJTLeftMargin, progressH)];
        _pregressView.progress = MIN(0, titleCount - 1);
        _pregressView.itemFrames = self.pregressFrames;
        _pregressView.color = self.proColor.CGColor;
        _pregressView.backgroundColor = [UIColor clearColor];
        [_titleScrollView addSubview:_pregressView];
    }
    
    //设置标题是否可以滚动
    _titleScrollView.contentSize = CGSizeMake(sumTitleWidth + titleSpacing * (titleCount - 1) + 30, self.cst_height);
    
    
}



//选中某个标题
- (void)selectTitleAtIndex:(NSInteger)titleIndex
{
    UIButton *button = self.titleButtonArray[titleIndex];
    _lastSelectButton.transform = CGAffineTransformIdentity; //还原
    [_lastSelectButton setTitleColor:self.norColor forState:UIControlStateNormal];
    
    [button setTitleColor:self.selColor forState:UIControlStateNormal];
    
    //字体缩放
    if (_titleScale > 0 && _titleScale < 1) {
        
        button.transform = CGAffineTransformMakeScale(1 + _titleScale, 1 + _titleScale);
        
    }
    _lastSelectButton = button;
    
    //标题居中
    CGFloat offsetX = button.center.x - _titleScrollView.cst_width * 0.5;
    if (offsetX < 0) { //最小
        offsetX = 0;
    }
    CGFloat offsetMax = _titleScrollView.contentSize.width - _titleScrollView.cst_width;
    if (offsetX > offsetMax) { //最大
        offsetX = offsetMax;
    }
    [_titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    _pregressView.isStretch = NO;
    
}



//底部滚动条滚动

- (void)bottomBarNaughtyWithOffset:(CGFloat)offsetx
{
    if (offsetx < 0) //最小
    {
        offsetx = 0;
    }
    _pregressView.progress = offsetx / _titleScrollView.cst_width;
    
}



//title变化时两个button变化
- (void)setUpLeftAndRightBtn:(CGPoint)contenOffset
{
    NSInteger tagI = contenOffset.x / kScreenWidth;
    NSInteger leftI = tagI;
    NSInteger rightI = tagI + 1;
    
    //缩放
    UIButton *leftButton = self.titleButtonArray[leftI];
    
    UIButton *rightButton;
    if (rightI < self.titleButtonArray.count){
        rightButton = self.titleButtonArray[rightI];
    }
    
    CGFloat scaleR = contenOffset.x / kScreenWidth;
    scaleR -= leftI;

    CGFloat scaleL = 1 - scaleR;
    if (_titleScale > 0 && _titleScale < 1) { //缩放尺寸限定
        leftButton.transform = CGAffineTransformMakeScale(scaleL * _titleScale + 1, scaleL * _titleScale + 1);
        rightButton.transform = CGAffineTransformMakeScale(scaleR * _titleScale + 1, scaleR * _titleScale + 1);
    }
    
    if (_isOpenShade) {//开启渐变
        //颜色渐变
        CGFloat r = _endR - _startR;
        CGFloat g = _endG - _startG;
        CGFloat b = _endB - _startB;
        
        UIColor *rightColor = [UIColor colorWithRed:_startR + r * scaleR green:_startG + g * scaleR blue:_startB + b * scaleR alpha:1];
        
        UIColor *leftColor = [UIColor colorWithRed:_startR +  r * scaleL  green:_startG +  g * scaleL  blue:_startB +  b * scaleL alpha:1];
        
        [rightButton setTitleColor:rightColor forState:UIControlStateNormal];
        [leftButton setTitleColor:leftColor forState:UIControlStateNormal];
    }
    
}



//设置是否有拉伸效果

- (void)setUpPregressViewStretchAllowed:(BOOL)isStre
{
    self.pregressView.isStretch = isStre;
}



//标题按钮点击

- (void)titleButtonClick:(UIButton *)button
{
    
    _pregressView.isStretch = NO;
    NSInteger buttonTag = button.tag - DJTButtonTagValue;
    
    //选中标题
    [self selectTitleAtIndex:buttonTag];
    
    if ([self.delegate_t respondsToSelector:@selector(titleScrollViewTitleChange:)]) {
        [self.delegate_t titleScrollViewTitleChange:buttonTag];
    }
    
}


#pragma  mark - 懒加载
//滚动条相关

- (UIScrollView *)titleScrollView
{
    if (!_titleScrollView) {
        
        _titleScrollView = [[UIScrollView alloc] init];
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        
        
    }
    return _titleScrollView;
}


- (NSMutableArray *)titleButtonArray
{
    if (!_titleButtonArray) {
        _titleButtonArray = [NSMutableArray array];
    }
    return _titleButtonArray;
}


- (NSMutableArray *)pregressFrames
{
    if (!_pregressFrames) {
        _pregressFrames = [NSMutableArray array];
    }
    return _pregressFrames;
}


#pragma mark - get
- (UIColor *)norColor
{
    if (!_norColor) self.norColor = [UIColor blackColor];
    
    return _norColor;
}

- (UIColor *)selColor
{
    if (!_selColor) self.selColor = [UIColor redColor];
    return _selColor;
}

- (UIColor *)proColor
{
    if (!_proColor) self.proColor = self.selColor;
    return _proColor;
}


- (UIColor *)titleScrollViewBgColor
{
    if (!_titleScrollViewBgColor)
        self.titleScrollViewBgColor = [UIColor whiteColor];
    
    return _titleScrollViewBgColor;
}




#pragma mark - set
- (void)setNorColor:(UIColor *)norColor
{
    _norColor = norColor;
    [self setupStartColor:norColor];
    
}
- (void)setSelColor:(UIColor *)selColor
{
    _selColor = selColor;
    [self setupEndColor:selColor];
}

- (void)setTitleScrollViewBgColor:(UIColor *)titleScrollViewBgColor
{
    _titleScrollViewBgColor = titleScrollViewBgColor;
    
    self.titleScrollView.backgroundColor = titleScrollViewBgColor;
    
}


- (void)setupStartColor:(UIColor *)color
{
    CGFloat components[3];
    
    [self getRGBComponents:components forColor:color];
    
    _startR = components[0];
    _startG = components[1];
    _startB = components[2];
}

- (void)setupEndColor:(UIColor *)color
{
    CGFloat components[3];
    
    [self getRGBComponents:components forColor:color];
    
    _endR = components[0];
    _endG = components[1];
    _endB = components[2];
}

/**
 *  指定颜色，获取颜色的RGB值
 *
 *  @param components RGB数组
 *  @param color      颜色
 */
- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,1,1,8,4,rgbColorSpace,1);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}
@end
