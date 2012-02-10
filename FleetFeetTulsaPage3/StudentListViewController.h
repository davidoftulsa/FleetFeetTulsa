//
//  StudentListViewController.h
//  FleetFeetTulsaPage3
//
//  Created by Liliana Crossley on 2/1/12.
//  Copyright (c) 2012 CCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassListViewController.h"

@interface StudentListViewController : UITableViewController {
    NSArray *customers;
    IBOutlet UITableView *myTableView;
    UIActivityIndicatorView *spinnerView;
    UIImageView *rView;
    NSString *studentEmail;
    NSString *studentId;

}

@property (nonatomic, retain) UITableView* myTableView;
@property (nonatomic, retain) NSArray *customers;
@property (nonatomic, retain) NSString *studentEmail;
@property (nonatomic, retain) NSString * studentId;


-(void) fetchCustomers;
-(void) showLoadingIndicator;
-(void) hideLoadingIndicator;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andCustomerEmail:(NSString *) cemail;

@end
