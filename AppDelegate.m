//
//  AppDelegate.m
//  DoctorApp
//
//  Created by isquare2 on 4/7/16.
//  Copyright © 2016 isquare2. All rights reserved.
//

#import "AppDelegate.h"
#import "DHeader.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize pushNotificationArr,deviceTokenStr,openChatStr,mapListArr,GOChatStr,GoChatInTerminateStr,copypushNotificationArr,openBookedStr,BookedTerminatedStr, GoBookingStr,GoChatRequestStr,openChatRequestStr;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //    self.shareModel = [LocationManager sharedManager];
    //    self.shareModel.afterResume = NO;
    //
    //    [self.shareModel addApplicationStatusToPList:@"didFinishLaunchingWithOptions"];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    NSLog(@"Start App");
    //push
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [application registerForRemoteNotifications];
    }else{
        //create token
        [application registerForRemoteNotifications];
    }
    
    NSString *NotificationString = [[NSUserDefaults standardUserDefaults] stringForKey:@"NotificationStatus"];
    
    if (!NotificationString)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"NotificationStatus"];
    }
    NSString *NotificationSoundString = [[NSUserDefaults standardUserDefaults] stringForKey:@"NotificationSoundStatus"];
    if (!NotificationSoundString)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"NotificationSoundStatus"];
        
    }
    NSString *statusKeyStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"StatusForDoctorKey"];
    
    
    if (launchOptions != nil)
    {
        NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (dictionary != nil)
        {
            //NSString *str = [NSString stringWithFormat:@"%@",dictionary];
            //ALERT_VIEW(@"1",str)
            pushNotificationArr = [dictionary valueForKey:@"aps"];
        }
        if ([statusKeyStr isEqualToString:@"1"])
        {
            if ([[pushNotificationArr valueForKey:@"type"] isEqualToString:@"payment has been completed"]) {
                
            }
            else if ([[pushNotificationArr valueForKey:@"type"] isEqualToString:@"chat"])
            {
                NSString *requestStr = [pushNotificationArr valueForKey:@"request_status"];
                if ([requestStr isEqualToString:@"1"])
                {
                    // if ([openChatRequestStr isEqualToString:@"Yes"])
                    //  {
                    GoChatRequestStr = @"0";
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DirectChatTableOFPUSHnoti" object:nil];
                    
                    
                }
                else
                {
                    GOChatStr = @"0";
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DirectChatTableOFPUSHnoti" object:nil];
                }
                
                //                NSString *requestStr = [pushNotificationArr valueForKey:@"request_status"];
                //                if ([requestStr isEqualToString:@"1"]) {
                //                    if ([openChatStr isEqualToString:@"Yes"])
                //                    {
                //                        GOChatStr = @"0";
                //                        GoChatInTerminateStr = @"Yes";
                //                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestComplete" object:nil];
                //
                //                    }
                //                    else
                //                    {
                //                        GOChatStr = @"1";
                //                        GoChatInTerminateStr = @"Yes";
                //                        // [[NSNotificationCenter defaultCenter] postNotificationName:@"MyChat" object:nil];
                //                        // [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestComplete" object:nil];
                //
                //                    }
                //                }
                //                else if ([[pushNotificationArr valueForKey:@"type"] isEqualToString:@"book"]) {
                //                    BookedTerminatedStr = @"Yes";
                //                }
                //                else
                //                {
                //                    if ([openChatStr isEqualToString:@"Yes"])
                //                    {
                //                        GOChatStr = @"0";
                //                        GoChatInTerminateStr = @"Yes";
                //                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestComplete" object:nil];
                //
                //                    }
                //                    else
                //                    {
                //                        GOChatStr = @"1";
                //                        GoChatInTerminateStr = @"Yes";
                //                        // [[NSNotificationCenter defaultCenter] postNotificationName:@"MyChat" object:nil];
                //                        // [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestComplete" object:nil];
                //
                //                    }
                //                }
                
            }
        }
        
        
        
    }
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction :@"" ,PayPalEnvironmentSandbox : @"AWD9viO8g4D98_huIo9BIXPyXTaRCeWdBScej901lx-Fg1fSMohY8fR0uXjCWx_XipTH1aQr1Ws1qW8O"}];
    
    NSLog(@"didFinishLaunchingWithOptions");
    
    //Location Traking
    self.shareModel = [LocationManager sharedManager];
    self.shareModel.afterResume = NO;
    
    [self.shareModel addApplicationStatusToPList:@"didFinishLaunchingWithOptions"];
    
    UIAlertView * alert;
    
    //We have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
    if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied) {
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh"
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    } else if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted) {
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The functions of this app are limited because the Background App Refresh is disable."
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    } else {
        
        // When there is a significant changes of the location,
        // The key UIApplicationLaunchOptionsLocationKey will be returned from didFinishLaunchingWithOptions
        // When the app is receiving the key, it must reinitiate the locationManager and get
        // the latest location updates
        
        // This UIApplicationLaunchOptionsLocationKey key enables the location update even when
        // the app has been killed/terminated (Not in th background) by iOS or the user.
        
        NSLog(@"UIApplicationLaunchOptionsLocationKey : %@" , [launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]);
        if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]) {
            
            // This "afterResume" flag is just to show that he receiving location updates
            // are actually from the key "UIApplicationLaunchOptionsLocationKey"
            self.shareModel.afterResume = YES;
            GOChatStr = @"1";
            // [[NSNotificationCenter defaultCenter] postNotificationName:@"RedirectChatTableOFPUSHnoti" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestComplete" object:nil];
            [self.shareModel startMonitoringLocation];
            // [self.shareModel addResumeLocationToPList];
        }
    }
    
    
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    deviceTokenStr=[NSString stringWithFormat:@"%@",deviceToken];
    deviceTokenStr=[deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    deviceTokenStr=[deviceTokenStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    deviceTokenStr=[deviceTokenStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"NotificationSoundStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"deviceTokenStr :%@",deviceTokenStr);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground ||
       [UIApplication sharedApplication].applicationState == UIApplicationStateInactive)
    {
        // NSString *notificationSoundStatusString = [[NSUserDefaults standardUserDefaults] stringForKey:@"NotificationSoundStatus"];
        
        
        //NSString *str = [NSString stringWithFormat:@"%@",userInfo];
        //ALERT_VIEW(@"2",str)
        //        NSString *notificationStatusString = [[NSUserDefaults standardUserDefaults] stringForKey:@"NotificationStatus"];
        //        if ([notificationStatusString isEqualToString:@"1"])
        //        {
        pushNotificationArr = [userInfo valueForKey:@"aps"];
        NSString *notificationStatusString = [[NSUserDefaults standardUserDefaults] stringForKey:@"NotificationStatus"];
        //        if ([[pushNotificationArr valueForKey:@"type"]  isEqualToString:@"Cancel Booking"]) {
        //
        //            if ([GoBookingStr isEqualToString:@"Yes"])
        //            {
        //                [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewbookCancelBooking" object:nil];
        //            }
        //
        //            else
        //            {
        //                if([notificationStatusString isEqualToString:@"1"])
        //                {
        //                    [[NSNotificationCenter defaultCenter] postNotificationName:@"bookCancelBooking" object:nil];
        //                }
        //            }
        //        }else
        if ([[pushNotificationArr valueForKey:@"type"] isEqualToString:@"book"])
        {
            
                        GOChatStr = @"0";
                        if ([GoBookingStr isEqualToString:@"Yes"])
                        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"bookOFPUSHnoti" object:nil];
                        }
                        else
                       {
                            if ([notificationStatusString isEqualToString:@"1"])
                            {
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"DashbookOFPUSHnoti" object:nil];
                            }
                        }
            
        }
        else if ([[pushNotificationArr valueForKey:@"type"] isEqualToString:@"chat"])
        {
            NSString *requestStr = [pushNotificationArr valueForKey:@"request_status"];
            if ([requestStr isEqualToString:@"1"])
            {
                 if ([openChatRequestStr isEqualToString:@"Yes"])
                {
                    GoChatRequestStr = @"0";
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestComplete" object:nil];
                }
                else
                {
                    GoChatRequestStr = @"0";
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DirectChatTableOFPUSHnoti" object:nil];
                }
               
                
                
            }
            else
            {
                if ([openChatStr isEqualToString:@"Yes"])
                {
                    GOChatStr = @"0";
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshChatTableOFPUSHnoti" object:nil];
                }
                else
                {
                    GOChatStr = @"0";
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DirectChatTableOFPUSHnoti" object:nil];
                }
            }
        }
            //                else
            //                {
            //                    if ([notificationStatusString isEqualToString:@"1"])
            //                    {
            //                        GoChatRequestStr = @"1";
            //
            //                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RedirectGoChatTableOFPUSHnoti" object:nil];
            //                    }
            //                    // [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestComplete" object:nil];
            //                }
      
//        else if ([[pushNotificationArr valueForKey:@"type"] isEqualToString:@"chat"])
//        {
            //                if ([openChatStr isEqualToString:@"Yes"])
            //                {
           
            //                }
            //                else
            //                {
            //                    if ([notificationStatusString isEqualToString:@"1"])
            //                    {
            //                        GOChatStr = @"1";
            //
            //                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RedirectChatTableOFPUSHnoti" object:nil];
            //                    }
            //                    // [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshChatTableOFPUSHnoti" object:nil];
            //
            //                }
            //  }
            
        //}
        // }
    }else{
        NSString *notificationSoundStatusString = [[NSUserDefaults standardUserDefaults] stringForKey:@"NotificationSoundStatus"];
        NSString *notificationStatusString = [[NSUserDefaults standardUserDefaults] stringForKey:@"NotificationStatus"];
        
        //NSString *str = [NSString stringWithFormat:@"%@",userInfo];
        //ALERT_VIEW(@"3",str)
        
        pushNotificationArr = [userInfo valueForKey:@"aps"];
        //        if ([[pushNotificationArr valueForKey:@"type"]  isEqualToString:@"Cancel Booking"]) {
        //            if ([GoBookingStr isEqualToString:@"Yes"])
        //            {
        //
        //                [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewbookCancelBooking" object:nil];
        //
        //            }
        //            else
        //            {
        //                if ([notificationStatusString isEqualToString:@"1"])
        //                {
        //                    if ([notificationSoundStatusString isEqualToString:@"1"])
        //                    {
        //                        self.audioController = [[AudioController alloc] init];
        //                        [self.audioController playSystemSound];
        //
        //                    }
        //                    [[NSNotificationCenter defaultCenter] postNotificationName:@"bookCancelBooking" object:nil];
        //                }
        //            }
        //        }else
        if ([[pushNotificationArr valueForKey:@"type"] isEqualToString:@"book"])
        {
            GOChatStr = @"0";
            if ([GoBookingStr isEqualToString:@"Yes"])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"bookOFPUSHnoti" object:nil];
            }
            else
            {
                
                if ([notificationStatusString isEqualToString:@"1"])
                {
                    if ([notificationSoundStatusString isEqualToString:@"1"])
                    {
                        self.audioController = [[AudioController alloc] init];
                        [self.audioController playSystemSound];
                        
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DashbookOFPUSHnoti" object:nil];
                }
            }
            
        }
        else if ([[pushNotificationArr valueForKey:@"type"] isEqualToString:@"payment has been completed"])
        {
            if ([notificationStatusString isEqualToString:@"1"])
            {
                GOChatStr = @"0";
                if ([notificationSoundStatusString isEqualToString:@"1"])
                {
                    self.audioController = [[AudioController alloc] init];
                    [self.audioController playSystemSound];
                    
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"bookOFPUSHnoti" object:nil];
            }
        }
        else if ([[pushNotificationArr valueForKey:@"type"] isEqualToString:@"chat"])
        {
            NSString *requestStr = [pushNotificationArr valueForKey:@"request_status"];
            
            if ([requestStr isEqualToString:@"1"])
            {
                if ([openChatRequestStr isEqualToString:@"Yes"])
                {
                    GoChatRequestStr = @"0";
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestComplete" object:nil];
                    
                    //[[NSNotificationCenter defaultCenter] postNotificationName:@"RequestRefreshChatTableOFPUSHnoti" object:nil];
                }
                else
                {
                    if ([notificationStatusString isEqualToString:@"1"])
                    {
                        GoChatRequestStr = @"1";
                        if ([notificationSoundStatusString isEqualToString:@"1"])
                        {
                            self.audioController = [[AudioController alloc] init];
                            [self.audioController playSystemSound];
                            
                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RedirectGoChatTableOFPUSHnoti" object:nil];//RedirectGoChatTableOFPUSHnoti   RedirectChatTableOFPUSHnoti
                    }
                }
            }
            else
            {
                if ([openChatStr isEqualToString:@"Yes"])
                {
                    GOChatStr = @"0";
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshChatTableOFPUSHnoti" object:nil];
                }
                else
                {
                    if ([notificationStatusString isEqualToString:@"1"])
                    {
                        GOChatStr = @"1";
                        if ([notificationSoundStatusString isEqualToString:@"1"])
                        {
                            self.audioController = [[AudioController alloc] init];
                            [self.audioController playSystemSound];
                            
                        }
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RedirectChatTableOFPUSHnoti" object:nil];
                    }
                    
                }
            }
        }
        
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self.shareModel restartMonitoringLocation];
    
    [self.shareModel addApplicationStatusToPList:@"applicationDidEnterBackground"];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [self.shareModel addApplicationStatusToPList:@"applicationDidBecomeActive"];
    
    //Remove the "afterResume" Flag after the app is active again.
    self.shareModel.afterResume = NO;
    
    [self.shareModel startMonitoringLocation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self.shareModel addApplicationStatusToPList:@"applicationWillTerminate"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"StatusForDoctorKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
