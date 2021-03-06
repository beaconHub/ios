//
//  AppDelegate.m
//  iBeacon-Hackathon
//
//  Created by HO MING PANG on 15/8/14.
//  Copyright (c) 2014 HO MING PANG. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Crashlytics/Crashlytics.h>
#import <Mixpanel/Mixpanel.h>
#import "CSParallaxHeaderViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [GMSServices provideAPIKey:@"AIzaSyDbnNZDWy0Iw_pnLgsGRN7Py0JkVHMfZKk"];


//    for (NSString* family in [UIFont familyNames]) {
//        NSLog(@"%@", family);
//        for (NSString* name in [UIFont fontNamesForFamilyName:family]) {
//            NSLog(@"%@", name);
//        }
//    }

//    2014-08-30 23:18:01.582 iBeacon-Hackathon[878:476584] Proxima Nova
//    2014-08-30 23:18:01.582 iBeacon-Hackathon[878:476584] ProximaNova-Regular
//    2014-08-30 23:18:01.582 iBeacon-Hackathon[878:476584] ProximaNovaT-Thin
//    2014-08-30 23:18:01.583 iBeacon-Hackathon[878:476584] ProximaNova-Bold
//    2014-08-30 23:18:01.583 iBeacon-Hackathon[878:476584] ProximaNova-Light
    [Crashlytics startWithAPIKey:@"a73df0ceadf9f0995f97da85f3a3ca791c3e0de1"];
    Mixpanel *mixpanel = [Mixpanel sharedInstanceWithToken:@"356a46fa875147baf96e9d08324c16b4"];
    [mixpanel identify:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    
    [mixpanel track:@"Start"];

    UIApplication *app = [UIApplication sharedApplication];
    if ([app respondsToSelector:@selector(registerForRemoteNotifications)]) {
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [app registerUserNotificationSettings:settings];
        [app registerForRemoteNotifications];
    } else {
        [app registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.



}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    UINavigationController* navController = (UINavigationController*) [self.window.rootViewController.childViewControllers objectAtIndex:0];
    [navController popToRootViewControllerAnimated:NO];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self clearNotifications:application];
    
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSString *beaconId = [defs objectForKey:@"monitorBeaconId"];
    
    if (beaconId != nil) {
        [defs removeObjectForKey:@"monitorBeaconId"];
        NSDictionary *beacons = [defs objectForKey:@"beacons"];
        NSDictionary *beaconObj = [beacons objectForKey:beaconId];

        [[Mixpanel sharedInstance] track:@"enterBeaconService" properties:@{
                                                                            @"beaconId": beaconId,
                                                                            @"uuid": [beaconObj objectForKey:@"uuid"],
                                                                            @"major": [beaconObj objectForKey:@"major"],
                                                                            @"minor": [beaconObj objectForKey:@"minor"],
                                                                            @"name": [beaconObj objectForKey:@"name"],
                                                                            @"link": [beaconObj objectForKey:@"link"]
                                                                            }];
        


        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

        UINavigationController* navController = (UINavigationController*) [self.window.rootViewController.childViewControllers objectAtIndex:0];

        CSParallaxHeaderViewController *pageViewController = [storyboard instantiateViewControllerWithIdentifier:@"CSParallaxHeaderViewController"];

        [pageViewController setBeaconObj:beaconObj];


        [navController pushViewController:pageViewController animated:YES];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        NSLog(@"application active didreceivelocationnotification");
    } else if (state == UIApplicationStateInactive) {
        NSLog(@"application inactive didreceivelocationnotification");
    }
}

- (void)clearNotifications:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber: 0];
    [application cancelAllLocalNotifications];
}



@end
