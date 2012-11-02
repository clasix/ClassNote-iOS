//
//  HFAddLessonViewController.h
//  ClassNote
//
//  Created by XiaoYin Wang on 12-10-29.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFLesson.h"

#define kDayInWeekComponent 0
#define kStartComponent 1
#define kEndComponent 2

@protocol AddLessonDelegate;

@interface HFAddLessonViewController : UITableViewController<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    NSArray *WEEKDAYS;
    
    NSMutableArray			*lessonInfos;
    HFLesson                *lesson;
    
    id <AddLessonDelegate> delegate;
    UITextField *activeField;
}

@property (nonatomic, retain) NSMutableArray *lessonInfos;
@property (nonatomic, retain) HFLesson *lesson;

- (IBAction)toolBarDone:(id)sender;
@property (retain, nonatomic) IBOutlet UIToolbar *doneToolbar;
@property (retain, nonatomic) IBOutlet UIPickerView *selectPicker;

@property (nonatomic, assign) id <AddLessonDelegate> delegate;
@end

@protocol AddLessonDelegate
- (void)addLessonViewController:(HFAddLessonViewController *)controller didFinishWithSave:(BOOL)save;

- (HFLessonInfo*)addLessonInfo:(HFAddLessonViewController *)controller;

- (void)removeLessonInfo:(HFAddLessonViewController *)controller atIndex:(int)index;

@end
