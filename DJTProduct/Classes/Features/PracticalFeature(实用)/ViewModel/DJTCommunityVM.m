//
//  DJTCommunityVM.m
//  DJTProduct
//
//  Created by Smy_D on 2018/11/7.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "DJTCommunityVM.h"
#import "DJTCommunityStatus.h"

@interface DJTCommunityVM()
{
    @public
    NSInteger _currentPage;
}
@end

@implementation DJTCommunityVM

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentPage = 0;
    }
    return self;
}

// 获取热门和广场信息的请求
- (void)fetchHotAndInfoDatasByPageNum:(NSInteger)page{
    _currentPage = page;
    DJTLog(@"%s 发起请求",object_getClassName(self));
    [self requestStart:@"https://ews.500.com/sns/app/newhomepage" params:@{@"pn":[NSNumber numberWithInteger:page]} showLoadingView:NO];

}
// 请求成功处理
-(void)processingData:(id)data requestId:(NSString *)requestId {
    
    DJTLog(@"%@请求成功:\n%@",requestId,data);
    // 解析返回数据
    [self handlingReturnData:data requestId:requestId];
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(fetchHotAndInfoDatasSuccess)]) {
        [self.delegate fetchHotAndInfoDatasSuccess];
    }
}

// 请求失败处理
-(void)processingFailure:(NSDictionary *)data requestId:(NSString *)requestId {
    DJTLog(@"%@请求发生错误!!!!!!!",requestId);
    if ([self.delegate respondsToSelector:@selector(fetchHotAndInfoDatasFail)]) {
        [self.delegate fetchHotAndInfoDatasFail];
    }
    
}



// 处理数据
- (void)handlingReturnData:(id)data requestId:(NSString *)requestId
{
    // 遍历recommends数组，转化为cellLayout存放在临时数组
    DJTCommunityStatus *tmpstatus = [DJTCommunityStatus mj_objectWithKeyValues:data];
    NSMutableArray *tmpLayoutArr = [NSMutableArray array];
    for (DJT_Recommend_Model *recommendModel in tmpstatus.m_recommends) {
        DJTCommunityCellLayout *communityLayout = [[DJTCommunityCellLayout alloc] initWithStatus:recommendModel style:DJTCommunityLayoutStyleDetail];
        
        [tmpLayoutArr addObject:communityLayout];
    }
    
    // 第一页清空原数组
    if (_currentPage == 0) {
        
        [self.recommendArray removeAllObjects];
        [self.communityLayoutArray removeAllObjects];
    }
    [self.recommendArray addObjectsFromArray:tmpstatus.m_recommends];
    [self.communityLayoutArray addObjectsFromArray:tmpLayoutArr];
}


- (NSMutableArray *)recommendArray
{
    if (!_recommendArray) {
        _recommendArray = [NSMutableArray array];
    }
    return _recommendArray;
}

- (NSMutableArray *)communityLayoutArray
{
    if (!_communityLayoutArray){
        
        _communityLayoutArray = [NSMutableArray array];
    }
    return _communityLayoutArray;
}
@end
