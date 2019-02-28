//
//  DJT_Hot_Model.m
//  DJTProduct
//
//  Created by Smy_D on 2018/12/5.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "DJT_Hot_Model.h"

@implementation DJT_Hot_Model

+ (NSDictionary *)mj_replacedKeyFromPropertyName{

    return @{@"m_link"      : @"link",
             @"m_name"      : @"name",
             @"m_joinnum"   : @"joinnum",
             @"m_color"     : @"color",
             @"m_list"      : @"list"
             };
    
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"m_list" : @"DJT_Recommend_Model"
             };
}

@end
