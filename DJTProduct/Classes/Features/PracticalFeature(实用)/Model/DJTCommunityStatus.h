//
//  DJTCommunityStatus.h
//  DJTProduct
//
//  Created by Smy_D on 2018/11/7.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DJT_Hot_Model.h"
#import "DJT_Recommend_Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJTCommunityStatus : NSObject

@property (nonatomic, strong) DJT_Hot_Model *m_hot;
@property (nonatomic, strong) NSMutableArray<DJT_Recommend_Model *>*m_recommends;

@end

NS_ASSUME_NONNULL_END
