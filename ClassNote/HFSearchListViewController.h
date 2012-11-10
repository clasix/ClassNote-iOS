//
//  HFSearchListViewController.h
//  ClassNote
//
//  Created by XiaoYin Wang on 12-11-5.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import <UIKit/UIKit.h>

#define stepProvince 0
#define stepSchool 1
#define stepDept 2
#define stepYear 3

@protocol SearchListViewControllerDelegate;
@interface HFSearchListViewController : UITableViewController<UISearchDisplayDelegate, UISearchBarDelegate>{
    NSMutableArray			*listContent;			// The master content.
	NSMutableArray	*filteredListContent;	// The content filtered as a result of a search.
    
    // The saved state of the search UI if a memory warning removed the view.
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
    
    int searchStep;
}

@property (nonatomic, retain) NSArray *listContent;
@property (nonatomic, retain) NSMutableArray *filteredListContent;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

@property (nonatomic, assign) int searchStep;

@property (nonatomic, assign) id <SearchListViewControllerDelegate> delegate;

@end

@protocol SearchListViewControllerDelegate
- (void)finishSearch;
@end
