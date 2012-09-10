

@class HFClass, EditingViewController;

@interface DetailViewController : UITableViewController {
    HFClass *hfClass;
	NSUndoManager *undoManager;
    NSArray * daysInWeek;
}

@property (nonatomic, retain) HFClass *hfClass;
@property (nonatomic, retain) NSUndoManager *undoManager;

- (void)setUpUndoManager;
- (void)cleanUpUndoManager;
- (void)updateRightBarButtonItemState;

@end

