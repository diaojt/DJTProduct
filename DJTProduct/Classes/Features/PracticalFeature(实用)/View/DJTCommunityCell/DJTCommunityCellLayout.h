//
//  DJTCommunityCellLayout.h
//  DJTProduct
//
//  Created by Smy_D on 2018/11/7.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJT_Recommend_Model.h"

// 宽高 间距
#define kWBCellTopMargin 8                  // cell 顶部灰色留白
#define kWBCellPadding 15                   // cell 内边距
#define kWBCellPaddingText 2                // cell 文本与其他元素间留白
#define kWBCellPaddingPic 5                 // cell 多张图片中间留白
#define kWBCellProfileHeight 40             // cell 名片高度
#define kWBCellNamePaddingLeft 16           // cell 名字和 头像 之间留白
#define kWBCellContentWidth (kScreenWidth - 2 * kWBCellPadding) // cell 内容宽度
#define kWBCellNameWidth (kScreenWidth - 110) // cell 名字最宽限制
#define kWBCellToolbarHeight 35               // cell 下方工具栏高度
#define kWBCellBottomMargin 8                 // cell 下方灰色留白
#define kWBCellRightPicPadding 60                // cell 中图片距cell右边距
// 字体
#define kWBCellNameFontSize 16          // 名字字体大小
#define kWBCellSourceFontSize 12        // 来源字体大小
#define kWBCellTextFontSize 15          // 文本字体大小
#define kWBCellTitlebarFontSize 18      // 标题栏字体大小
#define kWBCellToolbarFontSize 14       // 工具栏字体大小

// 颜色
#define kWBCellNameNormalColor UIColorHex(333333)   // 名字颜色
#define kWBCellTimeNormalColor UIColorHex(828282)   // 时间颜色

#define kWBCellTextNormalColor UIColorHex(333333) // 一般文本色
#define kWBCellTextSubTitleColor UIColorHex(5d5d5d) // 次要文本色
#define kWBCellTextHighlightColor UIColorHex(527ead) // Link 文本色
#define kWBCellTextHighlightBackgroundColor UIColorHex(bfdffe) // Link 点击背景色
#define kWBCellToolbarTitleColor UIColorHex(929292) // 工具栏文本色
#define kWBCellToolbarTitleHighlightColor UIColorHex(df422d) // 工具栏文本高亮色

#define kWBCellBackgroundColor UIColorHex(f2f2f2)    // Cell背景灰色
#define kWBCellHighlightColor UIColorHex(f0f0f0)     // Cell高亮时灰色
#define kWBCellInnerViewHighlightColor  UIColorHex(f0f0f0) // Cell内部卡片高亮时灰色
#define kWBCellLineColor [UIColor colorWithWhite:0.000 alpha:0.09] //线条颜色

NS_ASSUME_NONNULL_BEGIN


/// 风格
typedef NS_ENUM(NSUInteger, DJTCommunityLayoutStyle) {
    DJTCommunityLayoutStyleTimeline = 0, ///< 列表页
    DJTCommunityLayoutStyleDetail,       ///< 详情页
};


/**
 一个 Cell 的布局。
 布局排版应该在后台线程完成。
 */
@interface DJTCommunityCellLayout : NSObject
- (instancetype)initWithStatus:(DJT_Recommend_Model *)recommend style:(DJTCommunityLayoutStyle)style;
//计算布局
- (void)layout;

//以下是数据
@property (nonatomic, strong)DJT_Recommend_Model *recommend;
@property (nonatomic, assign)DJTCommunityLayoutStyle style;

//以下是布局结果

// 顶部留白
@property (nonatomic, assign) CGFloat marginTop; //顶部灰色留白

// 个人资料
@property (nonatomic, assign) CGFloat profileHeight; //个人资料高度(包括留白)
@property (nonatomic, strong) YYTextLayout *nameTextLayout; // 名字
@property (nonatomic, strong) YYTextLayout *sourceTextLayout; //时间/来源

// 工具栏
@property (nonatomic, assign) CGFloat toolbarHeight; // 工具栏
@property (nonatomic, strong) YYTextLayout *toolbarCommentTextLayout;//评论
@property (nonatomic, strong) YYTextLayout *toolbarLikeTextLayout;//点赞

@property (nonatomic, assign) CGFloat toolbarCommentTextWidth;
@property (nonatomic, assign) CGFloat toolbarLikeTextWidth;

// 标题栏
@property (nonatomic, assign) CGFloat titleHeight; //标题栏高度，0为没标题栏
@property (nonatomic, strong) YYTextLayout *titleTextLayout; // 标题栏

// 文本
@property (nonatomic, assign) CGFloat textHeight; //文本高度(包括下方留白)
@property (nonatomic, strong) YYTextLayout *textLayout; //文本

// 图片
@property (nonatomic, assign) CGFloat picHeight; //图片高度，0为没图片
@property (nonatomic, assign) CGSize picSize;
@property (nonatomic, assign) CGSize timelinePicSize;//列表页图片尺寸
@property (nonatomic, assign) CGSize detailPicSize;//详情页图片尺寸
@property (nonatomic, assign) CGSize browerSize;   //整个图片控件尺寸
@property (nonatomic, assign) CGSize browerContentSize;//图片控件内容尺寸

// 下边留白
@property (nonatomic, assign) CGFloat marginBottom; //下边留白

// 总高度
@property (nonatomic, assign) CGFloat height;


@end


/**
 文本 Line 位置修改
 将每行文本的高度和位置固定下来，不受中英文/Emoji字体的 ascent/descent 影响
 */
@interface DJTTextLinePositionModifier : NSObject <YYTextLinePositionModifier>
@property (nonatomic, strong) UIFont *font; // 基准字体 (例如 Heiti SC/PingFang SC)
@property (nonatomic, assign) CGFloat paddingTop; //文本顶部留白
@property (nonatomic, assign) CGFloat paddingBottom; //文本底部留白
@property (nonatomic, assign) CGFloat lineHeightMultiple; //行距倍数
- (CGFloat)heightForLineCount:(NSUInteger)lineCount;
@end


NS_ASSUME_NONNULL_END
