//
//  HFLessonTableItem.h
//  ClassNote
//
//  Created by XiaoYin Wang on 12-10-29.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HFLessonInfo;

@interface HFLessonTableItem : NSManagedObject

@property (nonatomic, retain) NSNumber * tableId;
@property (nonatomic, retain) HFLessonInfo *lessonInfo;

@end
