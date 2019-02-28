//
//  DJTCommunityCellLayout.m
//  DJTProduct
//
//  Created by Smy_D on 2018/11/7.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "DJTCommunityCellLayout.h"
#import "DJTStatusHelper.h"

@implementation DJTTextLinePositionModifier

- (instancetype)init {
    self = [super init];
    
    if (kiOS9Later) {
        _lineHeightMultiple = 1.34;   // for PingFang SC
    } else {
        _lineHeightMultiple = 1.3125; // for Heiti SC
    }
    
    return self;
}

- (void)modifyLines:(NSArray *)lines fromText:(NSAttributedString *)text inContainer:(YYTextContainer *)container {
    //CGFloat ascent = _font.ascender;
    CGFloat ascent = _font.pointSize * 0.86;
    
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    for (YYTextLine *line in lines) {
        CGPoint position = line.position;
        position.y = _paddingTop + ascent + line.row  * lineHeight;
        line.position = position;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    DJTTextLinePositionModifier *one = [self.class new];
    one->_font = _font;
    one->_paddingTop = _paddingTop;
    one->_paddingBottom = _paddingBottom;
    one->_lineHeightMultiple = _lineHeightMultiple;
    return one;
}

- (CGFloat)heightForLineCount:(NSUInteger)lineCount {
    if (lineCount == 0) return 0;
    //    CGFloat ascent = _font.ascender;
    //    CGFloat descent = -_font.descender;
    CGFloat ascent = _font.pointSize * 0.86;
    CGFloat descent = _font.pointSize * 0.14;
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    return _paddingTop + _paddingBottom + ascent + descent + (lineCount - 1) * lineHeight;
}

@end

@implementation DJTCommunityCellLayout

- (instancetype)initWithStatus:(DJT_Recommend_Model *)recommend style:(DJTCommunityLayoutStyle)style {
    if (!recommend) return nil;
    self = [super init];
    _recommend = recommend;
    _style = style;
    [self layout];
    return self;
}

- (void)layout {
    [self _layout];
}

- (void)_layout {
    
    _marginTop = kWBCellTopMargin;
    _titleHeight = 0;
    _profileHeight = 0;
    _textHeight = 0;
    _picHeight = 0;
    _toolbarHeight = kWBCellToolbarHeight;
    _marginBottom = kWBCellBottomMargin;
    
    
    // 计算布局
    [self _layoutProfile];
    [self _layoutTitle];
    [self _layoutText];
    [self _layoutPics];
    [self _layoutToolbar];
    
    // 计算高度
    _height = 0;
    _height += _marginTop;
    _height += _profileHeight;
    _height += _titleHeight;
    _height += _textHeight;
    _height += _picHeight;
    
    if (_titleHeight > 0) {
        _height += kWBCellTopMargin;
    }
    if (_textHeight > 0){
       _height += kWBCellTopMargin;
    }
    if (_picHeight > 0){
        _height += kWBCellTopMargin;
    }
    
    _height += _marginBottom;
}

// 头部
- (void)_layoutProfile {
    [self _layoutName];
    [self _layoutSource];
    _profileHeight = kWBCellProfileHeight;
}

// 昵称
- (void)_layoutName {
   
    NSString *nameStr = nil;
    nameStr = _recommend.m_nickname;
    if (nameStr.length == 0) {
        _nameTextLayout = nil;
        return;
    }
    
    NSMutableAttributedString *nameText = [[NSMutableAttributedString alloc] initWithString:nameStr];
    
    nameText.font = [UIFont systemFontOfSize:kWBCellNameFontSize];
    nameText.color = [UIColor colorWithHexString:@"#34659A"];
    nameText.lineBreakMode = NSLineBreakByCharWrapping;
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kWBCellNameWidth, 9999)];
    container.maximumNumberOfRows = 1;
    _nameTextLayout = [YYTextLayout layoutWithContainer:container text:nameText];
}

// 时间和来源
- (void)_layoutSource {
    NSMutableAttributedString *sourceText = [NSMutableAttributedString new];
    NSString *createTime = _recommend.m_date;
    NSString *source = _recommend.m_circlename;
    
    // 时间
    if (createTime.length) {
        NSMutableAttributedString *timeText = [[NSMutableAttributedString alloc] initWithString:createTime];
        [timeText appendString:@"  "];
        timeText.font = [UIFont systemFontOfSize:kWBCellSourceFontSize];
        timeText.color = kWBCellTimeNormalColor;
        [sourceText appendAttributedString:timeText];
    }
    
    if (_recommend.m_circlename.length) {
        NSMutableAttributedString *from = [NSMutableAttributedString new];
        [from appendString:[NSString stringWithFormat:@"来自 %@", source]];
        from.font = [UIFont systemFontOfSize:kWBCellSourceFontSize];
        from.color = kWBCellTimeNormalColor;
        [sourceText appendAttributedString:from];
    }
    
    if (sourceText.length == 0) {
        _sourceTextLayout = nil;
    } else {
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kWBCellNameWidth, 9999)];
        container.maximumNumberOfRows = 1;
        _sourceTextLayout = [YYTextLayout layoutWithContainer:container text:sourceText];
    }
}

// 点赞 + 评论
- (void)_layoutToolbar
{
    UIFont *font = [UIFont systemFontOfSize:kWBCellToolbarFontSize];
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth, kWBCellToolbarHeight)];
    container.maximumNumberOfRows = 1;
    
    NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:_recommend.m_comments.str_commentnum];
    commentText.font = font;
    commentText.color = kWBCellToolbarTitleColor;
    _toolbarCommentTextLayout = [YYTextLayout layoutWithContainer:container text:commentText];
    _toolbarCommentTextWidth = CGFloatPixelRound(_toolbarCommentTextLayout.textBoundingRect.size.width);
    
    NSMutableAttributedString *likeText = [[NSMutableAttributedString alloc] initWithString:_recommend.m_likes.str_likenum];
    likeText.font = font;
    likeText.color = _recommend.m_isLike.boolValue ? kWBCellToolbarTitleHighlightColor : kWBCellToolbarTitleColor;
    _toolbarLikeTextLayout = [YYTextLayout layoutWithContainer:container text:likeText];
    _toolbarLikeTextWidth = CGFloatPixelRound(_toolbarLikeTextLayout.textBoundingRect.size.width);
    
}


// 标题
- (void)_layoutTitle {
    
    _titleHeight = 0;
    _titleTextLayout = nil;
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:_recommend.m_content.str_title];
    
    BOOL isSix = [_recommend.m_jingpin isEqualToString:@"1"];
    BOOL isEssence = [_recommend.m_rawzdstatus isEqualToString:@"3"];
    
    if (title.length == 0) return;
    if (isSix || isEssence) [title insertString:@" " atIndex:0];
    
    // 666优先级高
    if (isSix) {
        NSAttributedString *sixStr = [self _attachmentWithFontSize:kWBCellTitlebarFontSize String:@"666"];
        if (sixStr) {
            [title insertAttributedString:sixStr atIndex:0];
        }
        
    }else if (isEssence) {
        NSAttributedString *essenStr = [self _attachmentWithFontSize:kWBCellTitlebarFontSize String:@"精华"];
        if (essenStr) {
            [title insertAttributedString:essenStr atIndex:0];
        }
    }
    
    title.color = [UIColor colorWithHexString:@"333333"];
    title.font = [UIFont boldSystemFontOfSize:kWBCellTitlebarFontSize];
    
    DJTTextLinePositionModifier *modifier = [DJTTextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:kWBCellTitlebarFontSize];
    modifier.paddingTop = kWBCellPaddingText;
    modifier.paddingBottom = kWBCellPaddingText;
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT)];
    container.maximumNumberOfRows = 2;
    container.linePositionModifier = modifier;
    
    _titleTextLayout = [YYTextLayout layoutWithContainer:container text:title];
    if (!_titleTextLayout) return;
    
    _titleHeight = [modifier heightForLineCount:_titleTextLayout.rowCount];
    
}

// 内容
- (void)_layoutText{
    _textHeight = 0;
    _textLayout = nil;
    
    NSMutableAttributedString *text = [self _textWithStatus:_recommend isRetweet:NO fontSize:kWBCellTextFontSize textColor:kWBCellTextNormalColor];
    
    BOOL isSix = [_recommend.m_jingpin isEqualToString:@"1"];
    BOOL isEssence = [_recommend.m_rawzdstatus isEqualToString:@"3"];
    
    if (text.length == 0 && !isSix && !isEssence) return;
    
    
    if (_recommend.m_content.str_title.length == 0) {
        // 在红框和内容件插入一个空格
        if (isSix || isEssence) [text insertString:@"  " atIndex:0];
        
        // 666优先级高
        if (isSix) {
            NSAttributedString *sixStr = [self _attachmentWithFontSize:kWBCellTitlebarFontSize String:@"666"];
            if (sixStr) {
                [text insertAttributedString:sixStr atIndex:0];
            }
        }else if (isEssence) {
            NSAttributedString *essenStr = [self _attachmentWithFontSize:kWBCellTitlebarFontSize String:@"精华"];
            if (essenStr) {
                [text insertAttributedString:essenStr atIndex:0];
            }
        }
    }
    
    
    //text.color = [UIColor colorWithHexString:@"333333"];
    //text.font = [UIFont systemFontOfSize:kWBCellTextFontSize];
    
    DJTTextLinePositionModifier *modifier = [DJTTextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:kWBCellTextFontSize];
    modifier.paddingTop = kWBCellPaddingText;
    modifier.paddingBottom = kWBCellPaddingText;
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT)];
    container.maximumNumberOfRows = (_style == DJTCommunityLayoutStyleTimeline ? 2 : MAXFLOAT);
    container.linePositionModifier = modifier;
    
    _textLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (!_textLayout) return;
    
    _textHeight = [modifier heightForLineCount:_textLayout.rowCount];

}

// 图片
- (void)_layoutPics
{
    _picSize = CGSizeZero;
    _picHeight = 0;
    int picCount = (int)_recommend.m_content.arr_image.count;
    if (picCount == 0) return;
    CGFloat browerWidth = 0;
    CGFloat browerMaxWidth = 0;
    switch (_style) {
        case DJTCommunityLayoutStyleTimeline:
            _picSize = [self timelinePicSize];
            _picHeight = _picSize.height;
            browerWidth = (_picSize.width + kWBCellPaddingPic) * picCount;
            browerMaxWidth = (_picSize.width + kWBCellPaddingPic) * 3;
            _browerSize = CGSizeMake(MIN(browerWidth, browerMaxWidth), _picHeight);
            break;
        case DJTCommunityLayoutStyleDetail:
            _picSize = [self detailPicSize];
            _picHeight = (1 + (int)((picCount -1) / 3)) * (_picSize.height) + (int)((picCount-1)/ 3)*kWBCellPaddingPic;
            browerWidth = (_picSize.width + kWBCellPaddingPic) * picCount;
            browerMaxWidth = (_picSize.width + kWBCellPaddingPic) * 3;
            _browerSize = CGSizeMake(MIN(browerWidth, browerMaxWidth), _picHeight);
            break;
        default:
            break;
    }
    
}

- (CGSize)timelinePicSize
{
    CGFloat width = (kScreenWidth - kWBCellPadding - kWBCellRightPicPadding - 2 * kWBCellPaddingPic)/3.0;
    return CGSizeMake(width, width);
}


- (CGSize)detailPicSize
{
    CGFloat width = (kScreenWidth - 2 * kWBCellPadding - 2 * kWBCellPaddingPic)/3.0;
    return CGSizeMake(width, width);
}


- (NSMutableAttributedString *)_textWithStatus:(DJT_Recommend_Model *)recommend
                                     isRetweet:(BOOL)isRetweet
                                      fontSize:(CGFloat)fontSize
                                     textColor:(UIColor *)textColor
{
    
    if (!recommend) return nil;
    NSMutableString *string = recommend.m_content.str_text.mutableCopy;
    if (string.length == 0) return nil;
    
    // 字体
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = kWBCellTextHighlightBackgroundColor;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    
    text.font = font;
    text.color = textColor;
    
    // 匹配 [表情]
    NSArray<NSTextCheckingResult *> *emoticonResults = [[DJTStatusHelper regexEmoticon] matchesInString:text.string options:kNilOptions range:text.rangeOfAll];
    NSUInteger emoClipLength = 0;
    for (NSTextCheckingResult *emo in emoticonResults) {
        if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
        NSRange range = emo.range;
        range.location -= emoClipLength;
        if ([text attribute:YYTextHighlightAttributeName atIndex:range.location]) continue;
        if ([text attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
        NSString *emoString = [text.string substringWithRange:range];
        NSString *imageName = [DJTStatusHelper emoticonDic][emoString];
        UIImage *image = [DJTStatusHelper imageNamed:imageName];
        if (!image) continue;
        
        NSAttributedString *emoText = [NSAttributedString attachmentStringWithEmojiImage:image fontSize:fontSize];
        [text replaceCharactersInRange:range withAttributedString:emoText];
        emoClipLength += range.length - 1;
    }
    
    return text;
}


// 在属性文本前边插入红框精华或者666
- (NSAttributedString *)_attachmentWithFontSize:(CGFloat)fontSize String:(NSString *)string
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 16)];
    [button setTitle:string forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#DC1D1D"] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
    [button.layer setCornerRadius:2];
    button.layer.masksToBounds = YES;
    [button.layer setBorderColor:[UIColor colorWithHexString:@"#DC1D1D"].CGColor];
    [button.layer setBorderWidth:1];
    
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    
    YYTextAttachment *attachment = [YYTextAttachment new];
    attachment.contentMode = UIViewContentModeScaleAspectFit;
    attachment.content = button;
    [atr setTextAttachment:attachment range:NSMakeRange(0, atr.length)];
    
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.width = button.size.width;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGFloat fontHeight = font.ascender - font.descender;
    CGFloat yOffset = font.ascender - fontHeight * 0.5;
    delegate.ascent = button.size.height * 0.5 + yOffset;
    delegate.descent = button.size.height - delegate.ascent;
    if (delegate.descent < 0) {
        delegate.descent = 0;
        delegate.ascent = button.size.height;
    }
    
    CTRunDelegateRef delegateRef = delegate.CTRunDelegate;
    [atr setRunDelegate:delegateRef range:NSMakeRange(0, atr.length)];
    if (delegate) CFRelease(delegateRef);
    
    return atr;
    
}


@end
