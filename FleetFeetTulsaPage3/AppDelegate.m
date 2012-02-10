//
//  AppDelegate.m
//  FleetFeetTulsaPage3
//
//  Created by David Wright on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "EmailEntryViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize emailEntryViewController;

- (void)dealloc
{
    [_window release];
    [emailEntryViewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.emailEntryViewController = [[[EmailEntryViewController alloc] initWithNibName:@"EmailEntryViewController" bundle:nil] autorelease];
    
    // emailEntryViewController = [[EmailEntryViewController alloc]init];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:emailEntryViewController];
    
    //[navController pushViewController:self.emailEntryViewController animated:YES];
    
    [self.window setRootViewController:navController];
    //[self.window addSubview:navController.view];
    //self.window.rootViewController = self.viewController;
    
    //[navController release]; ????
    [self.window makeKeyAndVisible];
    return YES;
}


/*
#import "ClassLIstViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize classListViewController = _classListViewController;


- (void)dealloc
{
    [_window release];
    [_classListViewController release];
    
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.classListViewController = [[[ClassListViewController alloc] initWithNibName:@"ClassListViewController" bundle:nil andCustomerId:@"8Ep1dfv6d6"] autorelease];
    UINavigationController * navigation = [[UINavigationController alloc] init];
    [navigation pushViewController:self.classListViewController animated:YES];
    
    [self.window addSubview:navigation.view];

    //self.window.rootViewController = self.classListViewController;
    [self.window makeKeyAndVisible];
    return YES;
}
*/
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
