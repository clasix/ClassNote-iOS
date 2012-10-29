//
//  HFLessonListViewController.h
//  ClassNote
//
//  Created by XiaoYin Wang on 12-10-28.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddViewController.h"

static const int TYPE_WATCH_NOTES = 0;
static const int TYPE_SELECT_LESSONS = 1;


@protocol LessonListControllerDelegate;

@interface HFLessonListViewController : UITableViewController<UISearchDisplayDelegate, UISearchBarDelegate, NSFetchedResultsControllerDelegate, AddViewControllerDelegate>
{
    NSMutableArray			*listContent;			// The master content.
	NSMutableArray	*filteredListContent;	// The content filtered as a result of a search.
	
	// The saved state of the search UI if a memory warning removed the view.
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
    
    NSString        *searchingText;
    
    NSManagedObjectContext *managedObjectContext;
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *addingManagedObjectContext;
    
    id<LessonListControllerDelegate> delegate;
    int viewType;
}

@property (nonatomic, retain) NSArray *listContent;
@property (nonatomic, retain) NSMutableArray *filteredListContent;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

@property (nonatomic, retain) NSString *searchingText;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectContext *addingManagedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, assign) int viewType;

@property (nonatomic, assign) id<LessonListControllerDelegate> delegate;

@end

@protocol LessonListControllerDelegate
- (void)finishedLessonInfos:(NSSet *)lessonInfos;
@end
