//
//  HFLessonEditViewController.h
//  ClassNote
//
//  Created by XiaoYin Wang on 12-9-13.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFLesson.h"

@interface HFLessonEditViewController : UIViewController<UITextFieldDelegate>
{
    HFLesson *hfLesson;
    NSManagedObject * editObject;
    UITextField *activeField;
}

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *bookLabel;
@property (retain, nonatomic) IBOutlet UILabel *teacherLabel;
@property (retain, nonatomic) IBOutlet UITextField *nameTextField;
@property (retain, nonatomic) IBOutlet UITextField *bookTextField;
@property (retain, nonatomic) IBOutlet UITextField *teacherTextField;

@property (nonatomic, retain) HFLesson *hfLesson;
@property (nonatomic, retain) NSManagedObject *editObject;
@property (nonatomic, retain) UITextField *activeField;

@end
