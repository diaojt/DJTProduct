//
//  DJTCommunityStatus.m
//  DJTProduct
//
//  Created by Smy_D on 2018/11/7.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "DJTCommunityStatus.h"

@implementation DJTCommunityStatus

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"m_hot" : @"hot",
             @"m_recommends" : @"recommends"
             };
}


+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"m_recommends" : @"DJT_Recommend_Model"
             };
}


@end
