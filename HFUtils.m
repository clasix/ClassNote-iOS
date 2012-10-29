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

+ (NSInteger) getLessonTableID {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"lesson_table_id"];
}

+ (void) setLessonTableID: (NSInteger) table_id {
    [[NSUserDefaults standardUserDefaults] setInteger:table_id forKey:@"lesson_table_id"];
}

@end
