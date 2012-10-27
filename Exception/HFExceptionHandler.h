//
//  HFExceptionHandler.h
//  ClassNote
//
//  Created by XiaoYin Wang on 12-10-27.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFExceptionHandler : NSObject

+ (void) handleException: (NSException *) exception;

+ (void) networkAlert;

+ (void)setDefaultUncaughtHandler;

+ (NSUncaughtExceptionHandler*)getUncaughtHandler;

@end
