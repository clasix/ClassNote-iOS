//
//  HFExceptionHandler.m
//  ClassNote
//
//  Created by XiaoYin Wang on 12-10-27.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import "HFExceptionHandler.h"
#import "TException.h"

NSString *applicationDocumentsDirectory() {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSString *url = [NSString stringWithFormat:@"=============异常崩溃报告=============\nname:\n%@\nreason:\n%@\ncallStackSymbols:\n%@",
                     name,reason,[arr componentsJoinedByString:@"\n"]];
    NSString *path = [applicationDocumentsDirectory() stringByAppendingPathComponent:@"Exception.txt"];
    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    //除了可以选择写到应用下的某个文件，通过后续处理将信息发送到服务器等
    //还可以选择调用发送邮件的的程序，发送信息到指定的邮件地址
    //或者调用某个处理程序来处理这个信息
}

@implementation HFExceptionHandler

+ (void) networkAlert {
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"连接网络失败" message:@"请检查网络连接或者服务" delegate:self cancelButtonTitle:@"OK,I know" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

+ (void) handleException: (NSException *) exception {
    if ([exception isKindOfClass:[TException class]]) {
        [self networkAlert];
    } else {
        UncaughtExceptionHandler(exception);
    }
}

-(NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (void)setDefaultUncaughtHandler
{
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
}

+ (NSUncaughtExceptionHandler*)getUncaughtHandler
{
    return NSGetUncaughtExceptionHandler();
}

@end
