//
//  HFSettingsViewController.h
//  ClassNote
//
//  Created by XiaoYin Wang on 12-11-5.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFGotoMainDelegate.h"
#import "HFSearchListViewController.h"

#define kDeptComponent 0
#define kUserComponent 1

@interface HFSettingsViewController : UITableViewController<SearchListViewControllerDelegate>

@property (nonatomic, assign) id <HFGotoMainDelegate> delegate;

@end
