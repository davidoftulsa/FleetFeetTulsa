//
//  StudentListViewController.m
//  FleetFeetTulsaPage3
//
//  Created by Liliana Crossley on 2/1/12.
//  Copyright (c) 2012 CCS. All rights reserved.
//

#import "StudentListViewController.h"
#import <Parse/Parse.h>
#import "StudentListCustomCell.h"
#import "AppDelegate.h"
#import "ClassLIstViewController.h"

@implementation StudentListViewController

@synthesize myTableView, customers, studentEmail, studentId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andCustomers:(NSArray *) clist;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //   [self.tableView setRowHeight:76];
        //self.studentEmail = [NSString stringWithString:cemail];
        [self setCustomers:clist];
        
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
    //UIBarButtonItem *LoadClassesButton = [[UIBarButtonItem alloc] initWithTitle:@"Classes" style:UIBarButtonItemStylePlain target:self action:@selector(LoadClasses:)];
    //self.navigationItem.rightBarButtonItem = LoadClassesButton;
    //self.navigationItem.rightBarButtonItem.enabled = NO;
    //[LoadClassesButton release];
    
    //[self showLoadingIndicator];
    
    //[self fetchCustomers];
    self.title = @"Students";
    
    //[self hideLoadingIndicator];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return customers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StudentListCustomCell";
    
    StudentListCustomCell *cell = (StudentListCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"StudentListCustomCell" owner:self options:nil];
		
		for (id currentObject in topLevelObjects){
			if ([currentObject isKindOfClass:[UITableViewCell class]]){
				cell =  (StudentListCustomCell *) currentObject;
				break;
			}
		}
    }
    
    // Configure the cell...
    
    PFObject *customer = [customers objectAtIndex:indexPath.row];
    // NSString *Id = [customer objectId];
    NSString *email = [customer objectForKey:@"EmailAddress"];
    NSString *name = [NSString stringWithFormat:@"%@ %@",[customer objectForKey:@"FirstName"], [customer objectForKey:@"LastName"]];
    
    
    cell.StudentNameLabel.text = name;
    cell.StudentEmailLabel.text = email;
    // cell.StudentIdLabel.text = Id;
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    PFObject *customer = [customers objectAtIndex:[[myTableView indexPathForSelectedRow] row]];
    
    NSString *customerId = [customer objectId];
    
    ClassListViewController * classListViewController = 
    [[ClassListViewController alloc]  
     initWithNibName:@"ClassListViewController" 
     bundle:nil andCustomerId:customerId];
    
    [self.navigationController pushViewController:classListViewController animated:YES];
    [classListViewController release];
    
    
}


-(void)showLoadingIndicator{
    rView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 110, 164, 164)];
    [rView setImage:[UIImage imageNamed:@"spinnerBackground.png"]];
    spinnerView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(62, 50, 40, 40)];
    [spinnerView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinnerView startAnimating];
    [rView addSubview:spinnerView];
    [self.view addSubview:rView];
    [rView release];
}


-(void)hideLoadingIndicator{
	[spinnerView removeFromSuperview];
	[rView removeFromSuperview];
    [spinnerView release];
    
}

-(void) dealloc{

    [self.customers release];
    [super dealloc];
}


@end
