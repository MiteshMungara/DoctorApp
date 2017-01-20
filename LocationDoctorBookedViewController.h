//
//  LocationDoctorBookedViewController.h
//  PatientApp
//
//  Created by iSquare2 on 7/19/16.
//  Copyright © 2016 isquare2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PHeader.h"
#import "ServiceNSObject.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"
#import "AsyncImageView.h"
#import "ProfessionalView.h"


@interface LocationDoctorBookedViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>
{
    AppDelegate *app;
    MBProgressHUD *hud;
    ServiceNSObject *jsonServiceNSObjectCall;
    CGFloat animateDistance;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    IBOutlet MKMapView *patientMap;
    IBOutlet UILabel *titleLab;
    
    
    AsyncImageView *asyncimg;
    CGRect imgRect11;
    
    NSString *proNameStr;
    NSMutableArray *doctorArr;
    //MepView
    UILabel *lblGratershow;
    UILabel *lblnameshow;
    UILabel *lblDegree;
    UIImageView *ratingView;
}

-(IBAction)BackBtnClickedOfCLV:(id)sender;

@end
