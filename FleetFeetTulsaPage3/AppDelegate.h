//
//  AppDelegate.h
//  FleetFeetTulsa
//
//  Created by David Wright on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
/*
#import <UIKit/UIKit.h>

@class ClassListViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
   
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ClassListViewController *classListViewController;


@end


*/
#import <UIKit/UIKit.h>
#import "EmailEntryViewController.h"

@class EmailEntryViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) EmailEntryViewController *emailEntryViewController;

@end
