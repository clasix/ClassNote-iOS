//
//  HFLessonItemEditViewController.h
//  ClassNote
//
//  Created by XiaoYin Wang on 12-6-26.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFLessonInfo.h"
#import "HFLesson.h"

@protocol AddHFLessonItemViewControllerDelegate;

@interface HFLessonItemEditViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>{
    HFLessonInfo *hfLessonItem;
    
    id <AddHFLessonItemViewControllerDelegate> delegate;

    NSArray * daysInWeek;
    NSInteger dayInWeek;
    NSInteger start;
    NSInteger duaration;
    HFLesson *hfLesson;
    
    bool keyboardShown;
    UITextField *activeField;
}
@property (nonatomic, retain) HFLessonInfo *hfLessonItem;
@property (nonatomic, retain) HFLesson *hfLesson;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UITextField *lessonText;
@property (retain, nonatomic) IBOutlet UITextField *classRoomText;
@property (retain, nonatomic) IBOutlet UIPickerView *dayInWeekPickerView;
@property (retain, nonatomic) IBOutlet UILabel *dayInWeekLabel;
@property (retain, nonatomic) IBOutlet UILabel *startLabel;
@property (retain, nonatomic) IBOutlet UILabel *endLabel;
@property (retain, nonatomic) IBOutlet UILabel *lessonLabel;
@property (retain, nonatomic) IBOutlet UILabel *classRoomLabel;

@property (nonatomic, assign) id <AddHFLessonItemViewControllerDelegate> delegate;

@property (nonatomic, assign) NSInteger dayInWeek;
@property (nonatomic, assign) NSInteger start;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

@protocol AddHFLessonItemViewControllerDelegate
- (void)addViewController:(HFLessonItemEditViewController *)controller didFinishWithSave:(BOOL)save;
@end
