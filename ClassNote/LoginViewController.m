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
#import "HFUtils.h"

@implementation LoginViewController
@synthesize scrollView;
@synthesize user,password, delegate;
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	
    [super viewDidLoad];
    password.secureTextEntry = YES;
    user.delegate = self;
    password.delegate = self;
    
    [self registerForKeyboardNotifications];
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
            [HFUtils setAuthToken:auth_res.auth_token];
            [HFUtils setLogged:YES];
            NSDictionary *dictionary = [NSMutableDictionary dictionaryWithObject:@"email" forKey:user.text];
            [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:@"userinfo"];
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

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
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
    [self setScrollView:nil];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [scrollView release];
    [super dealloc];
}

@end
