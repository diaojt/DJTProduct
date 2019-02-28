//
//  DJTBrowserView.m
//  DJTProduct
//
//  Created by Smy_D on 2019/1/23.
//  Copyright © 2019年 Smy_D. All rights reserved.
//

#import "DJTBrowserView.h"
#import <UIImageView+WebCache.h>
#import "DJTPhotoListModel.h"
#import "DJTPhotoBrowserView.h"
#import "DJTBrowserConfig.h"
#define ITemCount 3 //每行 3 张图片

@interface DJTBrowserCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation DJTBrowserCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imgView];
        self.imgView.frame = self.contentView.bounds;
    }
    return self;
}

- (UIImageView *)imgView
{
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
    }
    return _imgView;
    
}

@end

@interface DJTBrowserView()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) DJTBrowserConfig *config; ///配置模型

@end

@implementation DJTBrowserView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView
{
    [self addSubview:self.collectionView];
    self.collectionView.frame = self.bounds;
}

- (void)showDJTBrowserWithConfig:(DJTBrowserConfig *)config
{
    // 赋值 全局调用
    _config = config;
    
    // 如果没给 margin 就设置默认值
    config.margin = config.margin ?:3;
    
    self.collectionView.width = config.size.width;
    // 设置背景颜色
    self.collectionView.backgroundColor = config.collectionViewBackgroundColor ?:[UIColor whiteColor];
    
    // 设置 collectionView 的间隔
    self.layout.minimumLineSpacing = config.margin;
    self.layout.minimumInteritemSpacing = config.margin;
    self.layout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    // 设置 pic 的size
    self.layout.itemSize = config.picSize;
    // 默认列表页，就一行
    NSInteger row = 1;
    // 详情页计算行数
    if (config.browserStyle == DJTBrowserLayoutStyleDetail) {
        row = config.smallUrls.count ? ((config.smallUrls.count - 1) / 3 + 1): 0;
        self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    CGFloat height = row * (config.picSize.width + config.margin) - (row == 0 ? 0:config.margin);
    self.collectionView.height = height;
    [self.collectionView reloadData];
}


- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[DJTBrowserCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        //_collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DJTBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.config.smallUrls[indexPath.item]]];
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.config.smallUrls.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 将所有的数据封装到数据模型中 再传到要展示的大图视图中
    DJTPhotoListModel *model = [[DJTPhotoListModel alloc] init];
    model.listCollectionView = self.collectionView;
    model.indexPath = indexPath;
    model.originalUrls = self.config.smallUrls.count == self.config.originalUrls.count?self.config.originalUrls:self.config.smallUrls;
    model.smallUrls = self.config.smallUrls;
    
    NSMutableArray *mutArr = [NSMutableArray array];
    for (int a = 0; a < model.smallUrls.count; a++) {
        DJTPhotoModel *photoModel = [[DJTPhotoModel alloc] init];
        photoModel.smallURL = model.smallUrls[a];
        photoModel.picURL = model.originalUrls[a];
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:a inSection:indexPath.section]];
        
        if (cell == nil) {
            cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:a-1 inSection:indexPath.section]];
        }
        photoModel.listCellF = [self listCellFrame:cell];
        
        photoModel.config = self.config;
        [mutArr addObject:photoModel];
    }
    model.photoModels = mutArr;
    DJTPhotoBrowserView *photoView = [[DJTPhotoBrowserView alloc] init];
    photoView.listModel = model;
    [photoView show];
    
}

/**
 获取listCell 在window中的对应位置
 
 @param cell cell
 @return 对应的frame
 */
- (CGRect)listCellFrame:(UICollectionViewCell *)cell
{
    CGRect cellRect = [self.collectionView convertRect:cell.frame toView:self.collectionView];
    CGRect cell_window_rect = [self.collectionView convertRect:cellRect toView:self.window];
    return cell_window_rect;
}


@end
