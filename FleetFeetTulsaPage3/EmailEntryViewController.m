//
//  EmailEntryViewController.m
//  FleetFeet
//
//  Created by Joel Eads on 1/31/12.
//  Copyright (c) 2012 Tulsa Community College. All rights reserved.
//

#import "EmailEntryViewController.h"
#import "NetworkConnectionTest.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@implementation EmailEntryViewController

@synthesize myView;
@synthesize emailTextfield;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[self navigationItem] setTitle:@"Class Check-in"];
        
        UIScreen *mainScreen = [UIScreen mainScreen];
        CGFloat scale = [mainScreen scale]; //gets scale (2.0 for retina display, 1.0 all others)
        CGRect bounds = [mainScreen bounds]; 
        CGRect pixels = bounds; //sets pixels to whatever the mainScreen bounds are
        if (scale > 0) {
            pixels.origin.x *= scale; //These 4 lines multiply all by 1.0 (or 2.0 if retina)
            pixels.origin.y *= scale;
            pixels.size.width *= scale;
            pixels.size.height *= scale;
        }
        UIColor *background = [[UIColor alloc] 
            initWithPatternImage: [UIImage imageNamed:@"ff_background.png"]];
                   
        self.view.backgroundColor = background;
        [background release];

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


- (void) viewDidDisappear:(BOOL)animated{
    [self.emailTextfield setText:@""];//***** This erases the email address. 
}




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
    
    NetworkConnectionTest *nct = [[NetworkConnectionTest alloc ] init];
    
    if ([nct internetIsReachable]==YES) {
        if([nct hostIsReachable]==YES){
            [self showLoadingIndicator];
            [self fetchCustomers];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"Unable to connect to host database.  Please try again later."
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        

    } else {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"The device is not currently connected to the Internet."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];

        
    }
    
    [nct release];
   
}

- (void)fetchCustomers
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Customer"];
    [query whereKey:@"EmailAddress" equalTo:self.emailTextfield.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            
           
            if (objects.count == 0){
                
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: @""
                                      message: @"There are no customers with this email address."
                                      delegate: nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
                [alert release];

                
            } else if (objects.count == 1){
                
                
                PFObject *customer = [objects objectAtIndex:0];
                
                NSString *customerId = [customer objectId];
                
                
                // Pass control to page 3
                
                ClassListViewController * classListViewController = 
                [[ClassListViewController alloc]  
                  initWithNibName:@"ClassListViewController" 
                  bundle:nil andCustomerId:customerId];
                
                [self.navigationController pushViewController:classListViewController animated:YES];

                [classListViewController release];
                
                
            }else{
                
                StudentListViewController *secondPage = [[StudentListViewController  alloc]initWithNibName:@"StudentListViewController" bundle:nil  andCustomers:objects];
                secondPage.title = @"Students";
                //  secondPage.studentEmail.text = emailTextfield.text;
                
                [self.navigationController pushViewController:secondPage animated:YES];
                
                
                [secondPage release];
                
            }
            
            [self hideLoadingIndicator];
            
      
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

-(void)showLoadingIndicator{
    rView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 110, 164, 164)];
    [rView setImage:[UIImage imageNamed:@"spinnerBackground.png"]];
    //[rView setBackgroundColor:[UIColor lightGrayColor]];
    spinnerView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(62, 60, 40, 40)];
    [spinnerView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinnerView startAnimating];
    [rView addSubview:spinnerView];
    [self.view addSubview:rView];
    [rView release];
}


-(void)hideLoadingIndicator{
	[spinnerView removeFromSuperview];
	[rView removeFromSuperview];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    
    //[self.emailTextfield setText:@""];//***** This erases the email address. 
    //May want this on page 2 or 3 ??????
    
    //[emailTextfield release]; ***** Should this go here instead of dealloc method?
    
    
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
