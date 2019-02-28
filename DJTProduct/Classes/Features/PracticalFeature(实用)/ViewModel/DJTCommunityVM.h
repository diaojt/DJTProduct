//
//  DJTCommunityVM.h
//  DJTProduct
//
//  Created by Smy_D on 2018/11/7.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJTBaseVM.h"
#import "DJT_Recommend_Model.h"
#import "DJTCommunityCellLayout.h"

NS_ASSUME_NONNULL_BEGIN


@protocol DJTCommunity_VM_Protocol <NSObject>

// 获取热门和资讯信息成功
- (void)fetchHotAndInfoDatasSuccess;
- (void)fetchHotAndInfoDatasFromCacheSuccess;
- (void)fetchHotAndInfoDatasFail;
@end


@interface DJTCommunityVM : DJTBaseVM

// 代理
@property (nonatomic, weak) id<DJTCommunity_VM_Protocol>delegate;

// 社区帖子数据源
@property (nonatomic, strong) NSMutableArray<DJT_Recommend_Model*> *recommendArray;
@property (nonatomic, strong) NSMutableArray<DJTCommunityCellLayout*> *communityLayoutArray;

// 获取热门和资讯信息的请求
- (void)fetchHotAndInfoDatasByPageNum:(NSInteger)page;

@end

NS_ASSUME_NONNULL_END
