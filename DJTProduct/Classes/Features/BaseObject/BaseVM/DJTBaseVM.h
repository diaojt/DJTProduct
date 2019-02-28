//
//  DJTBaseVM.h
//  DJTProduct
//
//  Created by Smy_D on 2018/11/7.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DJTBaseVM : NSObject

/**
 @desc   开始发送请求
 @param  requestId 接口号
 @param  params    参数
 @author Created by LeoHao on 2014-07-29
 */
- (void)requestStart:(NSString *)requestId
              params:(NSDictionary *)params;


/**
 @desc   开始发送请求
 @param  requestId 接口号
 @param  params    参数
 @param  show       是否展示加载窗口
 @author Created by LeoHao on 2015-4-9
 */
- (void)requestStart:(NSString *)requestId
              params:(NSDictionary *)params
     showLoadingView:(BOOL)show;

/**
 @desc   服务器数据返回
 @param  requestId  接口号
 @param  theOwner   接口的所有者
 @param  data       接口返回的数据
 @author Created by LeoHao on 2014-07-29
 */
- (void)requestFinish:(NSString *)requestId
             theOwner:(id)theOwner
                 data:(NSDictionary *)data;


/**
 @desc      网络请求失败
 @author    Created by LeoHao on 2014-9-13
 */
-(void)requestDidFailWithError:(NSError *)error
                     requestId:(NSString *)requestId
                      theOwner:(NSObject *)theOwner;

/**
 @desc   取消当前页面的网络请求
 @author Created by LeoHao on 2014-08-15
 */
- (void)cancelRequest;

@end

NS_ASSUME_NONNULL_END
