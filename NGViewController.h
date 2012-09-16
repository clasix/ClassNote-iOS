//
//  NGViewController.h
//  NGVaryingGridViewDemo
//
//  Created by Philip Messlehner on 19.04.12.
//  Copyright (c) 2012 NOUS Wissensmanagement GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFViewController.h"

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

- (void)applicationWillResignActive:(NSNotification *)notification;

@end
