//
//  PrintLog.h
//  ToolYu
//
//  Created by LiuPW on 16/7/20.
//  Copyright © 2016年 LiuPW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EN_PrintLog : NSObject

+ (void)logWithSuccessResponse:(id)response
                           url:(NSString *)url
                        params:(NSDictionary *)params;

@end
