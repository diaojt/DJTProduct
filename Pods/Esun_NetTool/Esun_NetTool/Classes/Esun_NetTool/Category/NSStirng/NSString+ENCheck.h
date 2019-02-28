//
//  NSString+Check.h
//  FBSDK
//
//  Created by LiuPW on 2017/10/16.
//  Copyright © 2017年 LiuPW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ENCheck)

/**
 检查字符串是否是有效字符串
NO;
 @param string 被检查字符串
 @return 有效返回YES，无效返回NO;
 */
+ (BOOL)isAvailableString:(NSString *)string;

//将整形转换为字符串
+ (NSString *)transIntFromString:(NSInteger)intValue;

//检查真实姓名 包含非汉字、 20<=长度>1
+ (BOOL)checkNameIsValid:(NSString *)truthName;

//检查手机号规则 0：符合规则 1：不足11位 2：不是以1开头 3:不是以1开头的11位数字
+ (NSInteger)checkPhoneNumIsValid:(NSString *)phoneNum;

//检查银行卡是否有效
+ (BOOL)checkBankNumIsValid:(NSString *)bankNum;

//检查身份证
+ (BOOL)checkIdentifyIsValid:(NSString *)identifyCardNum;

//检查验证码
+ (BOOL)checkVerifyNumIsValid:(NSString *)verifyNum;

//检查登录密码
+ (NSString *)checkPasswordIsValid:(NSString *)password;

//检查支付密码
+ (BOOL)checkPayPwdIsValid:(NSString *)payPwd;

//简单检查支付密码 仅检查支付密码长度
+ (BOOL)checkSimplePayPwdIsValid:(NSString *)payPwd;

//验证0和非0开始的数字
+ (BOOL)checkMoneyNumIsValid:(NSString *)moneyValue;

@end
