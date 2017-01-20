//
//  DoctorMapView.h
//  DoctorApp
//
//  Created by isquare2 on 4/12/16.
//  Copyright © 2016 isquare2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DHeader.h"
#import "ServiceNSObject.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"
@import CoreLocation;
@interface DoctorMapView : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>
{
    AppDelegate *app;
    MBProgressHUD *hud;
    ServiceNSObject *jsonServiceNSObjectCall;
    CGFloat animateDistance;
    //CLLocationManager *locationManager;
    CLLocation *currentLocation;
    IBOutlet MKMapView *patientMap;
    IBOutlet UILabel *titleLab;
    
    NSIndexPath *indexPathOfTb;
}
-(IBAction)backBtnClickedOFMapV:(id)sender;
@property (nonatomic,retain) CLLocationManager *locationManager;



@end

