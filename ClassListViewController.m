//
//  ClassListViewController.m
//  FleetFeetTulsaPage3
//
//  Created by David Wright on 1/26/12.
//
#import <Parse/Parse.h>
#import "ClassListViewController.h"
#import "ClassListCustomCell.h"
//#import "AppDelegate.h"


@implementation ClassListViewController

@synthesize myTableView;
@synthesize locationManager;
@synthesize myLocation;
@synthesize classesCheckIns;
@synthesize customerId;
@synthesize customerCalendarClasses;
@synthesize customerClassesToday;
@synthesize customerRegisteredClasses;
@synthesize customerClassCheckIns;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andCustomerId:(NSString *) cid  {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self; // send loc updates to myself
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        [self.locationManager setDistanceFilter:100.0f];
        [self.locationManager startUpdatingLocation];
        self.myLocation = [[CLLocation alloc] init];
        self.customerRegisteredClasses = [[NSMutableArray alloc] init];
        self.customerCalendarClasses = [[NSMutableArray alloc] init];
        self.customerId = [NSString stringWithString:cid];
        [self setCustomerId:cid];
        [self.tableView setRowHeight:76];
        
      
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

    self.title = @"My Classes";
    
    UIBarButtonItem *checkInButton = [[UIBarButtonItem alloc] initWithTitle:@"Check In" style:UIBarButtonItemStylePlain target:self action:@selector(checkInToClass:)];
    self.navigationItem.rightBarButtonItem = checkInButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [checkInButton release];

    [self showLoadingIndicator];
    
    [self fetchCustomerClasses];
    
    
    
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
    
    return customerCalendarClasses.count;
    
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
    self.navigationItem.rightBarButtonItem.enabled = YES;
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
    
    //check for existing checkin -- if a check in exists for this user for this class then notify the user  -- do not insert checkin
    //check to make sure that the user is at one of the fleet feet locations
    //insert checkin record
    //notify user of success or failure
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self showLoadingIndicator];
    
    
    [NSThread detachNewThreadSelector:@selector(checkInToClassBackground) toTarget:self withObject:nil];
    
    }


-(void)checkInToClassBackground{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    BOOL existingCheckIn =  NO;
    BOOL userAtValidLocation =  NO;
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PFObject *customerClass = [customerCalendarClasses objectAtIndex:[[myTableView indexPathForSelectedRow] row]];
    
    //PFQuery *checkInQuery = [PFQuery queryWithClassName:@"CheckIn"];
    //[checkInQuery whereKey:@"ClassOfferingId" equalTo:[customerClass objectForKey:@"ClassOfferingId"]];
    //[checkInQuery whereKey:@"CustomerId" equalTo:appDelegate.customerId];
    //NSArray *existingCheckIns= [checkInQuery findObjects:nil];
    
    for (PFObject *pfo in customerClassCheckIns)
    {
        
        if ([pfo objectForKey:@"ClassOfferingId"] == [customerClass objectForKey:@"ClassOfferingId"]){
            existingCheckIn = YES;
        }
        
    }
    
    
    if([CLLocationManager locationServicesEnabled])
    {
        
        
        // User's location
        PFGeoPoint *userPoint = [PFGeoPoint geoPointWithLatitude:myLocation.coordinate.latitude longitude:myLocation.coordinate.longitude];
        // Create a query for places
        PFQuery *query = [PFQuery queryWithClassName:@"Locations"];
        // Interested in locations near user.
        [query whereKey:@"Coordinates" nearGeoPoint:userPoint withinKilometers:50];
        // Limit what could be a lot of points.
        //query.limit = [NSNumber numberWithInt:10];
        // Final list of objects
        //NSArray *placesObjects = [query findObjects];
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
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Success"
                                  message: @"You are checked in to the class."
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [self.tableView reloadData];
            
            [df1 release];
            [alert show];
            [alert release];
        } else {
            
            if(existingCheckIn==YES){
                
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: @"Error"
                                      message: @"You have already checked in to this class."
                                      delegate: nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }else{
                
                if(userAtValidLocation==NO){
                    
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle: @"Error"
                                          message: @"You must be at one of the Fleet Feet locations to check in to a class."
                                          delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    
                }
                
                
            }
        }
    }    //if([CLLocationManager locationServicesEnabled])     
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Error"
                              message: @"You must allow location services to check-in to a class.  You can enable location services in the settings of your mobile device."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    
    
    [self hideLoadingIndicator];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
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
                NSArray *customerClasses = [classCalendarQuery findObjects:nil];
                
                for(PFObject *pfo in customerClasses){
                    [self.customerCalendarClasses addObject:pfo];
                }
            }
            
            //NSLog(@"customer id: %@", self.customerId);
            //NSLog(@"class date: %@", dateString);

            PFQuery *customerClassCheckInsQuery = [PFQuery queryWithClassName:@"CheckIn"];
            [customerClassCheckInsQuery whereKey:@"CustomerId" equalTo:self.customerId];
            [customerClassCheckInsQuery whereKey:@"CheckInDate" equalTo:dateString];
           
            [self setCustomerClassCheckIns: [NSMutableArray arrayWithArray:[customerClassCheckInsQuery findObjects:nil]]];
            
            //NSLog(@"customerCheckIns: %d",self.customerClassCheckIns.count);
            
            
            
            [self.tableView reloadData];
            
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


- (void)dealloc {
    [self.customerRegisteredClasses release];
    [self.customerClassesToday release];
    [self.locationManager release];
    [self.myLocation release];
    [super dealloc];
}

    




@end
