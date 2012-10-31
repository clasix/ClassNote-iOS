//
//  HFAddLessonViewController.m
//  ClassNote
//
//  Created by XiaoYin Wang on 12-10-29.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import "HFAddLessonViewController.h"
#import "HFLessonInfo.h"
#import "HFLessonCell.h"

@interface HFAddLessonViewController ()

@end

@implementation HFAddLessonViewController
@synthesize doneToolbar;
@synthesize selectPicker;

@synthesize lessonInfos, lesson;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        WEEKDAYS = [[NSArray alloc] initWithObjects:
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // Custom initialization
        WEEKDAYS = [[NSArray alloc] initWithObjects:
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.lessonInfos) {
        self.lessonInfos = [NSMutableArray arrayWithCapacity:2];
    }
    
    self.tableView.editing = YES;
    
    self.tableView.allowsSelectionDuringEditing = YES;
    
    self.title = @"添加课程";
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                                                           target:self action:@selector(cancel:)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                                                                            target:self action:@selector(save:)] autorelease];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    selectPicker.delegate = self;
    selectPicker.dataSource = self;
    selectPicker.frame = CGRectMake(0, 480, 320, 216);
    [self.tableView addSubview:selectPicker];
}

- (void)viewDidUnload
{
    [self setDoneToolbar:nil];
    [self setSelectPicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
	[lessonInfos release];
	[lesson release];
	
    [doneToolbar release];
    [selectPicker release];
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2 + [self.lessonInfos count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else if (section == [self.lessonInfos count] + 1) {
        return 1;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *LessonCellIdentifier = @"LessonCell";
        
        HFLessonCell *cell = [tableView dequeueReusableCellWithIdentifier:LessonCellIdentifier];
        
        if (cell == nil) {
            // Create a cell to display an ingredient.
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HFLessonCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];  
            
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        if (indexPath.row == 0) {
            cell.iconImage.image = [UIImage imageNamed:@"people_.png"];
            cell.textField.text = [[self lesson] name];
            cell.textField.delegate = self;
            cell.textField.tag = 1;
        } else if (indexPath.row == 1) {
            cell.iconImage.image = [UIImage imageNamed:@"people_.png"];
            cell.textField.text = [[self lesson] teacher];
            cell.textField.placeholder = @"请输入老师姓名";
            cell.textField.delegate = self;
            cell.textField.tag = 2;
        } else {
            cell.iconImage.image = [UIImage imageNamed:@"people_.png"];
            cell.textField.text = [[self lesson] book];
            cell.textField.placeholder = @"请输入课本";
            cell.textField.delegate = self;
            cell.textField.tag = 3;
        }
        
        return cell;
    } else if (indexPath.section == [lessonInfos count] + 1) {
        static NSString *LessonCellIdentifier = @"LessonInfoAddCell";
        
        HFLessonCell *cell = [tableView dequeueReusableCellWithIdentifier:LessonCellIdentifier];
        
        if (cell == nil) {
            // Create a cell to display an ingredient.
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HFLessonCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];  
            
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.iconImage.image = [UIImage imageNamed:@"people_.png"];
        cell.textField.text = @"点击添加课程时间";
        cell.textField.enabled = false;
        cell.textField.tag = 4;
        
        return cell;
    } else {
        static NSString *LessonCellIdentifier = @"LessonInfoCell";
        
        HFLessonCell *cell = [tableView dequeueReusableCellWithIdentifier:LessonCellIdentifier];
        
        if (cell == nil) {
            // Create a cell to display an ingredient.
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HFLessonCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];  
            
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        HFLessonInfo *lessonInfo = [lessonInfos objectAtIndex:(indexPath.section - 1)];
        if (indexPath.row == 0) {
            cell.iconImage.image = [UIImage imageNamed:@"people_.png"];
            cell.textField.text = [self timeDescription:lessonInfo];
            cell.textField.delegate = self;
            cell.textField.inputView = selectPicker;
            cell.textField.inputAccessoryView = doneToolbar;
            cell.textField.tag = 3 + indexPath.section * 2;
        } else {
            cell.iconImage.image = [UIImage imageNamed:@"people_.png"];
            cell.textField.text = [lessonInfo room];
            cell.textField.placeholder = @"请输入教室";
            
            cell.textField.delegate = self;
            cell.textField.tag = 4 + indexPath.section * 2;
        }
        
        return cell;
    }
}

- (NSString *) timeDescription: (HFLessonInfo*) hfLessonInfo{
//    NSLog(@"%@", [hfLessonInfo duration]);
    // TODO: FIXME: 当添加LessonInfo的时候出错
    if ([hfLessonInfo.duration intValue] == 1) {
        return [NSString stringWithFormat:@"%@ %@%@%@", [WEEKDAYS objectAtIndex: [hfLessonInfo.dayinweek intValue]], NSLocalizedString(@"D_I", @""), hfLessonInfo.start, NSLocalizedString(@"section", @"")];
    } else {
        return [NSString stringWithFormat:@"%@ %@-%d%@", [WEEKDAYS objectAtIndex: [hfLessonInfo.dayinweek intValue]], hfLessonInfo.start, [hfLessonInfo.start intValue] + [hfLessonInfo.duration intValue] - 1, NSLocalizedString(@"section", @"")];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
    // Only allow editing in the ingredients section.
    // In the ingredients section, the last row (row number equal to the count of ingredients) is added automatically (see tableView:cellForRowAtIndexPath:) to provide an insertion cell, so configure that cell for insertion; the other cells are configured for deletion.
    if (indexPath.section > 0 && indexPath.section < 1 + [lessonInfos count] && indexPath.row == 0) {
        style = UITableViewCellEditingStyleDelete;
    }
    
    return style;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Only allow deletion, and only in the ingredients section
    if ((editingStyle == UITableViewCellEditingStyleDelete) && (indexPath.section > 0 && indexPath.section < 2 + [lessonInfos count])) {
        // TODO delete lessonInfo
    }
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == [lessonInfos count] + 1) {
        [lessonInfos addObject:[[HFLessonInfo alloc] init]];
        [self.tableView reloadData];
//    } else if (indexPath.section > 0 && indexPath.section < ([lessonInfos count] + 1) && indexPath.row == 0){
    }
}

#pragma mark -
#pragma mark Save and cancel operations

- (IBAction)cancel:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField becomeFirstResponder];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"%@%d", textField.text, textField.tag);
    if (textField.tag == 1) {
        self.lesson.name = textField.text;
    } else if (textField.tag == 2) {
        self.lesson.teacher = textField.text;
    } else if (textField.tag == 3) {
        self.lesson.book = textField.text;
    } else if (textField.tag >= 5) {
        if (textField.tag % 2 == 0) {
            int section = (textField.tag - 4) / 2;
            [[lessonInfos objectAtIndex:(section-1)] setRoom:textField.text];
        } else {
            int section = (textField.tag - 3) / 2;
            //[[lessonInfos objectAtIndex:section] setRoom:textField.text];
        }
    }
}

- (IBAction)toolBarDone:(id)sender {
}

#pragma mark -
#pragma mark Picker Date Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == kDayInWeekComponent) {
        return 7;
    } else if (component == kStartComponent) {
        return 12;
    }
    
    return 12;
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == kDayInWeekComponent) {
        return [WEEKDAYS objectAtIndex:component];
    } else if (component == kStartComponent){
        return [NSString stringWithFormat:@"第%d节", row + 1];
    }
    
    return [NSString stringWithFormat:@"到第%d节", row + 1];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == kDayInWeekComponent) {
        
    } else if (component == kStartComponent) {
        int end = [selectPicker selectedRowInComponent:kEndComponent];
        
        if (end < row) {
            [selectPicker selectRow:row inComponent:kEndComponent animated:YES];
        }
//        self.cities = array;
//        [picker selectRow:0 inComponent:kCityComponent animated:YES];
//        [picker reloadComponent:kCityComponent];
    } else {
        int start = [selectPicker selectedRowInComponent:kStartComponent];
        
        if (start > row) {
            [selectPicker selectRow:start inComponent:kEndComponent animated:YES];
//            [selectPicker reloadComponent:kEndComponent];
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == kDayInWeekComponent) {
        return 50;
    }
    return 100;
}
@end
