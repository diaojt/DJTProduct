//
//  DJT_Hot_Model.h
//  DJTProduct
//
//  Created by Smy_D on 2018/12/5.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJT_Recommend_Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJT_Hot_Model : NSObject
@property (nonatomic, copy) NSString *m_link;
@property (nonatomic, copy) NSString *m_name;
@property (nonatomic, copy) NSString *m_joinnum;
@property (nonatomic, copy) NSString *m_color;
@property (nonatomic, strong) NSArray<DJT_Recommend_Model *> *m_list;

@end

NS_ASSUME_NONNULL_END
