//
//  NSString+Check.m
//  FBSDK
//
//  Created by LiuPW on 2017/10/16.
//  Copyright © 2017年 LiuPW. All rights reserved.
//

#import "NSString+ENCheck.h"

@implementation NSString (ENCheck)

+ (BOOL)isAvailableString:(NSString *)string
{
    if (![string isKindOfClass:[NSString class]]) {
//        NSLog(@"字符串 %@ 非法",string);
        
        return NO;
    }
    
    NSString *realString = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (!realString) {
//        NSLog(@"字符串 %@ 非法",realString);
        return NO;
    }
    
    
    
    if (realString.length <= 0) {
//        NSLog(@"字符串 %@ 非法",realString);
        
        return NO;
    }
    
    return YES;
}


+ (NSString *)transIntFromString:(NSInteger)intValue
{
    return [NSString stringWithFormat:@"%0.2f",intValue * 0.01];
}

+ (BOOL)checkNameIsValid:(NSString *)truthName
{
//    if (![NSString isAvailableString:truthName]) return NO;
    
    NSRange range1 = [truthName rangeOfString:@"·"];
    NSRange range2 = [truthName rangeOfString:@"•"];
    if(range1.location != NSNotFound ||   // 中文 ·
       range2.location != NSNotFound )    // 英文 •
    {
        //一般中间带 `•`的名字长度不会超过15位，如果有那就设高一点
        if ([truthName length] == 1 || [truthName length] > 20)
        {
            return NO;
        }
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\u4e00-\u9fa5]+[·•][\u4e00-\u9fa5]+$" options:0 error:NULL];
        
        NSTextCheckingResult *match = [regex firstMatchInString:truthName options:0 range:NSMakeRange(0, [truthName length])];
        
        NSUInteger count = [match numberOfRanges];
        
        return count == 1;
    }
    else
    {
        //一般正常的名字长度不会少于2位并且不超过8位，如果有那就设高一点
        if ([truthName length] < 2 || [truthName length] > 20) {
            return NO;
        }
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\u4e00-\u9fa5]+$" options:0 error:NULL];
        
        NSTextCheckingResult *match = [regex firstMatchInString:truthName options:0 range:NSMakeRange(0, [truthName length])];
        
        NSUInteger count = [match numberOfRanges];
        
        return count == 1;
    }
    
}

+ (NSInteger)checkPhoneNumIsValid:(NSString *)phoneNum
{
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (phoneNum.length != 11) {
        return 1;
    }
    else if(![phoneNum hasPrefix:@"1"])
    {
        return 2;
    }
    else
    {
        NSString *pattern = @"^1+\\d{10}";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
        BOOL isMatch = [pred evaluateWithObject:phoneNum];
        if (!isMatch) {
            return 3;
        }
        return 0;
    }
   
}

+ (BOOL)checkBankNumIsValid:(NSString *)bankNum
{
    bankNum = [bankNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (bankNum.length >=  16 && bankNum.length <= 19) {
      
        return YES;
    }
    return NO;
}

+ (BOOL)checkVerifyNumIsValid:(NSString *)verifyNum
{
    if (verifyNum.length != 6) {
        return NO;
    }
   
    return YES;
}

+ (BOOL)checkIdentifyIsValid:(NSString *)identifyCardNum
{
    identifyCardNum = [identifyCardNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (identifyCardNum.length != 18) {
        return NO;
    }
    
    return YES;
}

+ (NSString *)checkPasswordIsValid:(NSString *)password
{
    //登录密码规则 8~20位 必须包含 大写字母、小写字母、标点符号(除空格)、数字中至少两种
    if (password.length < 8 || password.length > 20) {
        return @"密码长度应为8到20个字符";
    }
    
    
    NSRange spaceRange = [password rangeOfString:@" "];
    if (spaceRange.location != NSNotFound) {
        return @"密码包含非法字符";
    }
    
    NSInteger resultValue = 0;
    //26个大写英文字母组成的组合
    NSString *letterUpRegx = @"[A-Z]+";
    NSString *letterRegx = @"[a-z]+";
    NSString *numRegx = @"[0-9]+";
    NSString *symbol1Regx =  @"[\x21-\x2f,\x3a-\x40,\\x5b-\x60,\x7B-\x7F]+";
    
    //判断包含大写字母
    BOOL upLetterIsMatch = [self isMatchPred:letterUpRegx withSourceString:password];
    resultValue += upLetterIsMatch ? 1 : 0;
    
    //判断包含小写字母
    BOOL letterIsMatch = [self isMatchPred:letterRegx withSourceString:password];
    resultValue += letterIsMatch ? 1 : 0;
    
    //判断包含数字
    BOOL numIsMatch = [self isMatchPred:numRegx withSourceString:password];
    resultValue += numIsMatch ? 1 : 0;
    
    //判断包含符号
    BOOL symbol1IsMatch = [self isMatchPred:symbol1Regx withSourceString:password];
    resultValue += symbol1IsMatch ? 1 : 0;
    
    if( resultValue >= 2)
    {
        return @"";
    }
    else
    {
        return @"密码需要包含大、小写字母、数字、标点符号至少2种";
    }
}

+ (BOOL)checkPayPwdIsValid:(NSString *)payPwd
{
    //判断6位数字
    
    BOOL isNum = [self checkSimplePayPwdIsValid:payPwd];
    if (!isNum) {
        return NO;
    }
    
    else
    {
        //判断相同数字
        BOOL isSame = [self isSameNum:payPwd];
        if (isSame) {
            return NO;
        }
        else
        {
            //判断连续数字
            BOOL isOrderNum = [self isOrderNum:payPwd];
            
            if (isOrderNum) {
                return NO;
            }
            
            return YES;
        }
    }
}

//判断是否是相同数字
+ (BOOL)isSameNum:(NSString *)sourceNum
{
    for (NSInteger i = 0; i < sourceNum.length - 1; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSRange range2 = NSMakeRange(i+1, 1);
        
        NSInteger k = [[sourceNum substringWithRange:range] integerValue];
        NSInteger j = [[sourceNum substringWithRange:range2] integerValue];
        
        if (k == j) {
            continue;
        }
        else
        {
            return NO;
        }
    }
    
    return YES;
}

//判断是否是连续数字
//判断是否是连续数字
+ (BOOL)isOrderNum:(NSString *)sourceNum
{
    BOOL upOrder = NO;
    BOOL downOrder = NO;
    
    for (NSInteger i = 0; i < sourceNum.length - 1; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSRange range2 = NSMakeRange(i+1, 1);
        
        NSInteger k = [[sourceNum substringWithRange:range] integerValue];
        NSInteger j = [[sourceNum substringWithRange:range2] integerValue];
        
        if (k - j == 1) {
            //降序
            downOrder = YES;
            if (!upOrder) {
                continue;
            }
            else
            {
                return NO;
            }
        }
        else
            if (k - j == -1) {
                //升序
                upOrder = YES;
                if (!downOrder) {
                    continue;
                }
                else
                {
                    return NO;
                }
            }
            else
            {
                return NO;
            }
    }
    
    
    return YES;
}


+ (BOOL)isMatchPred:(NSString *)predicateString withSourceString:(NSString *)sourceString
{
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:predicateString options:0 error:NULL];
    
    NSTextCheckingResult *match = [regex firstMatchInString:sourceString options:0 range:NSMakeRange(0, [sourceString length])];
    
    NSUInteger count = [match numberOfRanges];
    
    return count == 1;
    
}

+ (BOOL)checkSimplePayPwdIsValid:(NSString *)payPwd
{
    NSString *numRegex = @"[0-9]{6}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numRegex];
    BOOL isNum = [pred evaluateWithObject:payPwd];
    return isNum;
}

+ (BOOL)checkMoneyNumIsValid:(NSString *)moneyValue
{
    NSString *moneyNumRegex = @"([1-9]\\d*\\.?\\d*)|(0\\.\\d*[0-9])";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",moneyNumRegex];
    BOOL isMoneyValue = [pred evaluateWithObject:moneyValue];
    return  isMoneyValue;
}
@end
