//
//  HFUtils.h
//  ClassNote
//
//  Created by XiaoYin Wang on 12-10-29.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFUtils : NSObject

+ (NSString *)getAuthToken;

+ (void) setAuthToken: (NSString *) auth_token;

+ (NSInteger) getLessonTableID;

+ (BOOL) isLogged;

+ (BOOL) hasUserSettings;

+ (void) setLogged: (BOOL) logged;

+ (void) setLessonTableID: (NSInteger) table_id;

+ (NSDictionary *) userDictionary;

@end
