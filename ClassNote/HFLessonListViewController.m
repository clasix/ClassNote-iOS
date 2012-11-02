//
//  HFLessonListViewController.m
//  ClassNote
//
//  Created by XiaoYin Wang on 12-10-28.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import "HFLessonListViewController.h"
#import "HFLesson.h"
#import "AddViewController.h"
#import "HFLessonInfo.h"
#import "HFAddLessonViewController.h"

@interface HFLessonListViewController ()

@end

@implementation HFLessonListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

@synthesize listContent, filteredListContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive;

@synthesize managedObjectContext, addingManagedObjectContext,fetchedResultsController, viewType;

@synthesize delegate, searchingText;


#pragma mark - 
#pragma mark Lifecycle methods

- (void)viewDidLoad
{
	self.title = @"Lessons";
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    if (viewType == TYPE_SELECT_LESSONS) {
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                                                               target:self action:@selector(cancel:)] autorelease];
//        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)] autorelease];
    }
    
    self.listContent = [NSMutableArray arrayWithArray:fetchedResultsController.fetchedObjects];
	
	// create a filtered list that will contain products for the search results table.
	self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.listContent count]];
	
	// restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
	
	[self.tableView reloadData];
	self.tableView.scrollEnabled = YES;
}

- (void)viewDidUnload
{
	self.filteredListContent = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    // save the state of the search UI so that it can be restored if the view is re-created
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
}

- (void)dealloc
{
	[listContent release];
	[filteredListContent release];
    
    [managedObjectContext release];
    [fetchedResultsController release];
    
    [searchingText release];
	
	[super dealloc];
}


#pragma mark -
#pragma mark UITableView data source and delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	/*
	 If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
	 */
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredListContent count] + 1;
    }
	else
	{
        return [self.listContent count] + 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
    /*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (indexPath.row >= [self.filteredListContent count]) {
            cell.textLabel.text = [NSString stringWithFormat:@"手动添加'%@'", self.searchingText];
        } else {
            HFLesson *hfLesson = [self.filteredListContent objectAtIndex:indexPath.row];
            cell.textLabel.text = hfLesson.name;
        }
    } else {
        if (indexPath.row >= [self.listContent count]) {
            cell.textLabel.text = [NSString stringWithFormat:@"手动添加'%@'", @"New Lesson"];
        } else {
            HFLesson *hfLesson = [self.listContent objectAtIndex:indexPath.row]; 
            cell.textLabel.text = hfLesson.name;
        }
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
	/*
	 If the requesting table view is the search display controller's table view, configure the next view controller using the filtered content, otherwise use the main list.
	 */
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        if (indexPath.row >= [self.filteredListContent count]) {
            [self addNewLesson:self.searchingText];
        } else {
            HFLesson *hfLesson = [self.filteredListContent objectAtIndex:indexPath.row];
            if (self.viewType == TYPE_SELECT_LESSONS) {
                [self.delegate finishedLessonInfos:hfLesson.lessonInfos];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                
                UIViewController *detailsViewController = [[UIViewController alloc] init];
                detailsViewController.title = hfLesson.name;
                
                [[self navigationController] pushViewController:detailsViewController animated:YES];
                [detailsViewController release];
            }
        }
    }
	else
	{
        if (indexPath.row >= [self.listContent count]) {
            [self addNewLesson:@"New Lesson"];
        } else {
            HFLesson *hfLesson = [self.listContent objectAtIndex:indexPath.row];
            if (self.viewType == TYPE_SELECT_LESSONS) {
                [self.delegate finishedLessonInfos:hfLesson.lessonInfos];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                UIViewController *detailsViewController = [[UIViewController alloc] init];
                detailsViewController.title = hfLesson.name;
                
                [[self navigationController] pushViewController:detailsViewController animated:YES];
                [detailsViewController release];
            }
        }
    }
}

- (void)addNewLesson: (NSString*) lessonName {
    HFAddLessonViewController * vc = [[HFAddLessonViewController alloc] initWithNibName:@"HFAddLessonView" bundle:nil];
    vc.delegate = self;
    //UITableViewStyleGrouped
    
//    addViewController.delegate = self;
	
	// Create a new managed object context for the new book -- set its persistent store coordinator to the same as that from the fetched results controller's context.
	NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
	self.addingManagedObjectContext = addingContext;
	[addingContext release];
	
	[addingManagedObjectContext setPersistentStoreCoordinator:[[fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
    
    HFLesson *hfLesson = (HFLesson *)[NSEntityDescription insertNewObjectForEntityForName:@"HFLesson" inManagedObjectContext:addingManagedObjectContext];
    
    hfLesson.name = lessonName;
    
    HFLessonInfo *hfLessonInfo = (HFLessonInfo *)[NSEntityDescription insertNewObjectForEntityForName:@"HFLessonInfo" inManagedObjectContext:addingManagedObjectContext];
    
    hfLessonInfo.lesson = hfLesson;
    hfLessonInfo.room = @"";
    hfLessonInfo.dayinweek = [NSNumber numberWithInt:1];
    hfLessonInfo.start = [NSNumber numberWithInt:1 + 1];
    hfLessonInfo.duration = [NSNumber numberWithInt:1];
    
    vc.lessonInfos = [NSMutableArray arrayWithCapacity:2];
    vc.lesson = hfLesson;
    [vc.lessonInfos addObject:hfLessonInfo];
    
    [self.navigationController pushViewController:vc animated:YES];
//    [vc release];
    
    // TODO: delegate.deleteLessonInfo  realize.
    // TODO: delegate.addLessonInfo
//    AddViewController *addViewController = [[AddViewController alloc] initWithStyle:UITableViewStyleGrouped];
//    [self.navigationController pushViewController:addViewController animated:YES];
//	
//	[addViewController release];
}

- (void)addLessonViewController:(HFAddLessonViewController *)controller didFinishWithSave:(BOOL)save {
    if (save) {
        NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
		[dnc addObserver:self selector:@selector(addControllerContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:addingManagedObjectContext];
        
        // do save
        // Create and configure a new instance of the Event entity.
        NSError *error;
		if (![addingManagedObjectContext save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
        
        [dnc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:addingManagedObjectContext];
    }
    
    self.addingManagedObjectContext = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (HFLessonInfo*)addLessonInfo:(HFAddLessonViewController *)controller {
    HFLessonInfo *hfLessonInfo = (HFLessonInfo *)[NSEntityDescription insertNewObjectForEntityForName:@"HFLessonInfo" inManagedObjectContext:addingManagedObjectContext];
    
    hfLessonInfo.lesson = controller.lesson;
    hfLessonInfo.room = @"";
    hfLessonInfo.dayinweek = [NSNumber numberWithInt:1];
    hfLessonInfo.start = [NSNumber numberWithInt:1 + 1];
    hfLessonInfo.duration = [NSNumber numberWithInt:1];
    
    [controller.lessonInfos addObject:hfLessonInfo];
    
    return hfLessonInfo;
}

- (void)removeLessonInfo:(HFAddLessonViewController *)controller atIndex:(int)index{
    HFLessonInfo *hfLessonInfo = [controller.lessonInfos objectAtIndex:index];
    [controller.lessonInfos removeObjectAtIndex:index];
    [addingManagedObjectContext deleteObject:hfLessonInfo];
}

- (void)addControllerContextDidSave:(NSNotification*)saveNotification {
	
	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	// Merging changes causes the fetched results controller to update its results
	[context mergeChangesFromContextDidSaveNotification:saveNotification];	
}


#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
    
    [self setSearchingText:searchText];
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	for (HFLesson *hfLesson in listContent)
	{
        //		if ([scope isEqualToString:@"All"] || [hfLesson.type isEqualToString:scope])
		{
			NSComparisonResult result = [hfLesson.name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
			{
				[self.filteredListContent addObject:hfLesson];
            }
		}
	}
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
	// Create and configure a fetch request with the Book entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"HFLesson" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Create the sort descriptors array.
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSSortDescriptor *teacherDescriptor = [[NSSortDescriptor alloc] initWithKey:@"teacher" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, teacherDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"name" cacheName:@"LessonList"];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
	[nameDescriptor release];
	[teacherDescriptor release];
	[sortDescriptors release];
	
	return fetchedResultsController;
}

//NSFetchedResultsControllerDelegate
/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	switch (type) {
        case NSFetchedResultsChangeInsert:
        {
            HFLesson *lesson = (HFLesson *)anObject;
            
            // TODO: check!!
            //            if ([lessonsDictionary objectForKey:key]){
            //                NSLog(@"The class for key %d already exists.", [key intValue]);
            //            }
            [listContent addObject:lesson];
            break;
        }
        case NSFetchedResultsChangeMove:
        {
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            [listContent removeObject:anObject];
            break;
        }
        case NSFetchedResultsChangeUpdate:
        {
            // do nothing.
            break;
        }
        default:
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView reloadData];
	
}

#pragma mark -
#pragma mark Save and cancel operations

- (IBAction)cancel:(id)sender {
    // Don't pass current value to the edited object, just pop.
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    if (self.delegate) {
        [delegate finishedLessonInfos: nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
