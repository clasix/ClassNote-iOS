//
//  HFLessonInfo.h
//  ClassNote
//
//  Created by XiaoYin Wang on 12-9-5.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HFLesson;

@interface HFLessonInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * dayinweek;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * room;
@property (nonatomic, retain) NSNumber * start;
@property (nonatomic, retain) HFLesson * lesson;

@end
