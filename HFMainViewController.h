//
//  HFMainViewController.h
//  ClassNote
//
//  Created by XiaoYin Wang on 12-10-27.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFAppDelegate.h"

@interface HFMainViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIButton *classTableButton;
@property (retain, nonatomic) IBOutlet UIButton *lessonButton;
@property (retain, nonatomic) IBOutlet UIButton *aboutButton;
- (IBAction)logout:(id)sender;
- (IBAction)gotoLessonTable:(id)sender;
- (IBAction)gotoLesson:(id)sender;

@property (nonatomic, retain) HFAppDelegate *appDelegate;
@end
