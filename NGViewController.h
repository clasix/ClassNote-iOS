//
//  NGViewController.h
//  NGVaryingGridViewDemo
//
//  Created by Philip Messlehner on 19.04.12.
//  Copyright (c) 2012 NOUS Wissensmanagement GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFClassEditViewController.h"
#import "HFClass.h"
#import "AddViewController.h"

static const int CLASSES_IN_DAY = 12;
static const int DAYS_IN_WEEK = 7;

@interface NGViewController : UIViewController<NSFetchedResultsControllerDelegate, AddViewControllerDelegate> {
    NSArray *weekdays;
    
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectContext *addingManagedObjectContext;
    
    NSFetchedResultsController *fetchedResultsController;
    
    NSMutableArray * classesArray;
    
    NSInteger selectedIndex;
    NSInteger selectedRow;
    NSInteger selectedColumn;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) NSManagedObjectContext *addingManagedObjectContext;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, retain) NSMutableArray *classesArray;

@property (nonatomic, retain) UILabel *editLabel;
@property (nonatomic, retain) UIButton *deleteButton;

- (void)applicationWillResignActive:(NSNotification *)notification;

@end
