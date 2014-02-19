//
//  CDAppDelegate.m
//  count.do
//
//  Created by Ali Can Bülbül on 6/6/13.
//  Copyright (c) 2013 Can Bülbül. All rights reserved.
//

#import "CDAppDelegate.h"
#import "DEStoreKitManager.h"
#import "UIFont+Replacement.h"

@implementation CDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (![[NSUserDefaults standardUserDefaults] dictionaryForKey:@"settings"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@{@"theme":@"basic",@"priority":@"none",@"reminder":@"basic"} forKey:@"settings"];
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"themesBought"];
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"priorityBought"];
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"reminderBought"];
    }
    NSSet *productIdentifiers = [NSSet setWithObjects:@"Themes", @"Priority",@"Reminder", nil];

    [[DEStoreKitManager sharedManager] fetchProductsWithIdentifiers:productIdentifiers
      onSuccess: ^(NSArray *products, NSArray *invalidIdentifiers) {}
      onFailure: ^(NSError *error) {}
     ];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [application setApplicationIconBadgeNumber:0];
}

@end
