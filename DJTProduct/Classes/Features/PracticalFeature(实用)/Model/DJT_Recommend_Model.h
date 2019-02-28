//
//  DJT_Recommend_Model.h
//  DJTProduct
//
//  Created by Smy_D on 2018/11/11.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


// 头像model
@interface DJT_Photo_Model : NSObject

@property (nonatomic, copy) NSString *str_urlOfFullSize;    ///< 头像原图url
@property (nonatomic, copy) NSString *str_urlOfThumbnail;   ///< 头像缩略图url
@property (nonatomic, copy) NSString *str_width;            ///< 宽
@property (nonatomic, copy) NSString *str_height;           ///< 高
@property (nonatomic, strong) UIImage *image_original;      ///< 原图
@property (nonatomic, strong) UIImage *image_thumbnail;     ///< 缩略图

@end

// 投票model
@interface DJT_Vote_Model : NSObject
@property (nonatomic, strong) NSArray *arr_ticket;      ///< 投票结果---两个NSString类型的数字
@property (nonatomic, strong) NSArray *arr_ratio;       ///< 两种投票所占比例
@property (nonatomic, strong) NSArray *arr_option;      ///< 两种投票的内容
@end

// 晒单内容model
@interface DJT_SquareContent_Model : NSObject
@property (nonatomic, copy) NSString *str_title;        ///< 晒单title
@property (nonatomic, copy) NSString *str_text;         ///< 晒单文字内容
@property (nonatomic, strong) NSArray<DJT_Photo_Model *>*arr_image;       ///< 晒单图片
@property (nonatomic, strong) DJT_Vote_Model *m_vote;   ///< 投票样式的晒单会有这个参数
@property (nonatomic, copy) NSString *str_type;         ///< 类型：1是正常晒单，2是投票
@end

// 点赞model
@interface DJT_Like_Model : NSObject
@property (nonatomic, copy) NSString *str_likenum;      ///< 点赞数
@property (nonatomic, strong) NSArray *like_list;       ///< 点赞人uid列表
@end

// 评论model
@interface DJT_CommentRecord_Model : NSObject
@property (nonatomic, copy) NSString *str_commentnum;   ///< 评论数
@property (nonatomic, strong) NSArray *comment_list;    ///< 评论人uid列表
@end

// 发单人地理位置
@interface DJT_Location_Model : NSObject
@property (nonatomic, copy)NSString *str_city;          ///< 发单人城市
@property (nonatomic, copy)NSString *str_address;       ///< 发单人地址
@end


// 社区帖子model
@interface DJT_Recommend_Model : NSObject

@property (nonatomic, copy) NSString *m_nickname;                   ///< 用户昵称
@property (nonatomic, copy) NSString *m_username;                   ///< 发单人用户名
@property (nonatomic, copy) NSString *m_doctype;                      ///< 晒单类型
@property (nonatomic, copy) NSString *m_status;                     ///< 晒单状态：红单、黑单、灰单
@property (nonatomic, copy) NSString *m_isLike;                     ///< 是否点赞
@property (nonatomic, copy) NSString *m_uid;                        ///< 发单人用户id
@property (nonatomic, copy) NSString *m_opstatus;                   ///<
@property (nonatomic, strong) DJT_Photo_Model *m_icon;               ///< 发单人头像model
@property (nonatomic, copy) NSString *m_unquid;                     ///<
@property (nonatomic, copy) NSString *m_reported;                   ///< 是否被举报
@property (nonatomic, copy) NSString *m_rawzdstatus;                ///< 加精
@property (nonatomic, copy) NSString *m_jingpin;                    ///< 是否精品帖 666
@property (nonatomic, copy) NSString *m_circlename;                 ///< 圈子来源
@property (nonatomic, copy) NSString *m_date;                       ///< 发帖时间
@property (nonatomic, strong) DJT_Like_Model *m_likes;              ///< 点赞数+点赞人uid列表
@property (nonatomic, strong) DJT_CommentRecord_Model *m_comments;  ///< 评论数+评论人uid列表
@property (nonatomic, strong) DJT_Location_Model *m_location;       ///< 位置信息
@property (nonatomic, strong) DJT_SquareContent_Model *m_content;   ///< 晒单内容

@end

NS_ASSUME_NONNULL_END
