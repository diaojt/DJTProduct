//
//  DJTCommunityCell.h
//  DJTProduct
//
//  Created by Smy_D on 2018/11/7.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJTCommunityCellLayout.h"

NS_ASSUME_NONNULL_BEGIN


@class DJTCommunityCell;

@interface DJTStatusProfileView : UIView
@property (nonatomic, strong) UIImageView *iconView; ///< 头像
@property (nonatomic, strong) UIButton *coverBtn; ///< 遮盖btn
@property (nonatomic, strong) YYLabel *nameLabel; ///< 昵称
@property (nonatomic, strong) YYLabel *sourceLabel; ///< 来源
@property (nonatomic, weak) DJTCommunityCell *cell;
@end


@interface DJTStatusToolbarView : UIView
@property (nonatomic, strong) UIButton *commentButton; ///< 评论按钮
@property (nonatomic, strong) UIButton *likeButton; ///< 点赞按钮

@property (nonatomic, strong) UIImageView *commentImageView; ///< 评论图片
@property (nonatomic, strong) UIImageView *likeImageView; ///< 点赞图片

@property (nonatomic, strong) YYLabel *commentLabel;///< 评论label
@property (nonatomic, strong) YYLabel *likeLabel;///< 点赞label

@property (nonatomic, weak) DJTCommunityCell *cell;

- (void)setWithLayout:(DJTCommunityCellLayout *)layout;

- (void)setLiked:(BOOL)liked withAnimation:(BOOL)animation;

@end

//@interface DJTStatusPhotoView : UIView
//@property (nonatomic, strong)UIView *photoView; ///< 配图
//@property (nonatomic, weak) DJTCommunityCell *cell;
//@end

@class DJTBrowserView;
@interface DJTStatusView : UIView

@property (nonatomic, strong)UIView *contentView;               ///< 容器
@property (nonatomic, strong)DJTStatusProfileView *profileView; ///< 用户信息
@property (nonatomic, strong)DJTStatusToolbarView *toolbarView; ///< 评论+点赞
@property (nonatomic, strong)YYLabel *titleLabel;               ///< 标题
@property (nonatomic, strong)YYLabel *textLabel;                ///< 内容
@property (nonatomic, strong)DJTBrowserView *browserView;       ///< 图片
@property (nonatomic, strong)NSArray<UIView *> *picViews;       ///< 图片
@property (nonatomic, strong)UIButton *followButton;            ///< 关注按钮

@property (nonatomic, strong)DJTCommunityCellLayout *layout;
@property (nonatomic, weak) DJTCommunityCell *cell;

@end

@protocol DJTCommunityCellDelegate;

@interface DJTCommunityCell : UITableViewCell

@property (nonatomic, strong) UITableView *infoTableView;///< 社区列表
@property (nonatomic, weak) id<DJTCommunityCellDelegate>delegate;
@property (nonatomic, strong) DJTStatusView *statusView;
- (void)setLayout:(DJTCommunityCellLayout *)layout;

@end

@protocol DJTCommunityCellDelegate<NSObject>
@optional
/// 点击了 Cell
- (void)cellDidClick:(DJTCommunityCell *)cell;
/// 点击了关注
- (void)cellDidClickFollow:(DJTCommunityCell *)cell;
/// 点击了评论
- (void)cellDidClickComment:(DJTCommunityCell *)cell;
/// 点击了赞
- (void)cellDidClickLike:(DJTCommunityCell *)cell;
/// 点击了图片
- (void)cell:(DJTCommunityCell *)cell didClickImageAtIndex:(NSUInteger)index;
@optional


@end


NS_ASSUME_NONNULL_END
