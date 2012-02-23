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
        
        
    }
    return self;
}


-(BOOL) internetIsReachable
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

-(BOOL) hostIsReachable{
    
    Reachability *hostConnection = [[Reachability reachabilityWithHostName: @"www.parse.com"] retain];
    NetworkStatus hostStatus = [hostConnection currentReachabilityStatus];
    [hostConnection release];
    
    switch (hostStatus)
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
