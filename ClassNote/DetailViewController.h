

@class HFLessonInfo, EditingViewController;

@interface DetailViewController : UITableViewController {
    HFLessonInfo *hfLessonInfo;
	NSUndoManager *undoManager;
    NSArray * daysInWeek;
}

@property (nonatomic, retain) HFLessonInfo *hfLessonInfo;
@property (nonatomic, retain) NSUndoManager *undoManager;

- (void)setUpUndoManager;
- (void)cleanUpUndoManager;
- (void)updateRightBarButtonItemState;

@end

