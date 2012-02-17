//
//  main.m
//  FleetFeetTulsaPage3
//
//  Created by David Wright on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    
    [Parse setApplicationId:@"U8sgpoFN9ZkRJ6Wg6r3HCcIovXbXjKpFnzfgYErB" 
                  clientKey:@"UEUmDM8EYXV8NhYjj7QPdlvjR9bO2zmHuVaiW4TE"];
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
