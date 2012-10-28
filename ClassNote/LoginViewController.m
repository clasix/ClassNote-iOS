//
//  PassWordViewController.m
//  PassWord
//
//  Created by njcit on 12-4-3.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "NGViewController.h"
#import "HFRemoteUtils.h"
#import "MobClick.h"

@implementation LoginViewController
@synthesize user,password, delegate;
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"LoginPage"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LoginPage"];
}

-(IBAction) logButtonPressed:(id) sender
{
	user.text=nil;
	password.text=nil;
	SignUpViewController *logViewController=[[SignUpViewController alloc]init];
    logViewController.delegate = self.delegate;
	[self.view addSubview:logViewController.view];
	//logViewController.view.frame=CGRectMake(0, 20, 320, 460);
	//[logViewController release];
	
}
-(IBAction) landButtonPressed:(id) sender
{
	if(user.text.length==0||password.text.length==0)
	{
		UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"用户名或密码不能为空" message:@"请键入用户名或密码" delegate:self cancelButtonTitle:@"OK,I know" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	else 
	{
        AuthResponse *auth_res = [[[HFRemoteUtils instance] server] login_by_email:user.text :password.text];
        
        if (auth_res.auth_token) {
            [[NSUserDefaults standardUserDefaults] setObject:auth_res.auth_token forKey:@"auth_token"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogged"];
                        
            [self.navigationController presentModalViewController:[self.delegate goingToMain] animated:YES];
        }
		else
		{
			UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"登陆失败" message:@"用户名或密码不正确" delegate:self cancelButtonTitle:@"OK,I know" otherButtonTitles:nil];
			[alertView show];
			[alertView release];
		}
	}
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
