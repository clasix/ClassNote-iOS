#import "EditingViewController.h"

@implementation EditingViewController
@synthesize picker;
@synthesize pickerType;

@synthesize textField, editedObject, editedFieldKey, editedFieldName, editingNumber;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    // default, will be overwrite
    daysInWeek = [[NSArray alloc] initWithObjects:
                  NSLocalizedString(@"Sunday", @""),
                  NSLocalizedString(@"Monday", @""),
                  NSLocalizedString(@"Tuesday", @""),
                  NSLocalizedString(@"Wednesday", @""),
                  NSLocalizedString(@"Thursday", @""),
                  NSLocalizedString(@"Friday", @""),
                  NSLocalizedString(@"Saturday", @""),
                  nil];
    
    return self;
}

#pragma mark -
#pragma mark View lifecycle
// FIXME: 结束课的时间不能早于开始时间，否则会出现Conflict(冲突)
// 如果出现Conflict，则应该标明，参照日历的做法。
- (void)viewDidLoad {
	// Set the title to the user-visible name of the field.
	self.title = editedFieldName;

	// Configure the save and cancel buttons.
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
    
    picker.delegate = self;
}


- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	// Configure the user interface according to state.
    if (editingNumber) {
        textField.hidden = YES;
        picker.hidden = NO;
		NSNumber *number = [editedObject valueForKey:editedFieldKey];
        if (number == nil) number = [NSNumber numberWithInt:0];
        [picker selectRow:[number intValue] inComponent:0 animated:false];
    }
	else {
        textField.hidden = NO;
        picker.hidden = YES;
        textField.text = [editedObject valueForKey:editedFieldKey];
		textField.placeholder = self.title;
        [textField becomeFirstResponder];
    }
}

//
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


#pragma mark -
#pragma mark Save and cancel operations

- (IBAction)save {
	
	// Set the action name for the undo operation.
	NSUndoManager * undoManager = [[editedObject managedObjectContext] undoManager];
	[undoManager setActionName:[NSString stringWithFormat:@"%@", editedFieldName]];
	
    // Pass current value to the edited object, then pop.
    if (editingNumber) {
        [editedObject setValue:[NSNumber numberWithInt:[picker selectedRowInComponent:0]] forKey:editedFieldKey];
    }
	else {
        [editedObject setValue:textField.text forKey:editedFieldKey];
    }
	
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)cancel {
    // Don't pass current value to the edited object, just pop.
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
// TODO: 分成3栏， 星期几， 开始节，结束节
// UIPickerViewDataSouce
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == TYPE_DAY_IN_WEEK) {
        return 7;
    } else {
        return 12;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //NSLog(@"component is %d", component);
    if ( pickerType == TYPE_DAY_IN_WEEK) {
        return [daysInWeek objectAtIndex:row];
    } else {
        return [NSString stringWithFormat:@"%d", row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
   // do nothing.
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [textField release];
    [editedObject release];
    [editedFieldKey release];
    [editedFieldName release];
    [picker release];
    [daysInWeek release];
	[super dealloc];
}


- (void)viewDidUnload {
    [self setPicker:nil];
    [super viewDidUnload];
}
@end

