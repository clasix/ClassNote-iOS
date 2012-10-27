//
//  LogViewController.h
//  PassWord
//
//  Created by njcit on 12-4-3.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFGotoMainDelegate.h"


@interface SignUpViewController : UIViewController 
{
	UITextField *user;
	UITextField *password;
	UITextField *ensurePassword;
	
}
@property (nonatomic,retain) IBOutlet UITextField *user;
@property (nonatomic,retain) IBOutlet UITextField *password;
@property (nonatomic,retain) IBOutlet UITextField *ensurePassword;
-(IBAction) logButtonPressed:(id) sender;
-(IBAction) ensurePasswordComplete:(id) sender;
-(IBAction) userComplete:(id) sender;

@property (nonatomic, assign) id <HFGotoMainDelegate> delegate;
@end
