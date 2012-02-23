//
//  EmailEntryViewController.h
//  FleetFeet
//
//  Created by Joel Eads on 1/31/12.
//  Copyright (c) 2012 Tulsa Community College. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SecondPage.h"
#import "StudentListViewController.h"
#import "ClassListViewController.h"




@interface EmailEntryViewController : UIViewController <UITextFieldDelegate>
{

    IBOutlet UIView *myView;
    IBOutlet UITextField *emailTextfield;
    UIActivityIndicatorView *spinnerView;
    UIImageView *rView;
}

@property (nonatomic, retain) UIView *myView;
@property (nonatomic, retain) UITextField *emailTextfield;


-(IBAction)emailTextfieldFinished:(id)sender;
-(void) fetchCustomers;
-(void) showLoadingIndicator;
-(void) hideLoadingIndicator;

@end
