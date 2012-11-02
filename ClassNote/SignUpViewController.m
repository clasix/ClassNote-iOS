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
#import "MobClick.h"

@implementation SignUpViewController
@synthesize scrollView;
@synthesize user,password,ensurePassword, delegate;

- (void)viewDidLoad 
{
    [super viewDidLoad];
    password.secureTextEntry = YES;
    ensurePassword.secureTextEntry = YES;
    user.delegate = self;
    password.delegate = self;
    ensurePassword.delegate = self;
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"SignUpPage"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"SignUpPage"];
}

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

- (IBAction)cancelSignUp:(id)sender {
    [self.view removeFromSuperview];
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
    [scrollView release];
    scrollView = nil;
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [scrollView release];
    [scrollView release];
    [super dealloc];
}


@end
