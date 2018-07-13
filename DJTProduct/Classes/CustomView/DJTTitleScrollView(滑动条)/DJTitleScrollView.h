//
//  DJTitleScrollView.h
//  DJTProduct
//
//  Created by Smy_D on 2018/7/13.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "DJTNavBar.h"


/**
 协议方法
 */
@protocol DJT_TitleScrollView_Protocol<NSObject>
- (void)titleScrollViewTitleChange:(NSInteger)titleIndex;
@end

@interface DJTitleScrollView : DJTNavBar
//标题按钮数组
@property (strong , nonatomic)NSMutableArray *titleButtonArray;
//默认第一个
@property (nonatomic, assign) NSInteger firstIndex;
//代理
@property (nonatomic, assign) id<DJT_TitleScrollView_Protocol> delegate_t;


/**
 字体缩放
 */
- (void)setUpTitleScale:(void(^)(CGFloat *titleScale))titleScaleBlock;

/**
 progress设置
 *progressLength        设置progress长度
 *progressHeight        设置progress高度
 */
- (void)setUpProgressAttribute:(void(^)(CGFloat *progressLength, CGFloat *progressHeight))settingProgressBlock;

/**
 初始化
 *titleScrollViewBgColor 标题背景色
 *norColor               标题字体未选中状态下颜色
 *selColor               标题字体选中状态下颜色
 *proColor               字体下方指示器颜色
 *titleFont              标题字体大小
 *isShowPregressView     是否开启字体下方指示器
 *isOpenStretch          是否开启指示器拉伸效果
 *isOpenShade            是否开启字体渐变效果
 @param BaseSettingBlock 设置基本属性
 */
- (void)setUpDisplayStyle:(void(^)(UIColor **titleScrollViewBgColor,UIColor **norColor,UIColor **selColor,UIColor **proColor,UIFont **titleFont,BOOL *isShowPregressView,BOOL *isOpenStretch,BOOL *isOpenShade))BaseSettingBlock;


/**
 设置所有标题

 @param titleArr 标题数组
 */
- (void)setUpAllTitleWithArray:(NSMutableArray *)titleArr;



/**
 选中某个标题

 @param titleIndex 标题位置
 */
- (void)selectTitleAtIndex:(NSInteger)titleIndex;



/**
 底部滚动条滚动

 @param offsetx 偏移距离
 */
- (void)bottomBarNaughtyWithOffset:(CGFloat)offsetx;


/**
 title变化时两个button变化

 @param contenOffset 偏移
 */
- (void)setUpLeftAndRightBtn:(CGPoint)contenOffset;


/**
 设置是否有拉伸效果

 @param isStre 有/没有
 */
- (void)setUpPregressViewStretchAllowed:(BOOL)isStre;



/**
 标题按钮点击

 @param button 点击按钮
 */
- (void)titleButtonClick:(UIButton *)button;


@end
