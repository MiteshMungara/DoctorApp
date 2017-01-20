//
//  AppDelegate.m
//  Halka BHolath
//
//  Created by iSquare2 on 10/25/16.
//  Copyright © 2016 MitsSoft. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize deviceTokenStr;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
 //   sleep(3);
   
    //push
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [application registerForRemoteNotifications];
        
    }else{
        //create token
        [application registerForRemoteNotifications];
    }
    
    if (launchOptions != nil)
    {
        application.applicationIconBadgeNumber = 0;
        NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (dictionary != nil)
        {
        }
    }

    return YES;
}

- (NSUInteger) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if ([[self.window.rootViewController presentedViewController] isKindOfClass:[MPMoviePlayerViewController class]])
    {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    deviceTokenStr=[NSString stringWithFormat:@"%@",deviceToken];
    deviceTokenStr=[deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    deviceTokenStr=[deviceTokenStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    deviceTokenStr=[deviceTokenStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSLog(@"deviceTokenStr :%@",deviceTokenStr);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeviceRegister" object:nil];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    application.applicationIconBadgeNumber = 0;
    NSLog(@"Remote Notification Recieved %@",userInfo);
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground ||
       [UIApplication sharedApplication].applicationState == UIApplicationStateInactive)
    {
        
//        NSString *notificationStatusString = [[NSUserDefaults standardUserDefaults] stringForKey:@"NotificationStatus"];
//        NSString *notificationSoundStatusString = [[NSUserDefaults standardUserDefaults] stringForKey:@"NotificationSoundStatus"];
//        
//        
//        NSString *str = [NSString stringWithFormat:@"%@",userInfo];
    }
    else
    {
        
    }
        
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
