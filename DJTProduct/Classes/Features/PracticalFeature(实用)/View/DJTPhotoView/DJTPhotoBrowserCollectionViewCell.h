//
//  DJTPhotoBrowserCollectionViewCell.h
//  DJTProduct
//
//  Created by Smy_D on 2019/1/28.
//  Copyright © 2019年 Smy_D. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DJTPhotoBrowserCollectionViewCell;
@class DJTPhotoModel;

@protocol DJTPhotoBrowserCollectionViewCellDelegate <NSObject>

/**
 缩小
 @param cell 对应的cell
 */
- (void)hiddenAction:(DJTPhotoBrowserCollectionViewCell *)cell;

/**
 背景渐变
 @param alpha 渐变值
 */
- (void)backgroundAlpha:(CGFloat)alpha;

@end


@interface DJTPhotoBrowserCollectionViewCell : UICollectionViewCell
/**
 单个图片模型
 */
@property (nonatomic, strong) DJTPhotoModel *photoModel;

/**
 展示的imageView 图片
 */
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) id<DJTPhotoBrowserCollectionViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
