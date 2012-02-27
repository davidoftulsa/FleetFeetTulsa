//
//  ClassListViewController.m
//  FleetFeetTulsaPage3
//
//  Created by David Wright on 1/26/12.
//
#import <Parse/Parse.h>
#import "NetworkConnectionTest.h"
#import "ClassListViewController.h"
#import "ClassListCustomCell.h"
#import "AppDelegate.h"


@implementation ClassListViewController

@synthesize myTableView;
@synthesize locationManager;
@synthesize myLocation;
@synthesize customerId;
@synthesize customerCalendarClasses;
@synthesize customerClassesToday;
@synthesize customerRegisteredClasses;
@synthesize customerClassCheckIns;
@synthesize buttonBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andCustomerId:(NSString *) cid  {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self; // send loc updates to myself
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        [self.locationManager setDistanceFilter:100.0f];
        [self.locationManager startUpdatingLocation];
        //self.myLocation = [[CLLocation alloc] init];
        self.customerRegisteredClasses = [[[NSMutableArray alloc] init] autorelease];
        self.customerCalendarClasses = [[[NSMutableArray alloc] init] autorelease];
        self.customerId = [NSString stringWithString:cid];
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
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] 
                                     initWithTitle:@"Logout" 
                                     style:UIBarButtonItemStylePlain 
                                     target:self 
                                     action:@selector(userLogout)];
	
	
	[[self navigationItem] setRightBarButtonItem:logoutButton];
	[logoutButton release];

    
    [self.myTableView setRowHeight:76];

    self.title = @"My Classes";
    
    [checkInButton setEnabled:NO];
    [checkInButton setAction:@selector(checkInToClass:)];
    [checkInButton setTarget:self];
    
    [editButton setAction:@selector(toggleTableViewEditMode)];
    
    NetworkConnectionTest *nct = [[NetworkConnectionTest alloc ] init];
    
    if ([nct internetIsReachable]==YES) {
        
        if([nct hostIsReachable]==YES){
            [self showLoadingIndicator];
            [self fetchCustomerClasses];
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


    
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self.locationManager stopUpdatingLocation];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

// Customize the number of rows in the table view.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.customerCalendarClasses.count;    
}

// Customize the appearance of table view cells.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ClassListCustomCell";
	
    ClassListCustomCell *cell = (ClassListCustomCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
		
        
        
        
         NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ClassListCustomCell" owner:self options:nil];
		
		for (id currentObject in topLevelObjects){
			if ([currentObject isKindOfClass:[UITableViewCell class]]){
				cell =  (ClassListCustomCell *) currentObject;
				break;
			}
		}
    
        
	}
    
    
    
    PFObject *customerClass = [customerCalendarClasses objectAtIndex:indexPath.row];
    NSString *classTitle = [customerClass objectForKey:@"ClassTitle"];
    NSString *classLocationName = [customerClass objectForKey:@"ClassLocationName"];
    NSString *classDateString = [customerClass objectForKey:@"ClassDate"]; 
    NSString *classTimeString = [customerClass objectForKey:@"ClassTime"];
    
    BOOL hideCheckmarkImage = YES;
     for(PFObject *pfo in self.customerClassCheckIns)
     {
         if ([[pfo objectForKey:@"ClassOfferingId"] isEqualToString:[customerClass objectForKey:@"ClassOfferingId"]])
             hideCheckmarkImage = NO;
     }
    
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setLocale:enUSPOSIXLocale];
    
    [df1 setDateFormat:@"yyyyMMdd HHmm"];
    NSDate *classDateTime = [df1 dateFromString:[NSString stringWithFormat:@"%@ %@",classDateString,classTimeString]];
    
    [df1 setDateFormat:@"MM/dd/yyyy  hh:mm a"];
    NSString *classDateTimeString = [df1 stringFromDate:classDateTime];

    cell.classTitleLabel.text = classTitle;
    cell.classLocationLabel.text = classLocationName;
    cell.classDateTimeLabel.text = classDateTimeString;
    [cell.checkmarkImage setHidden:hideCheckmarkImage];
    
    [enUSPOSIXLocale release];
    [df1 release];
    
    return cell;

}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath 
{
    [checkInButton setEnabled:YES];

    //self.navigationItem.rightBarButtonItem.enabled = YES;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle ==UITableViewCellEditingStyleDelete){

        PFObject *classToRemoveCheckIn = [self.customerCalendarClasses objectAtIndex:indexPath.row];
        NSString *classOfferingIdToRemove = [NSString stringWithString:[classToRemoveCheckIn objectForKey:@"ClassOfferingId"]];
        
        for (int i = 0; i < [self.customerClassCheckIns count]; i++)
        {
            PFObject *pfo = [self.customerClassCheckIns objectAtIndex:i];
            if ([[pfo objectForKey:@"ClassOfferingId"] isEqualToString:classOfferingIdToRemove]){
                [pfo deleteInBackground];
                [self.customerClassCheckIns removeObject:pfo]; 
            }
        }
        
        [self.myTableView reloadData];
        
    }
        
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Remove Check In";
}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    self.myLocation = newLocation;
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
	NSLog(@"Error: %@", [error description]);
}

-(void) checkInToClass:(id) sender{
    
    NetworkConnectionTest *nct = [[NetworkConnectionTest alloc ] init];
    
    if ([nct internetIsReachable]==YES) {

        if([nct hostIsReachable]==YES){
            [checkInButton setEnabled:NO];
            [self showLoadingIndicator];
            [NSThread detachNewThreadSelector:@selector(checkInToClassBackground) toTarget:self withObject:nil];
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


-(void)checkInToClassBackground{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    BOOL existingCheckIn =  NO;
    BOOL userAtValidLocation =  NO;
    
    
    PFObject *customerClass = [customerCalendarClasses objectAtIndex:[[myTableView indexPathForSelectedRow] row]];
    
    
    
    for (PFObject *pfo in customerClassCheckIns)
    {
        
        if ([[pfo objectForKey:@"ClassOfferingId"] isEqualToString:[customerClass objectForKey:@"ClassOfferingId"]] ){
            existingCheckIn = YES;
        }
        
    }
    
    
    
    if([CLLocationManager locationServicesEnabled])
    {
        
        
        
        PFGeoPoint *userPoint = [PFGeoPoint geoPointWithLatitude:myLocation.coordinate.latitude longitude:myLocation.coordinate.longitude];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Locations"];
    
        [query whereKey:@"Coordinates" nearGeoPoint:userPoint withinKilometers:50];
    
        NSNumber *placesObjects  = [NSNumber numberWithInt:[query countObjects]];
        
        if([placesObjects intValue ]>0)
            userAtValidLocation=YES;
        
        if (existingCheckIn==NO && userAtValidLocation==YES){
            
            NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
            
            PFObject *newCheckIn = [PFObject objectWithClassName:@"CheckIn"];
            [newCheckIn setObject:[customerClass objectForKey:@"ClassOfferingId"] forKey:@"ClassOfferingId"];
            [newCheckIn setObject:self.customerId forKey:@"CustomerId"];
            [df1 setDateFormat:@"yyyyMMdd"];
            [newCheckIn setObject:[df1 stringFromDate:[NSDate date]] forKey:@"CheckInDate"];
            [df1 setDateFormat:@"HHmm"];
            [newCheckIn setObject:[df1 stringFromDate:[NSDate date]] forKey:@"CheckInTime"];
            [newCheckIn save];
            [self.customerClassCheckIns addObject:newCheckIn];
            
           
            UIActionSheet *successActionSheet = [[UIActionSheet alloc]
                                                 initWithTitle:@"Check-In Successful!" 
                                                 delegate:self 
                                                 cancelButtonTitle:@"Logout"
                                                 destructiveButtonTitle:nil 
                                                 otherButtonTitles:@"Check-In to another class", nil];
            [successActionSheet setCancelButtonIndex:0];
            
            [self.myTableView reloadData];

            [checkInButton setEnabled:NO];
            
            [df1 release];
            [successActionSheet showInView:self.view];
            [successActionSheet release];
           
        } else {
            
            if(existingCheckIn==YES){
                
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: @""
                                      message: @"You have already checked in to this class."
                                      delegate: nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                [checkInButton setEnabled:YES];
            }else{
                
                if(userAtValidLocation==NO){
                    
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle: @""
                                          message: @"You must be at one of the Fleet Feet locations to check in to a class."
                                          delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    [checkInButton setEnabled:YES];
                    
                }
                
                
            }
        }
    }    //if([CLLocationManager locationServicesEnabled])     
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"You must allow location services to check-in to a class.  You can enable location services in the settings of your mobile device."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        [checkInButton setEnabled:YES];
        
    }
    
    [self hideLoadingIndicator];
    

    [pool drain];

}


-(void) fetchCustomerClasses{
    
    PFQuery *query = [PFQuery queryWithClassName:@"ClassRegistration"];
    [query whereKey:@"CustomerId" equalTo:self.customerId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        if (!error) {

        
            for(PFObject *po in objects){

                [self.customerRegisteredClasses addObject:[po objectForKey:@"ClassOfferingId"]];
            }
            
            
            NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
            
            [df1 setDateFormat:@"yyyyMMdd"];
            
            NSString *dateString = [df1 stringFromDate:[NSDate date]];
            
            
            PFQuery *query = [PFQuery queryWithClassName:@"ClassOffering"];
            [query whereKey:@"objectId" containedIn:customerRegisteredClasses];
            [query whereKey:@"StartDate" lessThanOrEqualTo:dateString];
            [query whereKey:@"EndDate" greaterThanOrEqualTo:dateString];
            NSArray *customerClassOfferings = [query findObjects:nil];
            
            
            
            for(PFObject *pfo in customerClassOfferings){
                
                PFQuery *classCalendarQuery = [PFQuery queryWithClassName:@"ClassCalendar"];
                [classCalendarQuery whereKey:@"ClassId" equalTo:[pfo objectForKey:@"ClassId"]];
                [classCalendarQuery whereKey:@"ClassTermId" equalTo:[pfo objectForKey:@"TermId"]];
                [classCalendarQuery whereKey:@"ClassDate" equalTo:dateString];
                [classCalendarQuery orderByAscending:@"ClassTitle"];
                NSArray *customerClasses = [classCalendarQuery findObjects:nil];
                
                for(PFObject *pfo in customerClasses){
                    [self.customerCalendarClasses addObject:pfo];
                    
                }
            }
            
            
            NSArray *sortedArray;
            sortedArray = [self.customerCalendarClasses sortedArrayUsingComparator:^(id a, id b) {
                NSDate *first = [(PFObject*)a objectForKey:@"ClassTime"];
                NSDate *second = [(PFObject*)b objectForKey:@"ClassTime"];
                return [first compare:second];
            }];
            
             [self setCustomerCalendarClasses:[NSMutableArray arrayWithArray:sortedArray]];
            
            PFQuery *customerClassCheckInsQuery = [PFQuery queryWithClassName:@"CheckIn"];
            [customerClassCheckInsQuery whereKey:@"CustomerId" equalTo:self.customerId];
            [customerClassCheckInsQuery whereKey:@"CheckInDate" equalTo:dateString];
            
           
            [self setCustomerClassCheckIns: [NSMutableArray arrayWithArray:[customerClassCheckInsQuery findObjects:nil]]];
            
            [self.myTableView reloadData];
            
            [self hideLoadingIndicator];
            
            [df1 release];
            
            
            
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        [self userLogout];
        
    } 
    
}

-(void) toggleTableViewEditMode {
    
    if([editButton.title isEqualToString:@"Edit"]){
    [self.myTableView setEditing:YES animated:YES];
    [editButton setTitle:@"Done"];
    } else
    {
        [self.myTableView setEditing:NO animated:YES];
        [editButton setTitle:@"Edit"];
    }
    
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

-(void) userLogout{
    AppDelegate *myAppDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [myAppDelegate.navController popToRootViewControllerAnimated:YES];
}


- (void)dealloc {
    [self.customerRegisteredClasses release];
    [self.customerClassesToday release];
    [self.customerCalendarClasses release];
    [self.customerClassCheckIns release];
    [self.locationManager release];
    [self.myLocation release];
    [self.customerId release];
    [checkInButton release];
    [editButton release];
    [super dealloc];
}

    




@end
