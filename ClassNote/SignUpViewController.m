    //
//  LogViewController.m
//  PassWord
//
//  Created by njcit on 12-4-3.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SignUpViewController.h"
#import "LoginViewController.h"
#import "HFRemoteUtils.h"
@implementation SignUpViewController
@synthesize user,password,ensurePassword, delegate;
-(IBAction) logButtonPressed:(id) sender
{
	
	if(user.text.length==0||password.text.length==0||ensurePassword.text.length==0)
	{
		UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"用户名或密码不能为空" message:@"请键入用户名或密码" delegate:self cancelButtonTitle:@"OK,I know" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	else 
	{
        bool success = [[[HFRemoteUtils instance] server] sign_up_email:user.text :password.text];

        if (success) {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"注册成功" message:nil delegate:self cancelButtonTitle:@"OK,I know" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            
//            AuthResponse *auth_res = [[[HFLoginUtils instance] server] login_by_email:user.text :password.text];
//            
//            if (auth_res.auth_token) {
//                [[NSUserDefaults standardUserDefaults] setObject:auth_res.auth_token forKey:@"auth_token"];
//                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogged"];
//                
//                [self.navigationController presentModalViewController:[self.delegate goingToMain] animated:YES];
//            }
            
            //[[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:[PassWordViewController sharedPassWordViewController].view];
            [self.view removeFromSuperview];
        } else {
            NSLog(@"Sign up failed");
        }
	}
}
-(IBAction) userComplete:(id) sender
{
	if(FALSE)// TODO: [[[HFLoginUtils instance] server] sign_up_emai]
	{
		UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"用户名已存在" message:@"请重新选择用户名" delegate:self cancelButtonTitle:@"OK,I know" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		user.text=nil;
	}
	
}
-(IBAction) ensurePasswordComplete:(id) sender
{
	if(![ensurePassword.text isEqualToString:password.text])
	{
		UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"两次输入密码不相同" message:@"重新确认" delegate:self cancelButtonTitle:@"OK,I know" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		ensurePassword.text=nil;
		password.text=nil;
		
	}
}
/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
