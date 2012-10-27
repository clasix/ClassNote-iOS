//
//  HFMainViewController.m
//  ClassNote
//
//  Created by XiaoYin Wang on 12-10-27.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import "HFMainViewController.h"
#import "NGViewController.h"
#import "HFRemoteUtils.h"
#import "HFExceptionHandler.h"

@interface HFMainViewController ()

@end

@implementation HFMainViewController
@synthesize classTableButton;
@synthesize lessonButton;
@synthesize aboutButton;
@synthesize appDelegate;

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
}

- (void)viewDidUnload
{
    [self setClassTableButton:nil];
    [self setLessonButton:nil];
    [self setAboutButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [classTableButton release];
    [lessonButton release];
    [aboutButton release];
    [super dealloc];
}
- (IBAction)logout:(id)sender {
    NSString *auth_token = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"];
    NSLog(@"Logout of auth_token:%@", auth_token);
    
    BOOL ret = FALSE;
    @try {
        ret = [[[HFRemoteUtils instance] server] sign_out:auth_token];
    }
    @catch (NSException *exception) {
        [HFExceptionHandler handleException:exception];
    }
    @finally {
        
    }
    
    if (ret) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"auth_token"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogged"];
        
        [self.navigationController presentModalViewController:[self.appDelegate goingToMain] animated:YES];
    } else {
        NSLog(@"Logout failed at auth_token:%@", auth_token);
    }
}

- (IBAction)gotoLessonTable:(id)sender {
    NGViewController *vc = [[NGViewController alloc] init];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    if (!context) {
        NSLog(@"ManagedObjectContext created failed. %@", "Nothing");
    }
    
    vc.managedObjectContext = context;
    
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)gotoLesson:(id)sender {
}
@end
