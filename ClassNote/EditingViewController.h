static const int TYPE_DAY_IN_WEEK = 0;
static const int TYPE_START = 2;
static const int TYPE_END = 3;
@interface EditingViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate> {
	
	UITextField *textField;

    NSManagedObject *editedObject;
    NSString *editedFieldKey;
    NSString *editedFieldName;
	
    BOOL editingNumber;
    UIPickerView *picker;
    
    int pickerType;
    
    NSArray * daysInWeek;
}

@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (retain, nonatomic) IBOutlet UIPickerView *picker;

@property (nonatomic, retain) NSManagedObject *editedObject;
@property (nonatomic, retain) NSString *editedFieldKey;
@property (nonatomic, retain) NSString *editedFieldName;

@property (nonatomic, assign, getter=isEditingNumber) BOOL editingNumber;
@property (nonatomic, assign) int pickerType;

- (IBAction)cancel;
- (IBAction)save;

@end

