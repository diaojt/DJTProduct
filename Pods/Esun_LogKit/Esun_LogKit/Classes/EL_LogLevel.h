//
//  EL_LogLevel.h
//  Esun_LogKit
//
//  Created by LiuPW on 2018/10/10.
//  Copyright © 2018年 liupw. All rights reserved.
//

#ifndef EL_LogLevel_h
#define EL_LogLevel_h

#define LOG_LEVEL_DEF ddLogLevel
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "SignalHandler.h"
#import "UncaughtExceptionHandler.h"

#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelDebug;
#else
static const DDLogLevel ddLogLevel = DDLogLevelError;
#endif


#endif /* EL_LogLevel_h */
