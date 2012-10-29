#import "DetailViewController.h"
#import "HFLessonItem.h"
#import "HFLesson.h"
#import "EditingViewController.h"
#import "HFLessonEditViewController.h"


@implementation DetailViewController

@synthesize hfLessonItem, undoManager;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Configure the title, title bar, and table view.
	self.title = NSLocalizedString(@"Class_Info", @"");
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.tableView.allowsSelectionDuringEditing = YES;
    
    daysInWeek = [[NSArray alloc] initWithObjects:
                  NSLocalizedString(@"Sunday", @""),
                  NSLocalizedString(@"Monday", @""),
                  NSLocalizedString(@"Tuesday", @""),
                  NSLocalizedString(@"Wednesday", @""),
                  NSLocalizedString(@"Thursday", @""),
                  NSLocalizedString(@"Friday", @""),
                  NSLocalizedString(@"Saturday", @""),
                  nil];
}


- (void)viewWillAppear:(BOOL)animated {
    // Redisplay the data.
    [self.tableView reloadData];
	[self updateRightBarButtonItemState];
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
	
	// Hide the back button when editing starts, and show it again when editing finishes.
    [self.navigationItem setHidesBackButton:editing animated:animated];
    [self.tableView reloadData];
	
	/*
	 When editing starts, create and set an undo manager to track edits. Then register as an observer of undo manager change notifications, so that if an undo or redo operation is performed, the table view can be reloaded.
	 When editing ends, de-register from the notification center and remove the undo manager, and save the changes.
	 */
	if (editing) {
		[self setUpUndoManager];
	}
	else {
		[self cleanUpUndoManager];
		// Save the changes.
		NSError *error;
		if (![hfLessonItem.managedObjectContext save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
	}
}


- (void)viewDidUnload {
	// Release any properties that are loaded in viewDidLoad or can be recreated lazily.
}


- (void)updateRightBarButtonItemState {
	// Conditionally enable the right bar button item -- it should only be enabled if the book is in a valid state for saving.
    self.navigationItem.rightBarButtonItem.enabled = [hfLessonItem validateForUpdate:NULL];
}

//
// 强制横屏
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 1 section
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 5 rows
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
		cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	switch (indexPath.row) {
        case 0: 
			cell.textLabel.text = NSLocalizedString(@"lesson", @"");
			cell.detailTextLabel.text = hfLessonItem.lesson.name;
			break;
        case 1: 
			cell.textLabel.text = NSLocalizedString(@"classRoom", @"");
			cell.detailTextLabel.text = hfLessonItem.room;
			break;
        case 2:
			cell.textLabel.text = NSLocalizedString(@"dayInWeek", @"");
			cell.detailTextLabel.text = [daysInWeek objectAtIndex:[hfLessonItem.dayinweek intValue]];
			break;
        case 3:
			cell.textLabel.text = NSLocalizedString(@"start", @"");
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [hfLessonItem.start intValue]];
			break;
        case 4:
			cell.textLabel.text = NSLocalizedString(@"duration", @"");
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [hfLessonItem.duration intValue]];
			break;
    }
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Only allow selection if editing.
    return (self.editing) ? indexPath : nil;
}

/**
 Manage row selection: If a row is selected, create a new editing view controller to edit the property associated with the selected row.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (!self.editing) return;
	
    switch (indexPath.row) {
        case 0: {
            HFLessonEditViewController *controller = [[HFLessonEditViewController alloc] init];
            controller.editObject = hfLessonItem;
            controller.hfLesson = hfLessonItem.lesson;
            
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        } break;
        case 1: {
            EditingViewController *controller = [[EditingViewController alloc] initWithNibName:@"EditingView" bundle:nil];
            controller.editedObject = hfLessonItem;
            
            controller.editedFieldKey = @"room";
			controller.editedFieldName = NSLocalizedString(@"classRoom", @"display name for room");
			controller.editingNumber = NO;
            
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        } break;
        case 2: {
            EditingViewController *controller = [[EditingViewController alloc] initWithNibName:@"EditingView" bundle:nil];
            controller.editedObject = hfLessonItem;
            
            controller.editedFieldKey = @"dayinweek";
			controller.editedFieldName = NSLocalizedString(@"dayInWeek", @"display name for dayinweek");
			controller.editingNumber = YES;
            controller.pickerType = TYPE_DAY_IN_WEEK;
            
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        } break;
        case 3: {
            EditingViewController *controller = [[EditingViewController alloc] initWithNibName:@"EditingView" bundle:nil];
            controller.editedObject = hfLessonItem;
            
            controller.editedFieldKey = @"start";
			controller.editedFieldName = NSLocalizedString(@"start", @"display name for start");
			controller.editingNumber = YES;
            controller.pickerType = TYPE_START;
            
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        } break;
        case 4: {
            EditingViewController *controller = [[EditingViewController alloc] initWithNibName:@"EditingView" bundle:nil];
            controller.editedObject = hfLessonItem;
            
            controller.editedFieldKey = @"duration";
			controller.editedFieldName = NSLocalizedString(@"duration", @"display name for end");
			controller.editingNumber = YES;
            controller.pickerType = TYPE_END;
            
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        } break;
    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}


#pragma mark -
#pragma mark Undo support

- (void)setUpUndoManager {
	/*
	 If the book's managed object context doesn't already have an undo manager, then create one and set it for the context and self.
	 The view controller needs to keep a reference to the undo manager it creates so that it can determine whether to remove the undo manager when editing finishes.
	 */
	if (hfLessonItem.managedObjectContext.undoManager == nil) {
		
		NSUndoManager *anUndoManager = [[NSUndoManager alloc] init];
		[anUndoManager setLevelsOfUndo:3];
		self.undoManager = anUndoManager;
		[anUndoManager release];
		
		hfLessonItem.managedObjectContext.undoManager = undoManager;
	}
	
	// Register as an observer of the book's context's undo manager.
	NSUndoManager *bookUndoManager = hfLessonItem.managedObjectContext.undoManager;
	
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc addObserver:self selector:@selector(undoManagerDidUndo:) name:NSUndoManagerDidUndoChangeNotification object:bookUndoManager];
	[dnc addObserver:self selector:@selector(undoManagerDidRedo:) name:NSUndoManagerDidRedoChangeNotification object:bookUndoManager];
}


- (void)cleanUpUndoManager {
	
	// Remove self as an observer.
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	if (hfLessonItem.managedObjectContext.undoManager == undoManager) {
		hfLessonItem.managedObjectContext.undoManager = nil;
		self.undoManager = nil;
	}		
}


- (NSUndoManager *)undoManager {
	return hfLessonItem.managedObjectContext.undoManager;
}


- (void)undoManagerDidUndo:(NSNotification *)notification {
	[self.tableView reloadData];
	[self updateRightBarButtonItemState];
}


- (void)undoManagerDidRedo:(NSNotification *)notification {
	[self.tableView reloadData];
	[self updateRightBarButtonItemState];
}


/*
 The view controller must be first responder in order to be able to receive shake events for undo. It should resign first responder status when it disappears.
 */
- (BOOL)canBecomeFirstResponder {
	return YES;
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self becomeFirstResponder];
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self resignFirstResponder];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [undoManager release];
    [hfLessonItem release];
    [daysInWeek release];
    [super dealloc];
}

@end

