//
//  PassWordViewController.h
//  PassWord
//
//  Created by njcit on 12-4-3.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "service.h"
#import "GuideViewController.h"
#import "HFGotoMainDelegate.h"

@interface LoginViewController : UIViewController 
{
	UITextField *user;
	UITextField *password;
}
@property (retain,nonatomic) IBOutlet UITextField *user;
@property (retain,nonatomic) IBOutlet UITextField *password ;
-(IBAction) logButtonPressed:(id) sender;
-(IBAction) landButtonPressed:(id) sender;

@property (nonatomic, assign) id <HFGotoMainDelegate> delegate;

@end

