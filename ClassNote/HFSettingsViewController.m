//
//  HFSettingsViewController.m
//  ClassNote
//
//  Created by XiaoYin Wang on 12-11-5.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import "HFSettingsViewController.h"
#import "HFSearchListViewController.h"

@interface HFSettingsViewController ()

@end

@implementation HFSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Settings";

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                                                                            target:self action:@selector(save:)] autorelease];
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == kDeptComponent) {
        return 3;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"deptCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    // Configure the cell...
    
    NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"userinfo"];

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"学校";
            cell.detailTextLabel.text = [dictionary objectForKey:@"school"];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"专业";
            cell.detailTextLabel.text = [dictionary objectForKey:@"dept"];
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"入学时间";
            cell.detailTextLabel.text = [dictionary objectForKey:@"year"];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"用户名";
            cell.detailTextLabel.text = [dictionary objectForKey:@"username"];
        } else if(indexPath.row == 1) {
            cell.textLabel.text = @"性别";
            cell.detailTextLabel.text = [dictionary objectForKey:@"gender"];
        }
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            HFSearchListViewController * vc = [[HFSearchListViewController alloc] initWithNibName:@"HFSearchListViewController" bundle:nil];
            vc.searchStep = stepProvince;
            
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
            
            
//            HFSearchListViewController * vc = [[HFSearchListViewController alloc] initWithNibName:@"HFSearchListViewController" bundle:nil];
//            vc.searchStep = stepProvince;
        } else if (indexPath.row == 2) {
//            HFSearchListViewController * vc = [[HFSearchListViewController alloc] initWithNibName:@"HFSearchListViewController" bundle:nil];
//            vc.searchStep = stepProvince;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
        } else if (indexPath.row == 1) {
            
        }
    }
}

@end
