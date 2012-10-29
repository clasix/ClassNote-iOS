//
//  HFLesson.h
//  ClassNote
//
//  Created by XiaoYin Wang on 12-10-29.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HFLessonInfo;

@interface HFLesson : NSManagedObject

@property (nonatomic, retain) NSString * book;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * teacher;
@property (nonatomic, retain) NSSet *lessonInfos;
@end

@interface HFLesson (CoreDataGeneratedAccessors)

- (void)addLessonInfosObject:(HFLessonInfo *)value;
- (void)removeLessonInfosObject:(HFLessonInfo *)value;
- (void)addLessonInfos:(NSSet *)values;
- (void)removeLessonInfos:(NSSet *)values;

@end
