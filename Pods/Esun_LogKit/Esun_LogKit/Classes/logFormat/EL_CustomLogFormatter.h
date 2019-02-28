//
//  EL_CustomLogFormatter.h
//  LogSystem
//
//  Created by LiuPW on 2018/10/6.
//  Copyright © 2018年 LiuPW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDLog.h"

@interface EL_CustomLogFormatter : NSObject<DDLogFormatter>
{
    int atomicLoggerCount;
    NSDateFormatter *threadUnsafeDateFormatter;
}
@end
