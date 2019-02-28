//
//  DJTCommunityCell.m
//  DJTProduct
//
//  Created by Smy_D on 2018/11/7.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "DJTCommunityCell.h"
#import "UIImageView+WebCache.h"
#import "YYControl.h"
#import "DJTStatusHelper.h"
#import "DJTBrowserView.h"
#import "DJTBrowserConfig.h"

@implementation DJTStatusProfileView

- (instancetype)initWithFrame:(CGRect)frame{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = kWBCellProfileHeight;
    }
    self = [super initWithFrame:frame];
    self.exclusiveTouch = YES;
    _iconView = [UIImageView new];
    _iconView.size = CGSizeMake(kWBCellProfileHeight, kWBCellProfileHeight);
    _iconView.left = kWBCellPadding;
    _iconView.centerY = self.centerY;
    _iconView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_iconView];
    
    _nameLabel = [YYLabel new];
    _nameLabel.size = CGSizeMake(kWBCellNameWidth, 24);
    _nameLabel.left = _iconView.right + kWBCellNamePaddingLeft;
    _nameLabel.top = _iconView.top;
    _nameLabel.displaysAsynchronously = YES;
    _nameLabel.ignoreCommonProperties = YES;
    _nameLabel.fadeOnAsynchronouslyDisplay = NO;
    _nameLabel.fadeOnHighlight = NO;
    _nameLabel.lineBreakMode = NSLineBreakByClipping;
    _nameLabel.textAlignment = YYTextVerticalAlignmentCenter;
    [self addSubview:_nameLabel];
    
    _sourceLabel = [YYLabel new];
    _sourceLabel.size = CGSizeMake(kWBCellNameWidth, 20);
    _sourceLabel.left = _nameLabel.left;
    _sourceLabel.top = _nameLabel.bottom;
    _sourceLabel.displaysAsynchronously = YES;
    _sourceLabel.ignoreCommonProperties = YES;
    _sourceLabel.fadeOnAsynchronouslyDisplay = NO;
    _sourceLabel.fadeOnHighlight = NO;
    
    [self addSubview:_sourceLabel];
    
    return self;
    
}

@end


@implementation DJTStatusToolbarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth/4;
        frame.size.height = kWBCellToolbarHeight;
    }
    
    self = [super initWithFrame:frame];
    self.exclusiveTouch = YES;
    
    _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_likeButton addTarget:self action:@selector(likeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    _likeButton.exclusiveTouch = YES;
    _likeButton.size = CGSizeMake(CGFloatPixelRound(self.width / 2.0), self.height);
    _likeButton.left =  0;
    
    _likeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_icon_unlike"]];
    _likeImageView.centerY = self.height / 2.0;
    [_likeButton addSubview:_likeImageView];
    
    _likeLabel = [YYLabel new];
    _likeLabel.userInteractionEnabled = NO;
    _likeLabel.height = self.height;
    _likeLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _likeLabel.displaysAsynchronously = YES;
    _likeLabel.ignoreCommonProperties = YES;
    _likeLabel.fadeOnHighlight = NO;
    _likeLabel.fadeOnAsynchronouslyDisplay = NO;
    [_likeButton addSubview:_likeLabel];
    [self addSubview:_likeButton];
    
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentButton.exclusiveTouch = YES;
    _commentButton.size = CGSizeMake(CGFloatPixelRound(self.width / 2.0), self.height);
    _commentButton.left = CGFloatPixelRound(self.width/2.0);;
    
    _commentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_icon_comment"]];
    _commentImageView.centerY = self.height / 2.0;
    [_commentButton addSubview:_commentImageView];
    
    _commentLabel = [YYLabel new];
    _commentLabel.userInteractionEnabled = NO;
    _commentLabel.height = self.height;
    _commentLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _commentLabel.displaysAsynchronously = YES;
    _commentLabel.ignoreCommonProperties = YES;
    _commentLabel.fadeOnHighlight = NO;
    _commentLabel.fadeOnAsynchronouslyDisplay = NO;
    [_commentButton addSubview:_commentLabel];
    [self addSubview:_commentButton];

    
    return self;
    
}


- (void)setWithLayout:(DJTCommunityCellLayout *)layout{
    _commentLabel.width = layout.toolbarCommentTextWidth;
    _likeLabel.width = layout.toolbarLikeTextWidth;
    
    _commentLabel.textLayout = layout.toolbarCommentTextLayout;
    _likeLabel.textLayout = layout.toolbarLikeTextLayout;
    
    [self adjustImage:_commentImageView label:_commentLabel inButton:_commentButton];
    [self adjustImage:_likeImageView label:_likeLabel inButton:_likeButton];
    _likeImageView.image = layout.recommend.m_isLike.boolValue ? [self likeImage] : [self unlikeImage];
}

- (UIImage *)likeImage{
    static UIImage *img;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        img = [UIImage imageNamed:@"timeline_icon_like"];
    });
    return img;
}

- (UIImage *)unlikeImage
{
    static UIImage *img;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        img = [UIImage imageNamed:@"timeline_icon_unlike"];
    });
    return img;
}

- (void)adjustImage:(UIImageView *)image label:(YYLabel *)label inButton:(UIButton *)button {

    CGFloat imageWidth = image.bounds.size.width;
    CGFloat labelWidth = label.width;
    CGFloat paddingMid = 5;
    CGFloat paddingSide = (button.width - imageWidth - labelWidth - paddingMid)/2.0;
    image.centerX = CGFloatPixelRound(paddingSide + imageWidth / 2.0);
    label.right = CGFloatPixelRound(button.width - paddingSide);
    
}

- (void)likeBtnClicked
{
    if ([self.cell.delegate respondsToSelector:@selector(cellDidClickLike:)]) {
        [self.cell.delegate cellDidClickLike:self.cell];
    }
    
}

- (void)commentBtnClicked
{
    if ([self.cell.delegate respondsToSelector:@selector(cellDidClickComment:)]) {
        [self.cell.delegate cellDidClickComment:self.cell];
    }
}


- (void)setLiked:(BOOL)liked withAnimation:(BOOL)animation{
    DJTCommunityCellLayout *layout = _cell.statusView.layout;
    if (layout.recommend.m_isLike.boolValue == liked) return;
    
    UIImage *image = liked ? [self likeImage] : [self unlikeImage];
    int newCount = layout.recommend.m_comments.str_commentnum.intValue;
    newCount = liked ? newCount + 1 : newCount - 1;
    if (newCount < 0) newCount = 0;
    if (liked && newCount < 1) newCount = 1;
    NSString *newCountDesc = [NSString stringWithFormat:@"%d",newCount];
    
    UIFont *font = [UIFont systemFontOfSize:kWBCellToolbarFontSize];
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth, kWBCellToolbarHeight)];
    container.maximumNumberOfRows = 1;
    NSMutableAttributedString *likeText = [[NSMutableAttributedString alloc] initWithString:newCountDesc];
    likeText.font = font;
    likeText.color = liked ? kWBCellToolbarTitleHighlightColor : kWBCellToolbarTitleColor;
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:likeText];
    
    layout.recommend.m_isLike = liked ? @"1" : @"0";
    layout.recommend.m_likes.str_likenum = [NSString stringWithFormat:@"%d",newCount];
    layout.toolbarLikeTextLayout = textLayout;
    
    if (!animation) {
        _likeImageView.image = image;
        _likeLabel.width = CGFloatPixelRound(textLayout.textBoundingRect.size.width);
        _likeLabel.textLayout = layout.toolbarLikeTextLayout;
        [self adjustImage:_likeImageView label:_likeLabel inButton:_likeButton];
        return;
    }
    
    WS(weakSelf);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        weakSelf.likeImageView.layer.transformScale = 1.7;
        
    } completion:^(BOOL finished) {
        weakSelf.likeImageView.image = image;
        weakSelf.likeLabel.width = CGFloatPixelRound(textLayout.textBoundingRect.size.width);
        weakSelf.likeLabel.textLayout = layout.toolbarLikeTextLayout;
        [weakSelf adjustImage:weakSelf.likeImageView label:weakSelf.likeLabel inButton:weakSelf.likeButton];
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
            weakSelf.likeImageView.layer.transformScale = 0.9;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                weakSelf.likeImageView.layer.transformScale = 1;
            } completion:^(BOOL finished) {
            }];
        }];
    }];
    
}


@end


@implementation DJTStatusView

- (instancetype)initWithFrame:(CGRect)frame{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = 1;
    }
    
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    self.exclusiveTouch = YES;
    
    // 显示 YYLabel 基准线，调试用
    //YYTextDebugOption *debugOption = [YYTextDebugOption new];
    //debugOption.baselineColor = [UIColor greenColor];
    //debugOption.CTFrameBorderColor = [UIColor redColor];
    //debugOption.CTLineBorderColor = [UIColor blueColor];
    //[YYTextDebugOption setSharedDebugOption:debugOption];
    
    _contentView = [UIView new];
    _contentView.width = kScreenWidth;
    _contentView.height = 1;
    _contentView.backgroundColor = [UIColor whiteColor];
    static UIImage *topLineBG, *bottomLineBG;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        topLineBG = [UIImage imageWithSize:CGSizeMake(1, 3) drawBlock:^(CGContextRef context) {
            CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 0.8, [UIColor colorWithWhite:0 alpha:0.08].CGColor);
            CGContextAddRect(context, CGRectMake(-2, 3, 4, 4));
            CGContextFillPath(context);
        }];
        bottomLineBG = [UIImage imageWithSize:CGSizeMake(1, 3) drawBlock:^(CGContextRef context) {
            CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            CGContextSetShadowWithColor(context, CGSizeMake(0, 0.4), 2, [UIColor colorWithWhite:0 alpha:0.08].CGColor);
            CGContextAddRect(context, CGRectMake(-2, -2, 4, 2));
            CGContextFillPath(context);
        }];
        
    });
    
    UIImageView *topLine = [[UIImageView alloc] initWithImage:topLineBG];
    topLine.width = _contentView.width;
    topLine.bottom = 0;
    topLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    //[_contentView addSubview:topLine];
    
    UIImageView *bottomLine = [[UIImageView alloc] initWithImage:bottomLineBG];
    bottomLine.width = _contentView.width;
    bottomLine.top = _contentView.height;
    bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    //[_contentView addSubview:bottomLine];
    [self addSubview:_contentView];
    
    // 头部
    _profileView = [DJTStatusProfileView new];
    [_contentView addSubview:_profileView];
    
    // 评论 + 点赞
    _toolbarView = [DJTStatusToolbarView new];
    [_contentView addSubview:_toolbarView];
    _toolbarView.centerY = _profileView.centerY;
    _toolbarView.right = _profileView.right - kWBCellPadding;
    
    // 标题
    _titleLabel = [YYLabel new];
    _titleLabel.left = kWBCellPadding;
    _titleLabel.width = kWBCellContentWidth;
    _titleLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _titleLabel.displaysAsynchronously = YES;
    _titleLabel.fadeOnAsynchronouslyDisplay = NO;
    _titleLabel.fadeOnHighlight = NO;
    [_contentView addSubview:_titleLabel];
    
    // 内容
    _textLabel  = [YYLabel new];
    _textLabel.left = kWBCellPadding;
    _textLabel.width = kWBCellContentWidth;
    _textLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;;
    _textLabel.displaysAsynchronously = YES;
    _textLabel.ignoreCommonProperties = YES;
    _textLabel.fadeOnAsynchronouslyDisplay = NO;
    _textLabel.fadeOnHighlight = NO;
    [_contentView addSubview:_textLabel];
    
    // 图片
    _browserView = [[DJTBrowserView alloc] init];
    _browserView.left = kWBCellPadding;
    _browserView.width = kWBCellContentWidth;
    [_contentView addSubview:_browserView];
    
    return self;
    
    
}

- (void)setLayout:(DJTCommunityCellLayout *)layout
{
    _layout = layout;
    
    self.height = layout.height;
    _contentView.top = layout.marginTop;
    _contentView.height = layout.height - layout.marginTop - layout.marginBottom;
    
    CGFloat top = 0;
    
    // 设置头部
    [_profileView.iconView sd_setImageWithURL:[NSURL URLWithString:layout.recommend.m_icon.str_urlOfThumbnail] placeholderImage:nil];
    _profileView.nameLabel.textLayout = layout.nameTextLayout;
    _profileView.sourceLabel.textLayout = layout.sourceTextLayout;
    
    _profileView.top = top;
    top = layout.profileHeight;
    
    // 评论 + 点赞
    [_toolbarView setWithLayout:layout];
    
    // 设置标题
    if (layout.titleHeight > 0) {
        top += kWBCellTopMargin;
        _titleLabel.hidden = NO;
        _titleLabel.height = layout.titleHeight;
        _titleLabel.textLayout = layout.titleTextLayout;
        _titleLabel.top = top;
        top += layout.titleHeight;
    }else{
        _titleLabel.hidden = YES;
        
    }
    
    // 设置内容
    if (layout.textHeight > 0) {
        top += kWBCellTopMargin;
        _textLabel.hidden = NO;
        _textLabel.height = layout.textHeight;
        _textLabel.textLayout = layout.textLayout;
        _textLabel.top = top;
        top += layout.textHeight;
    }else{
        _textLabel.hidden = YES;
    }
    
    // 设置配图
    //[self _setImageViewWithTop:top withLayout:layout];
    if (layout.picHeight > 0) {
        top += kWBCellTopMargin;
        _browserView.hidden = NO;
        DJTBrowserConfig *config = [[DJTBrowserConfig alloc] init];
        
        NSMutableArray *oriUrls = [NSMutableArray new];
        NSMutableArray *smlUrls = [NSMutableArray new];
        [layout.recommend.m_content.arr_image enumerateObjectsUsingBlock:^(DJT_Photo_Model * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [oriUrls addObject:obj.str_urlOfFullSize];
            [smlUrls addObject:obj.str_urlOfThumbnail];
        }];
        config.originalUrls = oriUrls;
        config.smallUrls = smlUrls;
        config.size = layout.browerSize;
        config.margin  = kWBCellPaddingPic;
        config.picSize = layout.picSize;
        config.browserStyle = (layout.style == DJTCommunityLayoutStyleTimeline ?DJTBrowserLayoutStyleTimeline:DJTBrowserLayoutStyleDetail);
        _browserView.height = layout.browerSize.height;
        _browserView.top = top;
        _browserView.clipsToBounds = YES;
        [_browserView showDJTBrowserWithConfig:config];
    }else{
        _browserView.hidden = YES;
    }
    //[self _setImageViewWithTop:top withLayout:layout];
}

- (void)_setImageViewWithTop:(CGFloat)imageTop withLayout:(DJTCommunityCellLayout *)layout{
    
    int picsCount = (int)layout.recommend.m_content.arr_image.count;
    int maxCount = layout.style == DJTCommunityLayoutStyleTimeline ? 3 : 4;
    
    for (int i = 0; i < 4; i++) {
        UIView *imageView = _picViews[i];
        imageView.hidden = YES;
        if (i >= MIN(picsCount, maxCount)) {
            [imageView.layer cancelCurrentImageRequest];
            imageView.hidden = YES;
        }else{
            
            CGPoint origin = {0};
            origin.x = kWBCellPadding + (i % 3) * (layout.picSize.width + kWBCellPaddingPic);
            origin.y = imageTop + (int)(i / 3) * (layout.picSize.height + kWBCellPaddingPic);
            
            imageView.frame = (CGRect){.origin = origin, .size = layout.picSize};
            imageView.hidden = NO;
            [imageView.layer removeAnimationForKey:@"contents"];
            DJT_Photo_Model *pic = layout.recommend.m_content.arr_image[i];
            @weakify(imageView);
            [imageView.layer setImageWithURL:[NSURL URLWithString:pic.str_urlOfThumbnail]
                                 placeholder:nil
                                     options:YYWebImageOptionAvoidSetImage
                                  completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                      @strongify(imageView);
                                      if (!imageView) return;
                                      if (image && stage == YYWebImageStageFinished) {
                                          ((YYControl *)imageView).image = image;
                                          if (from != YYWebImageFromMemoryCacheFast) {
                                              CATransition *transition = [CATransition animation];
                                              transition.duration = 0.15;
                                              transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                                              transition.type = kCATransitionFade;
                                              [imageView.layer addAnimation:transition forKey:@"contents"];
                                          }
                                      }
                                      
                                      
                                  }];
        }
        
    }
    
}


@end



@implementation DJTCommunityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _statusView = [DJTStatusView new];
    _statusView.cell = self;
    _statusView.profileView.cell = self;
    _statusView.toolbarView.cell = self;
    [self.contentView addSubview:_statusView];
    
    return self;
}

- (void)setLayout:(DJTCommunityCellLayout *)layout
{
    self.height = layout.height;
    self.contentView.height = layout.height;
    _statusView.layout = layout;
}

@end
