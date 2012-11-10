//
//  HFUtils.m
//  ClassNote
//
//  Created by XiaoYin Wang on 12-10-29.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import "HFUtils.h"

@implementation HFUtils

+ (NSString *)getAuthToken {
    return (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"];
}

+ (void) setAuthToken: (NSString *) auth_token {
    [[NSUserDefaults standardUserDefaults] setObject:auth_token forKey:@"auth_token"];
}

+ (NSInteger) getLessonTableID {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"lesson_table_id"];
}

+ (void) setLessonTableID: (NSInteger) table_id {
    [[NSUserDefaults standardUserDefaults] setInteger:table_id forKey:@"lesson_table_id"];
}

+ (BOOL) isLogged {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogged"];
}

+ (BOOL) hasUserSettings {
    NSDictionary *dict = [HFUtils userDictionary];
    
    return !![dict objectForKey:@"dept"];
}

+ (void) setLogged: (BOOL) logged {
    [[NSUserDefaults standardUserDefaults] setBool:logged forKey:@"isLogged"];
}

+ (NSDictionary *) userDictionary {
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"userinfo"];
    if (dict == nil) {
        dict = [NSMutableDictionary dictionaryWithCapacity:3];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"userinfo"];
    }
    return dict;
}

+ (void) setUserValue: (NSString*)obj forkey:(NSString*)key {
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:[HFUtils userDictionary]];
    [dict setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"userinfo"];
    //
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
