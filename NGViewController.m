//
//  NGViewController.m
//  NGVaryingGridViewDemo
//
//  Created by Philip Messlehner on 19.04.12.
//  Copyright (c) 2012 NOUS Wissensmanagement GmbH. All rights reserved.
//

#import "NGViewController.h"
#import "NGVaryingGridView.h"
#import "NGClassCell.h"
#import "HFLessonInfo.h"
#import "HFRemoteUtils.h"
#import "HFExceptionHandler.h"
#import "HFUtils.h"
#import "HFLessonTableItem.h"
#import "HFLessonListViewController.h"


#define kColumnWidth    ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 120.f : 60.f)
#define kRightPadding   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 91.f : 46.f)
#define kContentHeight  ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 750.f : 420.f)

#define dayLineLeft  600.f
#define timeLineTop 600.f
#define margin  0.f
#define dayLineHeight (kContentHeight/15.0)
#define cellLineHeight (kContentHeight/15.0)

@interface NGViewController () <NGVaryingGridViewDelegate>

@property (nonatomic, strong) NGVaryingGridView *gridView;

@end

@implementation NGViewController

@synthesize gridView = _gridView;
@synthesize editLabel = _editLabel;
@synthesize deleteButton = _deleteButton;

@synthesize managedObjectContext, addingManagedObjectContext ,lessonItemsArray, fetchedResultsController;

////////////////////////////////////////////////////////////////////////
#pragma mark - Life Cycle
////////////////////////////////////////////////////////////////////////

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        weekdays = [[NSArray alloc] initWithObjects:
                    NSLocalizedString(@"Sunday", @""),
                    NSLocalizedString(@"Monday", @""),
                    NSLocalizedString(@"Tuesday", @""),
                    NSLocalizedString(@"Wednesday", @""),
                    NSLocalizedString(@"Thursday", @""),
                    NSLocalizedString(@"Friday", @""),
                    NSLocalizedString(@"Saturday", @""),
                    nil];
    }
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"lesson_table_id"]) {
        lesson_table_id = [HFUtils getLessonTableID];
    } else {
        NSArray * lesson_tables;
        NSString *auth_token = [HFUtils getAuthToken];
        @try {
            lesson_tables = [[[HFRemoteUtils instance] server] get_lessontables:auth_token];
        }
        @catch (NSException *exception) {
            [HFExceptionHandler handleException:exception];
        }
        @finally {
            
        }
        if ([lesson_tables count] == 0) {
            // TODO: 返回值应该改成int型
            BOOL ret = [[[HFRemoteUtils instance] server] create_lessontable:auth_token];
            if (ret) {
                NSArray * lesson_tables = [[[HFRemoteUtils instance] server] get_lessontables:auth_token];
                lesson_table_id = [(LessonTable *)[lesson_tables objectAtIndex:0] gid];
                [HFUtils setLessonTableID:lesson_table_id];
            } else {
                [HFExceptionHandler networkAlert];
            }
        } else {
            lesson_table_id = [(LessonTable *)[lesson_tables objectAtIndex:0] gid];
            [HFUtils setLessonTableID:lesson_table_id];
        }
    }
    
//    NSString *auth_token = [HFUtils getAuthToken];
//    NSArray *provinces = [[[HFRemoteUtils instance] server] dept_provinces:auth_token];
//    NSLog(@"provinces[0] is %@", [provinces objectAtIndex:0]);
    
    return self;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController
////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                                                               target:self action:@selector(addLesson)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
    
    //
    self.title = NSLocalizedString(@"ClassNote", @"");
	
    self.gridView = [[NGVaryingGridView alloc] initWithFrame:self.view.bounds];
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.gridView.gridViewDelegate = self;
    [self.view addSubview:self.gridView];
    
    //
    UIView *timeLine = [[UIView alloc] initWithFrame:CGRectMake(-1.f, - timeLineTop, kRightPadding + 1.f, kContentHeight + timeLineTop * 2)];
    CALayer *layer = timeLine.layer;
	layer.masksToBounds = NO;
	layer.borderWidth = 1.f;
	layer.borderColor = [[UIColor blackColor] CGColor];
	layer.shadowOffset = CGSizeMake(5.f, 0.f);
	layer.shadowRadius = 5.f;
	layer.shadowOpacity = 0.5f;
    
    timeLine.backgroundColor = [UIColor grayColor];
    for (int i = 0; i < 12; i++) {
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, timeLineTop + dayLineHeight + cellLineHeight * i, timeLine.frame.size.width, cellLineHeight)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.textAlignment = UITextAlignmentCenter;
        timeLabel.text = [NSString stringWithFormat:@"%d", i+1];
        timeLabel.font = [UIFont boldSystemFontOfSize:12.f];
        timeLabel.shadowColor = [UIColor darkGrayColor];
        timeLabel.shadowOffset = CGSizeMake(1.f, 1.f);
        [timeLine addSubview:timeLabel];
    }
    
    //
    UIView *dayLine = [[UIView alloc] initWithFrame:CGRectMake(-dayLineLeft, -1.f, kRightPadding + kColumnWidth * [weekdays count] + dayLineLeft * 2, dayLineHeight)];
    dayLine.backgroundColor = [UIColor grayColor];
    layer = dayLine.layer;
	layer.masksToBounds = NO;
	layer.borderWidth = 1.f;
	layer.borderColor = [[UIColor blackColor] CGColor];
	layer.shadowOffset = CGSizeMake(5.f, 0.f);
	layer.shadowRadius = 5.f;
	layer.shadowOpacity = 0.5f;
    
    for (int i = 0; i < [weekdays count]; i++) {
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * kColumnWidth + timeLine.frame.size.width + dayLineLeft, 0.f, kColumnWidth, dayLine.frame.size.height)];
        dayLabel.backgroundColor = [UIColor clearColor];
        dayLabel.textColor = [UIColor whiteColor];
        dayLabel.textAlignment = UITextAlignmentCenter;
        dayLabel.text = [weekdays objectAtIndex:i];
        dayLabel.font = [UIFont boldSystemFontOfSize:12.f];
        dayLabel.shadowColor = [UIColor darkGrayColor];
        dayLabel.shadowOffset = CGSizeMake(1.f, 1.f);
        [dayLine addSubview:dayLabel];
    }
    
    UILabel *editLine = [[UILabel alloc] initWithFrame:CGRectMake(-dayLineLeft, self.gridView.bounds.size.height - dayLineHeight * 2, kRightPadding + kColumnWidth * [weekdays count] + dayLineLeft * 2, dayLineHeight * 2)];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    deleteButton.frame = CGRectMake(dayLineLeft + kRightPadding + kColumnWidth * 6, dayLineHeight * 0.5f, kColumnWidth, dayLineHeight);
    [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    [deleteButton setBackgroundColor:[UIColor clearColor]];
    [deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [deleteButton addTarget:self action:@selector(deleteClass) forControlEvents:UIControlEventTouchDown];
    [editLine addSubview:deleteButton];
    self.deleteButton = deleteButton;
    self.deleteButton.hidden = YES;
    //editLine.backgroundColor = [UIColor grayColor];
    editLine.textAlignment = UITextAlignmentCenter;
    editLine.font = [UIFont systemFontOfSize:14.f];
    layer = editLine.layer;
	layer.masksToBounds = NO;
	layer.borderWidth = 1.f;
	layer.borderColor = [[UIColor blackColor] CGColor];
	layer.shadowOffset = CGSizeMake(5.f, 0.f);
	layer.shadowRadius = 5.f;
	layer.shadowOpacity = 0.5f;
    
    editLine.userInteractionEnabled = YES;
    
    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *singleFingerTap = 
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(editLesson:)];
    [editLine addGestureRecognizer:singleFingerTap];
    [singleFingerTap release];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressedOnEditLine:)];
    [editLine addGestureRecognizer:longPress];
    longPress.allowableMovement = NO;
    longPress.minimumPressDuration = 0.5;
    [longPress release];
    
//    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(detectSwipe:)];
//    [swipeGesture setNumberOfTouchesRequired:1];
//    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight];
//    [editLine addGestureRecognizer:swipeGesture];
//    [swipeGesture release];
    
    self.editLabel = editLine;
    [editLine release];
    
    [self.gridView setStickyView:editLine lockPosition:NGVaryingGridViewLockPositionBottom];
    [self.gridView setStickyView:dayLine lockPosition:NGVaryingGridViewLockPositionTop];
    [self.gridView setStickyView:timeLine lockPosition:NGVaryingGridViewLockPositionLeft];
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    NSArray *fetchedObjects = fetchedResultsController.fetchedObjects;
    
    //http://www.raywenderlich.com/934/core-data-on-ios-5-tutorial-getting-started
    
    self.lessonItemsArray = [NSMutableArray arrayWithArray:fetchedObjects];
    
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillResignActive:)
     name:UIApplicationWillResignActiveNotification
     object:app];
    
    // ScrollView的视图包括左轴和上轴
    [self.gridView setMinScrollX:kRightPadding + kColumnWidth * [weekdays count]];
    [self.gridView setMinScrollY:kContentHeight];
    
    [self.gridView reloadData];
}

- (void)addLesson {
    HFLessonListViewController * lessonListViewController = [[HFLessonListViewController alloc] initWithNibName:@"HFLessonListViewController" bundle:nil];

    lessonListViewController.viewType = TYPE_SELECT_LESSONS;
    lessonListViewController.delegate = self;
    
    lessonListViewController.managedObjectContext = managedObjectContext;
	
    [self.navigationController pushViewController:lessonListViewController animated:YES];
}

//The event handling method
- (void)editLesson:(UITapGestureRecognizer *)recognizer {
    if (selectedIndex < [lessonItemsArray count] && self.deleteButton.hidden == YES) {
        // Create and push a detail view controller.
        DetailViewController *detailViewController = [[DetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
        HFLessonTableItem * hfLessonItem = [lessonItemsArray objectAtIndex:selectedIndex];
        
        // Pass the selected book to the new view controller.
        detailViewController.hfLessonInfo = hfLessonItem.lessonInfo;
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
}

-(void)longPressedOnEditLine:(id)sender{
    
    if ([(UILongPressGestureRecognizer *)sender state] == UIGestureRecognizerStateBegan) {
        if (self.deleteButton.hidden) {
            self.deleteButton.hidden = NO;
        } else {
            self.deleteButton.hidden = YES;
        }
    }
}

/*
-(void)detectSwipe:(UISwipeGestureRecognizer *)recognizer {
    if (selectedIndex < [classesArray count]) {
        if (self.deleteButton.hidden) {
            self.deleteButton.hidden = NO;
        } else {
            self.deleteButton.hidden = YES;
        }
//        switch (recognizer.direction) {
//            case UISwipeGestureRecognizerDirectionLeft:
//                self.deleteButton.hidden = YES;
//                break;
//                
//                
//            case UISwipeGestureRecognizerDirectionDown:
//                self.deleteButton.hidden = NO;
//            default:
//                break;
//        }
    }
}
 */

- (void) deleteClass {
    if (selectedIndex < [lessonItemsArray count]) {
        HFLessonTableItem * hfLessonItem = [lessonItemsArray objectAtIndex:selectedIndex];
        
        NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:hfLessonItem];
		
		NSError *error;
		if (![context save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.gridView.gridViewDelegate = nil;
    self.gridView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - NGVaryingGridViewDelegate
////////////////////////////////////////////////////////////////////////

- (NSArray *)rectsForCellsInGridView:(NGVaryingGridView *)gridView {
    NSMutableArray *rectsArray = [NSMutableArray array];
    
    NSMutableSet *classIndexSet = [NSMutableSet setWithCapacity:(DAYS_IN_WEEK * CLASSES_IN_DAY)];
    for (int i = 0; i < DAYS_IN_WEEK * CLASSES_IN_DAY; i ++) {
        [classIndexSet addObject:[NSNumber numberWithInt:i]];
    }
    
    for (HFLessonTableItem *lessonItem in lessonItemsArray) {
        [rectsArray addObject:[NSValue valueWithCGRect:CGRectMake(kRightPadding + margin + [lessonItem.lessonInfo.dayinweek intValue] * kColumnWidth, dayLineHeight + ([lessonItem.lessonInfo.start intValue] - 1) * cellLineHeight + margin, kColumnWidth - margin * 2, ([lessonItem.lessonInfo.duration intValue]) * cellLineHeight - margin * 2)]];
        
        for (int k = [lessonItem.lessonInfo.start intValue]; k < ([lessonItem.lessonInfo.start intValue] + [lessonItem.lessonInfo.duration intValue]); k ++) {
            [classIndexSet removeObject:[NSNumber numberWithInt:([lessonItem.lessonInfo.dayinweek intValue] * CLASSES_IN_DAY + k - 1)]];
        }
    }
    
    for (NSNumber *num in classIndexSet) {
        [rectsArray addObject:[NSValue valueWithCGRect:CGRectMake(kRightPadding + margin + ([num intValue]/CLASSES_IN_DAY) * kColumnWidth, dayLineHeight + ([num intValue]%CLASSES_IN_DAY) * cellLineHeight + margin, kColumnWidth - margin * 2, 1 * cellLineHeight - margin * 2)]];
    }

    return rectsArray;
}

- (UIView *)gridView:(NGVaryingGridView *)gridView viewForCellWithRect:(CGRect)rect index:(NSUInteger)index {
    
    if (index < [lessonItemsArray count]) {
        NGClassCell *cell = (NGClassCell *) ([gridView dequeueReusableCellWithFrame:rect] ?: [[NGClassCell alloc] initWithFrame:rect]);
        
        // TODO
        HFLessonTableItem *lessonItem = [lessonItemsArray objectAtIndex:index];
        cell.text = lessonItem.lessonInfo.lesson.name;
        cell.column = [lessonItem.lessonInfo.dayinweek intValue];
        cell.row = [lessonItem.lessonInfo.start intValue] - 1;
        cell.index = index;
        
        if (cell.column == selectedColumn && cell.row == selectedRow) {
            cell.backgroundColor = [UIColor redColor];
            [self.editLabel setText:[NSString stringWithFormat:@"Class's lesson is: %@, class room is:%@", lessonItem.lessonInfo.lesson.name, lessonItem.lessonInfo.room]];
            //[self.editLabel setBackgroundColor:[UIColor redColor]];
            selectedIndex = index;
            [self updateButtonState:index];
        } else {
            cell.backgroundColor = [UIColor whiteColor];
        }
        return cell;
    } else {
        NGClassCell *cell = [[NGClassCell alloc] initWithFrame:rect];
        cell.text = @"";
        cell.column = (rect.origin.x - kRightPadding - margin + 0.9f) / kColumnWidth;
        cell.row = (rect.origin.y - dayLineHeight - margin + 0.9f) / cellLineHeight;
        
        if (cell.column == selectedColumn && cell.row == selectedRow) {
            cell.backgroundColor = [UIColor redColor];
            [self.editLabel setText:@"No Class"];
            selectedIndex = index;
            [self updateButtonState:index];
        } else {
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        cell.index = index;
        
        return cell;
    }
}

- (void)gridView:(NGVaryingGridView *)gridView didSelectCell:(UIView *)cell index:(NSUInteger)index {
    NGClassCell * classCell = (NGClassCell *)cell;
    
    selectedIndex = classCell.index;
    
    selectedColumn = classCell.column;
    selectedRow = classCell.row;
    
    self.deleteButton.hidden = YES;
    
    [self updateButtonState:index];
    
    [self.gridView reloadData];
}

-(void) updateButtonState: (NSInteger) index {
    // disable addButton when there already exists class
    if (index < [lessonItemsArray count]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)gridView:(NGVaryingGridView *)gridView willPrepareCellForReuse:(UIView *)cell {
    
}

- (void)finishedLessonInfos:(NSSet *)lessonInfos {
	// Create a new managed object context for the new book -- set its persistent store coordinator to the same as that from the fetched results controller's context.
//	NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
//	self.addingManagedObjectContext = addingContext;
//	[addingContext release];
//	
//	[addingManagedObjectContext setPersistentStoreCoordinator:[[fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
    
    for(HFLessonInfo * hfLessonInfo in lessonInfos) {
        HFLessonTableItem *hfLessonTableItem = (HFLessonTableItem *)[NSEntityDescription insertNewObjectForEntityForName:@"HFLessonTableItem" inManagedObjectContext:hfLessonInfo.managedObjectContext];
        hfLessonTableItem.tableId = [NSNumber numberWithInt:lesson_table_id];
        hfLessonTableItem.lessonInfo = hfLessonInfo;
        
        NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
        [dnc addObserver:self selector:@selector(addControllerContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:hfLessonInfo.managedObjectContext];
        
        // Create and configure a new instance of the Event entity.
        NSError *error;
        if (![hfLessonInfo.managedObjectContext save:&error]) {
            // Update to handle the error appropriately.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            exit(-1);  // Fail
        }
        
        [dnc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:hfLessonInfo.managedObjectContext];
    }
    
//    self.addingManagedObjectContext = nil;
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)addControllerContextDidSave:(NSNotification*)saveNotification {
	
	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	// Merging changes causes the fetched results controller to update its results
	[context mergeChangesFromContextDidSaveNotification:saveNotification];	
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
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"HFLessonTableItem" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tableId" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [sortDescriptors release];
    [sortDescriptor release];
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root1"];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
	
	return fetchedResultsController;
}

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
            HFLessonTableItem *lessonItem = (HFLessonTableItem *)anObject;

            // TODO: check!!
//            if ([lessonsDictionary objectForKey:key]){
//                NSLog(@"The class for key %d already exists.", [key intValue]);
//            }
            [lessonItemsArray addObject:lessonItem];
            break;
        }
        case NSFetchedResultsChangeMove:
        {
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            [lessonItemsArray removeObject:anObject];
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
    self.deleteButton.hidden = YES;
    [self.gridView reloadData];
    [self.gridView setNeedsDisplay];
	
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    // The application is about to become inactive.
}

- (void)dealloc {
    [_editLabel release];
    [lessonItemsArray release];
    [weekdays release];
    [managedObjectContext release];
    [addingManagedObjectContext release];
    [fetchedResultsController release];
    [super dealloc];
}

@end
