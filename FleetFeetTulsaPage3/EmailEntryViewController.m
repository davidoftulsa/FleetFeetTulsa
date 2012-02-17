//
//  EmailEntryViewController.m
//  FleetFeet
//
//  Created by Joel Eads on 1/31/12.
//  Copyright (c) 2012 Tulsa Community College. All rights reserved.
//

#import "EmailEntryViewController.h"
#import "AppDelegate.h"

@implementation EmailEntryViewController

@synthesize myView;
@synthesize emailTextfield;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[self navigationItem] setTitle:@"Class Check-in"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle





- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.emailTextfield setDelegate:self];
    [self.emailTextfield setReturnKeyType:UIReturnKeySend];
    [self.emailTextfield addTarget:self action:@selector(emailTextfieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    // Do any additional setup after loading the view from its nib.
}




- (IBAction)emailTextfieldFinished:(id)sender
{
    [sender resignFirstResponder];
    
    //functionality for send button to send text to next page goes here
    
  //  SecondPage *secondPage = [[SecondPage alloc]init];
    StudentListViewController *secondPage = [[StudentListViewController  alloc]initWithNibName:@"StudentListViewController" bundle:nil  andCustomerEmail:emailTextfield.text];
    secondPage.title = @"Students";
  //  secondPage.studentEmail.text = emailTextfield.text;
    
    [self.navigationController pushViewController:secondPage animated:YES];
    
    [secondPage release];
 
   
   
}





- (void)viewDidUnload
{
    [super viewDidUnload];
    
    //[emailTextfield release];
    
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [emailTextfield release];
    [super dealloc];
}

@end
