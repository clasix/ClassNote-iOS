//
//  NGViewController.h
//  NGVaryingGridViewDemo
//
//  Created by Philip Messlehner on 19.04.12.
//  Copyright (c) 2012 NOUS Wissensmanagement GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFLessonItemEditViewController.h"
#import "HFLessonItem.h"
#import "AddViewController.h"

static const int CLASSES_IN_DAY = 12;
static const int DAYS_IN_WEEK = 7;

@interface NGViewController : UIViewController<NSFetchedResultsControllerDelegate, AddViewControllerDelegate> {
    NSArray *weekdays;
    
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectContext *addingManagedObjectContext;
    
    NSFetchedResultsController *fetchedResultsController;
    
    NSMutableArray * lessonItemsArray;
    
    NSInteger selectedIndex;
    NSInteger selectedRow;
    NSInteger selectedColumn;
    NSInteger lesson_table_id;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) NSManagedObjectContext *addingManagedObjectContext;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, retain) NSMutableArray *lessonItemsArray;

@property (nonatomic, retain) UILabel *editLabel;
@property (nonatomic, retain) UIButton *deleteButton;

- (void)applicationWillResignActive:(NSNotification *)notification;

@end
