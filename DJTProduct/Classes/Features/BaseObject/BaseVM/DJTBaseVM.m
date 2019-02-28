//
//  DJTBaseVM.m
//  DJTProduct
//
//  Created by Smy_D on 2018/11/7.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "DJTBaseVM.h"
#import "EN_NetWorking.h"

@implementation DJTBaseVM


/**
 @desc   开始发送请求
 @param  requestId 接口号
 @param  params    参数
 @author Created by LeoHao on 2014-07-29
 */
- (void)requestStart:(NSString *)requestId params:(NSDictionary *)params {
    [self requestStart:requestId params:[params copy] showLoadingView:YES];
}



/**
 @desc   开始发送请求
 @param  requestId 接口号
 @param  params    参数
 @param  show       是否展示加载窗口
 @author Created by LeoHao on 2015-4-9
 */
- (void)requestStart:(NSString *)requestId params:(NSDictionary *)params showLoadingView:(BOOL)show{
    params = params ?: @{};
    
    //替换AFN进行网络请求
    WS(weakSelf);
    [EN_NetWorking postWithUrl:requestId refreshCache:YES params:params success:^(id response) {
        
        [weakSelf requestFinish:requestId theOwner:self data:response];
        
    } fail:^(NSError *error) {
        [weakSelf requestDidFailWithError:error requestId:requestId theOwner:self];
    }];
}


/**
 @desc   取消当前页面的网络请求
 @author Created by LeoHao on 2014-08-15
 */
- (void)cancelRequest {
   
}


- (void)requestFinish:(NSString *)requestId
             theOwner:(id)theOwner
                 data:(NSDictionary *)data{
   
    if (data != nil) {
        // 处理数据
        [self processingData:data[@"data"] requestId:requestId];
    }
    

    
}


/**
 @desc      网络请求失败
 @author    Created by LeoHao on 2014-9-13
 */
-(void)requestDidFailWithError:(NSError *)error
                     requestId:(NSString *)requestId
                      theOwner:(NSObject *)theOwner
{

}

/**
 *  处理成功请求
 *  @author Created by wjc on 2014-08-19
 *  @param data      返回数据
 *  @param requestId 请求Id
 */
-(void)processingData:(id)data requestId:(NSString *)requestId {
    DJTLog(@"%@ 请求成功:\n%@",requestId,data);
}
/**
 *  处理失败请求
 *  @author Created by wjc on 2014-08-19
 *  @param data      返回错误信息
 *  @param requestId 请求Id
 */
-(void)processingFailure:(NSDictionary *)data requestId:(NSString *)requestId {
    DJTLog(@"%@ 请求发生错误!!!!!!!",requestId);
}


@end
