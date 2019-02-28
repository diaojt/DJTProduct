//
//  DJTPhotoBrowserView.h
//  DJTProduct
//
//  Created by Smy_D on 2019/1/24.
//  Copyright © 2019年 Smy_D. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class DJTPhotoListModel;
@interface DJTPhotoBrowserView : UIView
@property (nonatomic, strong) DJTPhotoListModel *listModel;

-(void)show;

@end

NS_ASSUME_NONNULL_END
