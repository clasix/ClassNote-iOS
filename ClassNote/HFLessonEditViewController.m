//
//  HFLessonEditViewController.m
//  ClassNote
//
//  Created by XiaoYin Wang on 12-9-13.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import "HFLessonEditViewController.h"

@interface HFLessonEditViewController ()

@end

@implementation HFLessonEditViewController
@synthesize scrollView;
@synthesize nameLabel;
@synthesize bookLabel;
@synthesize teacherLabel;
@synthesize nameTextField;
@synthesize bookTextField;
@synthesize teacherTextField;
@synthesize hfLesson;
@synthesize editObject;
@synthesize activeField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Set the title to the user-visible name of the field.
	self.title = NSLocalizedString(@"lesson", @"");
    
    self.nameLabel.text = NSLocalizedString(@"lessonName", @"");
    self.bookLabel.text = NSLocalizedString(@"book", @"");
    self.teacherLabel.text = NSLocalizedString(@"teacher", @"");
    
	// Configure the save and cancel buttons.
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
    
    self.nameTextField.delegate = self;
    self.bookTextField.delegate = self;
    self.teacherTextField.delegate = self;
    
    [self.nameTextField setText:hfLesson.name];
    [self.bookTextField setText:hfLesson.book];
    [self.teacherTextField setText:hfLesson.teacher];
    
    [self registerForKeyboardNotifications];
}

#pragma mark -
#pragma mark Save and cancel operations

- (IBAction)save {
	
	// Set the action name for the undo operation.
	NSUndoManager * undoManager = [[editObject managedObjectContext] undoManager];
	[undoManager setActionName:[NSString stringWithFormat:@"%@", @"lesson"]];
	
    // Pass current value to the edited object, then pop.
    hfLesson.name = [nameTextField text];
    hfLesson.book = [bookTextField text];
    hfLesson.teacher = [teacherTextField text];
    
    // notify the fetchResultControler event, to setNeedDisPlay
    [editObject setValue:hfLesson forKey:@"lesson"];
	
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)cancel {
    // Don't pass current value to the edited object, just pop.
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [self setBookLabel:nil];
    [self setTeacherLabel:nil];
    [self setNameTextField:nil];
    [self setBookTextField:nil];
    [self setTeacherTextField:nil];
    [self setHfLesson:nil];
    [self setEditObject:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.nameTextField) {
        [theTextField resignFirstResponder];
        return NO;
    } else if (theTextField == self.bookTextField) {
        [theTextField resignFirstResponder];
        return NO;
    } else if (theTextField == self.teacherTextField) {
        [theTextField resignFirstResponder];
        return NO;
    }
    return YES;
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHidden:)
                                                 name:UIKeyboardDidHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
// FIXME: the teacherTextField will be hidden when the keyboard is for chinese.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    CGRect aRect = self.view.frame;
    
    NSDictionary* info = [aNotification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    
    CGSize kbSize = kbRect.size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    //CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y + activeField.frame.size.height - kbSize.height + 60); // 52 is the status bar'height plus the topbar's height
        // consider that when the keyboard is chinese keyboard, the height is higher, and will hidden the textfield, then the 60 plus is not accurate!
        [scrollView setContentOffset:scrollPoint animated:YES];
    }     
}

// Called when the UIKeyboardDidHideNotification is sent
- (void)keyboardWasHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)dealloc {
    [nameLabel release];
    [bookLabel release];
    [teacherLabel release];
    [nameTextField release];
    [bookTextField release];
    [teacherTextField release];
    [hfLesson release];
    [editObject release];
    [scrollView release];
    [super dealloc];
}
@end
