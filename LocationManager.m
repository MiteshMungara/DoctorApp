//
//  LocationShareModel.m
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location. All rights reserved.
//

#import "LocationManager.h"
#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "DHeader.h"
@interface LocationManager () <CLLocationManagerDelegate>
{
    NSString *longString;
    NSString *latiString;
}
@end


@implementation LocationManager

//Class method to make sure the share model is synch across the app
+ (id)sharedManager {
    static id sharedMyModel = nil;
    static dispatch_once_t onceToken;
    
    
    dispatch_once(&onceToken, ^{
        sharedMyModel = [[self alloc] init];
    });
    
    return sharedMyModel;
}


#pragma mark - CLLocationManager

- (void)startMonitoringLocation {
    if (_anotherLocationManager)
        [_anotherLocationManager stopMonitoringSignificantLocationChanges];
    
    self.anotherLocationManager = [[CLLocationManager alloc]init];
    _anotherLocationManager.delegate = self;
    _anotherLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    _anotherLocationManager.activityType = CLActivityTypeOtherNavigation;
    
    if(IS_OS_8_OR_LATER) {
        [_anotherLocationManager requestAlwaysAuthorization];
    }
      //[_anotherLocationManager startUpdatingLocation];
    [_anotherLocationManager startMonitoringSignificantLocationChanges];
}

- (void)restartMonitoringLocation {
    [_anotherLocationManager stopMonitoringSignificantLocationChanges];
    
    if (IS_OS_8_OR_LATER) {
        [_anotherLocationManager requestAlwaysAuthorization];
    }
    // [_anotherLocationManager startUpdatingLocation];
    [_anotherLocationManager startMonitoringSignificantLocationChanges];
}


#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    NSLog(@"locationManager didUpdateLocations: %@",locations);
    
    for (int i = 0; i < locations.count; i++) {
        
        CLLocation * newLocation = [locations objectAtIndex:i];
        CLLocationCoordinate2D theLocation = newLocation.coordinate;
        CLLocationAccuracy theAccuracy = newLocation.horizontalAccuracy;
        
        self.myLocation = theLocation;
        self.myLocationAccuracy = theAccuracy;
    }
//    NSString *latitudeStr = [NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:self.myLocation.latitude]];
//     NSString *longituteStr = [NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:self.myLocation.longitude]];
    
    [self addLocationToPList:_afterResume];
}



#pragma mark - Plist helper methods

// Below are 3 functions that add location and Application status to PList
// The purpose is to collect location information locally

- (NSString *)appState {
    UIApplication* application = [UIApplication sharedApplication];

    NSString * appState;
    if([application applicationState]==UIApplicationStateActive)
        appState = @"UIApplicationStateActive";
    if([application applicationState]==UIApplicationStateBackground)
        appState = @"UIApplicationStateBackground";
    if([application applicationState]==UIApplicationStateInactive)
        appState = @"UIApplicationStateInactive";
    
    return appState;
}

- (void)addResumeLocationToPList {
    
    NSLog(@"addResumeLocationToPList :add");
    
    //NSString * appState = [self appState];
    
//    self.myLocationDictInPlist = [[NSMutableDictionary alloc]init];
//    [_myLocationDictInPlist setObject:@"UIApplicationLaunchOptionsLocationKey" forKey:@"Resume"];
//    [_myLocationDictInPlist setObject:appState forKey:@"AppState"];
//    [_myLocationDictInPlist setObject:[NSDate date] forKey:@"Time"];
//    
    [self saveLocationsToPlist];
}



- (void)addLocationToPList:(BOOL)fromResume {
    NSLog(@"addLocationToPList :Resume");
    
//    NSString * appState = [self appState];
//    
//    self.myLocationDictInPlist = [[NSMutableDictionary alloc]init];
//    [_myLocationDictInPlist setObject:[NSNumber numberWithDouble:self.myLocation.latitude]  forKey:@"Latitude"];
//    [_myLocationDictInPlist setObject:[NSNumber numberWithDouble:self.myLocation.longitude] forKey:@"Longitude"];
//    [_myLocationDictInPlist setObject:[NSNumber numberWithDouble:self.myLocationAccuracy] forKey:@"Accuracy"];
//    
//    [_myLocationDictInPlist setObject:appState forKey:@"AppState"];
//    
//    if (fromResume) {
//        [_myLocationDictInPlist setObject:@"YES" forKey:@"AddFromResume"];
//    } else {
//        [_myLocationDictInPlist setObject:@"NO" forKey:@"AddFromResume"];
//    }
//    
//    [_myLocationDictInPlist setObject:[NSDate date] forKey:@"Time"];
    
    [self saveLocationsToPlist];
}

- (void)addApplicationStatusToPList:(NSString*)applicationStatus {
    
    NSLog(@"addApplicationStatusToPList :Status");
    
//    NSString * appState = [self appState];
//    
//    self.myLocationDictInPlist = [[NSMutableDictionary alloc]init];
//    [_myLocationDictInPlist setObject:applicationStatus forKey:@"applicationStatus"];
//    [_myLocationDictInPlist setObject:appState forKey:@"AppState"];
//    [_myLocationDictInPlist setObject:[NSDate date] forKey:@"Time"];
    
    [self saveLocationsToPlist];
}

- (void)saveLocationsToPlist {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString * idString = [prefs stringForKey:@"idForDoctorKey"];
    
    if (idString != 0) {
        NSLog(@"Send to Server: Latitude(%f) Longitude(%f) Accuracy(%f)",self.myLocation.latitude, self.myLocation.longitude,self.myLocationAccuracy);
        
       longString = [NSString stringWithFormat:@"%f",self.myLocation.longitude];
        latiString = [NSString stringWithFormat:@"%f",self.myLocation.latitude];
        
            
            //Putting All together**
            //To make the code block asynchronous
       // dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            //Background Thread
          //  dispatch_async(dispatch_get_main_queue(), ^(void){
                if([[Reachability sharedReachability] internetConnectionStatus] == NotReachable){
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Check Internet Connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av show];
                
                }else{
                    
                //NSString *longString = [NSString stringWithFormat:@"70.787163"];
                //NSString *latiString = [NSString stringWithFormat:@"22.275322"];
                //  NSString *longString = [NSString stringWithFormat:@"70.788888"];
                //  NSString *latiString = [NSString stringWithFormat:@"22.300222"];
                
                NSString *urlString = [[NSString alloc]initWithFormat:@"%@/doctorlocationupdate.php",DATABASEURL];
                NSURL *url = [NSURL URLWithString:urlString];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                
                NSString *myRequestString =[NSString stringWithFormat:@"{\"id\":\"%@\",\"latitude\":\"%@\",\"longitude\":\"%@\"}",idString,latiString,longString];
                
                NSLog(@"pass result ::%@",myRequestString);
                NSData *requestData = [NSData dataWithBytes:[myRequestString UTF8String] length:[myRequestString length]];
                [request setHTTPMethod: @"POST"];
                [request setHTTPBody: requestData];
              //  NSError *error;
              //  NSURLResponse *response;
                [NSURLConnection sendAsynchronousRequest:request
                                                       queue:[NSOperationQueue mainQueue]
                                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                               // ...
                                               if (error) {
                                                   NSLog(@"ERROR %@",error);
                                               }
                                               if (data) {
                                                   NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                   if (jsonDictionary) {
                                                       NSLog(@"jsonDictionary ==> %@", jsonDictionary);
                                                       
                                                       NSString *successtr = [[jsonDictionary valueForKey:@"posts"]valueForKey:@"Success"] ;
                                                       
                                                       NSInteger success = [successtr integerValue];
                                                       NSLog(@"log :%ld",(long)success);
                                                   }
                                                   else
                                                   {
                                                       NSLog(@"ERROR %@",error);
                                                   }
                                               }
                                              
                                               
                                               
                                           }];
                }
               /* NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                if(!urlData)
                {
                    
                }
                else
                {
                    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:nil];
                    
                    NSLog(@"jsonDictionary ==> %@", jsonDictionary);
                    
                    NSString *successtr = [[jsonDictionary valueForKey:@"posts"]valueForKey:@"Success"] ;
                    
                    NSInteger success = [successtr integerValue];
                    NSLog(@"log :%ld",(long)success);
                }
                    }*/
           // });
     // });
        
    }
}


@end
