//
//  DJTPracticalFeatureViewController.m
//  DJTProduct
//
//  Created by Smy_D on 2018/7/12.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "DJTPracticalFeatureViewController.h"
#import <Masonry.h>
#import "DJTCommunityVM.h"
#import "DJTRefreshHeader.h"
#import "DJTRefreshFooter.h"
#import "DJTCommunityCell.h"
//#import "YYPhotoGroupView.h"

#define cellID @"COMMUNITYCELL"

@interface DJTPracticalFeatureViewController ()<UITableViewDelegate,UITableViewDataSource,DJTCommunity_VM_Protocol,DJTCommunityCellDelegate>
{
    @public
    NSInteger _currentPage;
}
@property (nonatomic, strong) UITableView *infoTableView;
@property (nonatomic, strong) DJTCommunityVM *communityVM;
@end

@implementation DJTPracticalFeatureViewController

- (instancetype)init{
    if (self = [super init]) {
        self.hideNum = [NSNumber numberWithInteger:0];
        NSLog(@"%@",self.hideNum);
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _currentPage = 0;
    [self.communityVM fetchHotAndInfoDatasByPageNum:_currentPage];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavBar];
    [self setupTableView];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addSubViews];
    [self setConstraints];

}

- (BOOL)prefersStatusBarHidden
{
    BOOL hide = self.hideNum.boolValue;
    return hide;
}


#pragma mark - Initial Method

- (void)setupNavBar
{
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)addSubViews
{
    
    [self.view addSubview:self.infoTableView];
    
}

- (void)setupTableView
{
    self.infoTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    
    // tableview 添加下拉刷新/上拉加载
    self.infoTableView.mj_header = [DJTRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(downPullUpdateData)];
    self.infoTableView.mj_footer = [DJTRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(upPullLoadMoreData)];
    
    [self.view addSubview:self.infoTableView];
}


#pragma mark -TargetAction

// 下拉刷新
- (void)downPullUpdateData
{
    _currentPage = 0;
    [self.communityVM fetchHotAndInfoDatasByPageNum:_currentPage];
}

// 上拉加载更多
- (void)upPullLoadMoreData
{
    ++ _currentPage;
    [self.communityVM fetchHotAndInfoDatasByPageNum:_currentPage];
}

#pragma mark -publicMethod

#pragma mark -privateMethod

#pragma mark -UITableViewDataSource &UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.communityVM.recommendArray.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    DJTCommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[DJTCommunityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
    }
    [cell setLayout:self.communityVM.communityLayoutArray[indexPath.row]];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((DJTCommunityCellLayout *)self.communityVM.communityLayoutArray[indexPath.row]).height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:@"https://httpbin.org/get" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject =====>>> : %@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error =====>>>> : %@",error);
    }];
}
#pragma mark -OtherDelegate
- (void)fetchHotAndInfoDatasSuccess
{
    //NSLog(@"%@请求成功:\n%@");
    [self.infoTableView reloadData];
    [self.infoTableView.mj_header endRefreshing];
    [self.infoTableView.mj_footer endRefreshing];
}

- (void)fetchHotAndInfoDatasFail
{
    [self.infoTableView.mj_header endRefreshing];
    [self.infoTableView.mj_footer endRefreshing];
}

#pragma mark -DJTCommunityCellDelegate
/// 点击了 Cell
- (void)cellDidClick:(DJTCommunityCell *)cell{
    
}
/// 点击了关注
- (void)cellDidClickFollow:(DJTCommunityCell *)cell{
    
}
/// 点击了评论
- (void)cellDidClickComment:(DJTCommunityCell *)cell{
    DJTLog(@"点击了评论");
}
/// 点击了赞
- (void)cellDidClickLike:(DJTCommunityCell *)cell{
    DJTLog(@"点击了赞");
    
}
/// 点击了图片
- (void)cell:(DJTCommunityCell *)cell didClickImageAtIndex:(NSUInteger)index{
    
}

#pragma mark -layOut
-(void)setConstraints
{
    
}

#pragma mark - lazyLoad
- (UITableView *)infoTableView
{
    if (!_infoTableView) {
        _infoTableView = [[UITableView alloc] init];
        _infoTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _infoTableView.backgroundColor = [UIColor whiteColor];
        _infoTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    }
    return _infoTableView;
}

- (DJTCommunityVM *)communityVM
{
    if (!_communityVM) {
        
        _communityVM = [[DJTCommunityVM alloc] init];
        _communityVM.delegate = self;
    }
    return _communityVM;
}


@end
