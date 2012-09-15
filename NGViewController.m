//
//  NGViewController.m
//  NGVaryingGridViewDemo
//
//  Created by Philip Messlehner on 19.04.12.
//  Copyright (c) 2012 NOUS Wissensmanagement GmbH. All rights reserved.
//

#import "NGViewController.h"
#import "NGVaryingGridView.h"
#import "NGTimeTableCell.h"
#import "HFClass.h"


#define kColumnWidth    ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 120.f : 60.f)
#define kRightPadding   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 91.f : 46.f)
#define kContentHeight  ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 800.f : 400.f)

#define dayLineLeft  600.f
#define timeLineTop 600.f
#define margin  0.f
#define dayLineHeight (kContentHeight/16.0)
#define cellLineHeight (kContentHeight/16.0)

@interface NGViewController () <NGVaryingGridViewDelegate>

@property (nonatomic, strong) NGVaryingGridView *gridView;

@end

@implementation NGViewController

@synthesize gridView = _gridView;

@synthesize managedObjectContext, addingManagedObjectContext ,classesArray, fetchedResultsController;

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
    
    return self;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController
////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	
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
    
    CGRect kbRect = [self.view convertRect:self.gridView.frame fromView:nil];
    
    UIView *wholeDayEvent = [[UIView alloc] initWithFrame:CGRectMake(0, cellLineHeight, kRightPadding + kColumnWidth * [weekdays count] + dayLineLeft * 2, cellLineHeight * 2 - margin * 2)];
    wholeDayEvent.backgroundColor = [UIColor blueColor];
    //wholeDayEvent.text = @"Vacation";
    [dayLine addSubview:wholeDayEvent];
    
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
    
    self.classesArray = [NSMutableArray arrayWithArray:fetchedObjects];
    
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
    
    for (HFClass *class in classesArray) {
        [rectsArray addObject:[NSValue valueWithCGRect:CGRectMake(kRightPadding + margin + [class.dayinweek intValue] * kColumnWidth, dayLineHeight + [class.start intValue] * cellLineHeight + margin, kColumnWidth - margin * 2, ([class.end intValue] - [class.start intValue]) * cellLineHeight - margin * 2)]];
    }

    return rectsArray;
}

- (UIView *)gridView:(NGVaryingGridView *)gridView viewForCellWithRect:(CGRect)rect index:(NSUInteger)index {
    NGTimeTableCell *cell = (NGTimeTableCell *) ([gridView dequeueReusableCellWithFrame:rect] ?: [[NGTimeTableCell alloc] initWithFrame:rect]);
    
    // TODO
    HFClass *hfClass = [classesArray objectAtIndex:index];
    cell.text = hfClass.lesson.name;
    return cell;
}

- (void)gridView:(NGVaryingGridView *)gridView didSelectCell:(UIView *)cell index:(NSUInteger)index {
    NSLog(@"You selected a cell!");
}

- (void)gridView:(NGVaryingGridView *)gridView willPrepareCellForReuse:(UIView *)cell {
    
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
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"HFClass" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Create the sort descriptors array.
	NSSortDescriptor *dayinweekDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dayinweek" ascending:YES];
	NSSortDescriptor *startDescriptor = [[NSSortDescriptor alloc] initWithKey:@"start" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:dayinweekDescriptor, startDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"dayinweek" cacheName:@"Root"];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
	[dayinweekDescriptor release];
	[startDescriptor release];
	[sortDescriptors release];
	
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
            HFClass *class = (HFClass *)anObject;

            // TODO: check!!
//            if ([lessonsDictionary objectForKey:key]){
//                NSLog(@"The class for key %d already exists.", [key intValue]);
//            }
            [classesArray addObject:class];
            break;
        }
        case NSFetchedResultsChangeMove:
        {
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            [classesArray removeObject:anObject];
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
    [self.gridView setNeedsDisplay];
	
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    // The application is about to become inactive.
}

- (void)dealloc {
    [classesArray release];
    [weekdays release];
    [managedObjectContext release];
    [addingManagedObjectContext release];
    [fetchedResultsController release];
    [super dealloc];
}

@end
