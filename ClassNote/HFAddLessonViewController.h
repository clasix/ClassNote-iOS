//
//  HFAddLessonViewController.h
//  ClassNote
//
//  Created by XiaoYin Wang on 12-10-29.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFLesson.h"

@interface HFAddLessonViewController : UITableViewController{
    NSMutableArray			*lessonInfos;
    HFLesson                *lesson;
}

@property (nonatomic, retain) NSMutableArray *lessonInfos;
@property (nonatomic, retain) HFLesson *lesson;

@end
