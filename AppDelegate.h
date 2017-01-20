//
//  AppDelegate.h
//  DoctorApp
//
//  Created by isquare2 on 4/7/16.
//  Copyright © 2016 isquare2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"
#import "LocationManager.h"
#import "AudioController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, retain) NSArray *pushNotificationArr, *copypushNotificationArr;
@property (strong, nonatomic) NSString *deviceTokenStr, *openChatStr;
@property (strong, retain) NSMutableDictionary *selectPatientDir;
@property (strong, retain) NSMutableArray *mapListArr;

@property(strong,nonatomic) NSArray *currentMedicationArray, *allergiesArr;
@property(strong,nonatomic) NSString *diagStr;
@property(strong,nonatomic) NSArray *medicationArr;
@property(strong,nonatomic) NSArray *billingArr, *billingIdArr;

@property(strong,nonatomic) NSString *currentMedicationStr,*GOChatStr, *GoChatRequestStr,*GoChatInTerminateStr, *openBookedStr, *BookedTerminatedStr, *GoBookingStr, *openChatRequestStr;

@property (strong, nonatomic) AudioController *audioController;

@property (strong,nonatomic) LocationManager * shareModel;

@property (nonatomic) NSTimer* locationUpdateTimer;
@end

