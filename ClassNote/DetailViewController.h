

@class HFLessonItem, EditingViewController;

@interface DetailViewController : UITableViewController {
    HFLessonItem *hfLessonItem;
	NSUndoManager *undoManager;
    NSArray * daysInWeek;
}

@property (nonatomic, retain) HFLessonItem *hfLessonItem;
@property (nonatomic, retain) NSUndoManager *undoManager;

- (void)setUpUndoManager;
- (void)cleanUpUndoManager;
- (void)updateRightBarButtonItemState;

@end

