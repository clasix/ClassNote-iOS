//
//  HFSearchListViewController.m
//  ClassNote
//
//  Created by XiaoYin Wang on 12-11-5.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import "HFSearchListViewController.h"
#import "HFUtils.h"
#import "HFRemoteUtils.h"

@interface HFSearchListViewController ()

@end

@implementation HFSearchListViewController

@synthesize listContent, filteredListContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive;

@synthesize searchStep, delegate;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString *auth_token = [HFUtils getAuthToken];
    
    if (searchStep == stepProvince) {
        self.listContent = [[[HFRemoteUtils instance] server] dept_provinces:auth_token];
    } else if (searchStep == stepSchool) {
        NSString * province = [[HFUtils userDictionary] objectForKey:@"province"];
//        [[[HFRemoteUtils instance] server] dept_schools:auth_token 
        self.listContent = [[[HFRemoteUtils instance] server] dept_schools:auth_token :province];
    } else if (searchStep == stepDept) {
        NSString * province = [[HFUtils userDictionary] objectForKey:@"province"];
        NSString * school = [[HFUtils userDictionary] objectForKey:@"school"];
        self.listContent = [[[HFRemoteUtils instance] server] dept_departments:auth_token :province :school];
    } else if (searchStep == stepYear) {
        NSDate * date = [NSDate date];
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSDateComponents *dd = [cal components:unitFlags fromDate:date];
        
        int year = [dd year];
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:8];
        for (int i = 0; i < 8; i ++) {
            [array addObject: [NSString stringWithFormat:@"%d", year - i]];
        }
        
        self.listContent = array;
    }
    
    self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.listContent count]];
	
	// restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
	
	[self.tableView reloadData];
	self.tableView.scrollEnabled = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.filteredListContent = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    // save the state of the search UI so that it can be restored if the view is re-created
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
}

- (void)dealloc
{
	[listContent release];
	[filteredListContent release];
	
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UITableView data source and delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	/*
	 If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
	 */
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredListContent count];
    }
	else
	{
        return [self.listContent count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellID = @"searchListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    // Configure the cell...
    if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [self.filteredListContent objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = [self.listContent objectAtIndex:indexPath.row];
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
    NSString * str;
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        str = [self.filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
        str = [self.listContent objectAtIndex:indexPath.row];
    }
    if (searchStep == stepProvince) {
        [HFUtils setUserValue:str forkey:@"province"];
        HFSearchListViewController * vc = [[HFSearchListViewController alloc] initWithNibName:@"HFSearchListViewController" bundle:nil];
        vc.searchStep = stepSchool;
        
        vc.delegate = self.delegate;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (searchStep == stepSchool) {
        [HFUtils setUserValue:str forkey:@"school"];
        HFSearchListViewController * vc = [[HFSearchListViewController alloc] initWithNibName:@"HFSearchListViewController" bundle:nil];
        vc.searchStep = stepDept;
        
        vc.delegate = self.delegate;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (searchStep == stepDept) {
        [HFUtils setUserValue:str forkey:@"dept"];
        HFSearchListViewController * vc = [[HFSearchListViewController alloc] initWithNibName:@"HFSearchListViewController" bundle:nil];
        vc.searchStep = stepYear;
        
        vc.delegate = self.delegate;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (searchStep == stepYear) {
        [HFUtils setUserValue:str forkey:@"year"];
        
        [self.delegate finishSearch];
//        [self.navigationController popToViewController:self animated:YES];
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	for (NSString* str in listContent)
	{
        //		if ([scope isEqualToString:@"All"] || [hfLesson.type isEqualToString:scope])
		{
			NSComparisonResult result = [str compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
			{
				[self.filteredListContent addObject:str];
            }
		}
	}
}

@end
