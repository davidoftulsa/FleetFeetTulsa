//
//  NetworkConnectionTest.m
//  FleetFeetTulsa
//
//  Created by David Wright on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NetworkConnectionTest.h"
#import "Reachability.h"

@implementation NetworkConnectionTest

-(id) init{
    self = [super init];
    if(self){
        
        // check for internet connection
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
        
        //internetReachable = [[Reachability reachabilityForInternetConnection] retain];
        //[internetReachable startNotifier];
        
        // check if a pathway to a random host exists
        //hostReachable = [[Reachability reachabilityWithHostName: @"www.apple.com"] retain];
        //[hostReachable startNotifier];

        
        
    }
    return self;
}


-(BOOL) internetConnectionExists;
{
    Reachability *internetConnection = [[Reachability reachabilityForInternetConnection] retain];
    NetworkStatus netStatus = [internetConnection currentReachabilityStatus];
    [internetConnection release];
    
    switch (netStatus)
    {
        case NotReachable:
        {
            return NO;
        }
            
        case ReachableViaWWAN:
        {
            return YES;
        }
        case ReachableViaWiFi:
        {
            return YES;
        }
    }}


-(void) dealloc{
    
   // [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
    
}

@end
