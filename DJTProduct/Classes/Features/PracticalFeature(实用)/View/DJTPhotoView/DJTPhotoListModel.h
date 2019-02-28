//
//  DJTBrowserListModel.h
//  DJTProduct
//
//  Created by Smy_D on 2019/1/24.
//  Copyright © 2019年 Smy_D. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DJTBrowserConfig;
/**
 当前图片的数据模型
 */
@interface DJTPhotoModel : NSObject

@property (nonatomic, assign) CGRect listCellF;

@property (nonatomic, copy) NSString *smallURL;

@property (nonatomic, copy) NSString *picURL;

@property (nonatomic, strong) DJTBrowserConfig *config;

@end



@interface DJTPhotoListModel : NSObject

@property (nonatomic, strong) UICollectionView *listCollectionView;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) NSArray *originalUrls;

@property (nonatomic, strong) NSArray *smallUrls;

@property (nonatomic, strong) NSArray <DJTPhotoModel *>*photoModels;
@end

NS_ASSUME_NONNULL_END
