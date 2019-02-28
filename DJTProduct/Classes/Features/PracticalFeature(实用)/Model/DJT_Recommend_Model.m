//
//  DJT_Recommend_Model.m
//  DJTProduct
//
//  Created by Smy_D on 2018/11/11.
//  Copyright © 2018年 Smy_D. All rights reserved.
//

#import "DJT_Recommend_Model.h"

// 头像model
@implementation DJT_Photo_Model

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"str_urlOfFullSize"   : @"fullsize",
             @"str_urlOfThumbnail"  : @"thumbnail",
             @"str_width"           : @"width",
             @"str_height"          : @"height",
             @"str_img_id"          : @"imgid",
             @"image_original"      : @"image_original",
             @"image_thumbnail"     : @"image_thumbnail"
             };
    
}

@end


// 投票model
@implementation DJT_Vote_Model

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"arr_ticket" : @"ticket",
             @"arr_ratio"  : @"ratio",
             @"arr_option" : @"option"
             };
}

@end

// 点赞model
@implementation DJT_Like_Model

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"str_likenum" : @"total",
             @"like_list"   : @"list"
             };
}
@end

// 评论model
@implementation DJT_CommentRecord_Model

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"str_commentnum" : @"total",
             @"comment_list"   : @"list"
             };
}

@end

// 发单人地理位置
@implementation DJT_Location_Model

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"str_city"    : @"city",
             @"str_address" : @"address"
             };
}

@end


// 晒单内容model
@implementation DJT_SquareContent_Model

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"str_title" : @"facttitle",
             @"str_text"  : @"title",
             @"arr_image" : @"images",
             @"m_vote"    : @"votes",
             @"str_type"  : @"ctxtype"
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"arr_image" : @"DJT_Photo_Model"
             };
}

@end

// 社区帖子model
@implementation DJT_Recommend_Model

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"m_nickname"      : @"nickname",
             @"m_username"      : @"username",
             @"m_doctype"       : @"doctype",
             @"m_status"        : @"op_status",
             @"m_isLike"        : @"liked",
             @"m_uid"           : @"uid",
             @"m_opstatus"      : @"op_status",
             
             @"m_icon"          : @"photo",
             
             @"m_unquid"        : @"unqid",
             @"m_reported"      : @"reported",
             @"m_rawzdstatus"   : @"rawzdstatus",
             @"m_jingpin"       : @"zdstatus",
             @"m_circlename"    : @"circlename",
             
             @"m_date"          : @"date",
             @"m_likes"         : @"likes",
             @"m_comments"      : @"comments",
             @"m_location"      : @"location",
             @"m_content"       : @"content"
             };
    
}

@end
