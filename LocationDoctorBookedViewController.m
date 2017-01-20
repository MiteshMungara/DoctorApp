//
//  LocationDoctorBookedViewController.m
//  PatientApp
//
//  Created by iSquare2 on 7/19/16.
//  Copyright © 2016 isquare2. All rights reserved.
//

#import "LocationDoctorBookedViewController.h"
#import "CustomAnnotation.h"
#import "CalloutAnnotation.h"
static CGFloat kMyCalloutOffset = 80.0;
@interface LocationDoctorBookedViewController ()
{
    UIImageView *AnnoimageView;
}
@end

@implementation LocationDoctorBookedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    //
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    //  [locationManager startUpdatingLocation];
    [locationManager startMonitoringSignificantLocationChanges];
    //
}
#pragma marl - Location
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation: currentLocation completionHandler: ^(NSArray *placemarks, NSError *error)
     {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         if (locatedAt.length==0)
         {
             [locationManager startMonitoringSignificantLocationChanges];
             // [locationManager startUpdatingLocation];
         }else{
             
         }
     }];
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == 2)
    {
        ALERT_VIEW(@"Start Location",@"Settings -> Privacy -> Location Services -> PatientApp")
        [locationManager startUpdatingLocation];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
     [super viewWillAppear:NO];
    [locationManager startUpdatingLocation];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getdListOfServer) userInfo:Nil repeats:NO];
}
-(void)getdListOfServer
{
    if([[Reachability sharedReachability] internetConnectionStatus] == NotReachable){
        ALERT_VIEW(@"",@"Check Internet Connection.")
    }else{
        @try
        {
            
            // NSString *pidStr = [[NSUserDefaults standardUserDefaults]valueForKey:@"idForPatientKey"];
            NSString *myRequestString =[NSString stringWithFormat:@"{\"bookingid\":\"%@\"}",[app.bookPatientDir valueForKey:@"b_id"]];
            jsonServiceNSObjectCall = [[ServiceNSObject alloc]init];
            NSDictionary *jsonDictionary =[jsonServiceNSObjectCall JsonPostServiceCall:[NSString stringWithFormat:@"%@/doctorcurrentlocation.php",DATABASEURL] PostTagSet:myRequestString];
            NSLog(@"jsonDictionary :%@",jsonDictionary);
            //[MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([[jsonDictionary valueForKey:@"Success"] isEqualToString:@"1"])
            {
                doctorArr = [[NSMutableArray alloc]init];
                doctorArr = [[jsonDictionary valueForKey:@"posts"]mutableCopy];
                [self showdoctorOnMap];
            }
        }@catch (NSException * e){}
    }
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(CompleMapProcess) userInfo:nil repeats:NO];
}


-(void)CompleMapProcess
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD allHUDsForView:self.view];
}
-(void)showdoctorOnMap
{
    @try{
        
        
        double miles = 5.0;
        double scalingFactor = ABS( (cos(2 * M_PI * locationManager.location.coordinate.latitude / 360.0) ));
        
        MKCoordinateSpan span;
        
        span.latitudeDelta = miles/69.0;
        span.longitudeDelta = miles/(scalingFactor * 69.0);
        
        MKCoordinateRegion region;
        region.span = span;
        region.center = locationManager.location.coordinate;
        
        // patientMap.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude), MKCoordinateSpanMake(0.09,0.09));
        
        
        
        NSNumber *latitude = [doctorArr valueForKey:@"Latitude"];
        NSNumber *longitude = [doctorArr valueForKey:@"Longitude"];
        
        NSString *title = [NSString stringWithFormat:@"%@^,##%@",[doctorArr valueForKey:@"DoctorName"],[doctorArr valueForKey:@"bookingid"]];
        
        //Create coordinates from the latitude and longitude values
        CLLocationCoordinate2D coord;
        coord.latitude = latitude.doubleValue;
        coord.longitude = longitude.doubleValue;
        
        CustomAnnotation *annotation = [[CustomAnnotation alloc] init];
        annotation.coordinate = coord;
        annotation.title = title;
        
        [patientMap addAnnotation:annotation];
        [patientMap setRegion:region animated:YES];
        
        
        [patientMap reloadInputViews];
    }@catch (NSException * e){}
}


- (MKAnnotationView *)mapView:(MKMapView *)mapview viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *customIdentifier  = @"CustomAnnotation";
    static NSString *calloutIdentifier = @"CalloutAnnotation";
    
    
    if ([annotation isKindOfClass:[CustomAnnotation class]]) {
        MKPinAnnotationView *view = (id)[patientMap dequeueReusableAnnotationViewWithIdentifier:customIdentifier];
        
        if (!view) {
            view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customIdentifier];
            
            
            view.canShowCallout       = NO;
            view.animatesDrop         = YES;
        } else {
            
            view.annotation = annotation;
        }
        NSString *professionStr = [doctorArr  valueForKey:@"HealthProfessionalType"];
        if ([professionStr isEqualToString:@"Osteopath"]) {
            AnnoimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png"]];
            
            AnnoimageView.frame = CGRectMake(-15, -4, 45, 62);
            view.animatesDrop = YES;
            view.canShowCallout = NO;
            
            view.calloutOffset = CGPointMake(-5, 5);
            [view addSubview:AnnoimageView];
        }
        else if ([professionStr isEqualToString:@"Medical Partitioner"])
        {
            AnnoimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blue-pin.png"]];
            
            AnnoimageView.frame = CGRectMake(-15, -4, 45, 62);
            view.animatesDrop = YES;
            view.canShowCallout = NO;
            
            view.calloutOffset = CGPointMake(-5, 5);
            [view addSubview:AnnoimageView];
        }
        else if ([professionStr isEqualToString:@"Aboriginal and Terres Strait Islander Health Practitioner"])
        {
            AnnoimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skyblue-pin.png"]];
            
            AnnoimageView.frame = CGRectMake(-15, -4, 45, 62);
            view.animatesDrop = YES;
            view.canShowCallout = NO;
            
            view.calloutOffset = CGPointMake(-5, 5);
            [view addSubview:AnnoimageView];
        }
        else if ([professionStr isEqualToString:@"Chinese Medicine Practitioner"])
        {
            AnnoimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red-pin.png"]];
            
            AnnoimageView.frame = CGRectMake(-15, -4, 45, 62);
            view.animatesDrop = YES;
            view.canShowCallout = NO;
            
            view.calloutOffset = CGPointMake(-5, 5);
            [view addSubview:AnnoimageView];
        }
        else if ([professionStr isEqualToString:@"Chiropractor"])
        {
            AnnoimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pink-pin.png"]];
            
            AnnoimageView.frame = CGRectMake(-15, -4, 45, 62);
            view.animatesDrop = YES;
            view.canShowCallout = NO;
            
            view.calloutOffset = CGPointMake(-5, 5);
            [view addSubview:AnnoimageView];
        }
        else if ([professionStr isEqualToString:@"Medical Partitioner"])
        {
            AnnoimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"green-pin.png"]];
            
            AnnoimageView.frame = CGRectMake(-15, -4, 45, 62);
            view.animatesDrop = YES;
            view.canShowCallout = NO;
            
            view.calloutOffset = CGPointMake(-5, 5);
            [view addSubview:AnnoimageView];
        }
        else if ([professionStr isEqualToString:@"Dental Practitioner"])
        {
            AnnoimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png"]];
            
            AnnoimageView.frame = CGRectMake(-15, -4, 45, 62);
            view.animatesDrop = YES;
            view.canShowCallout = NO;
            
            view.calloutOffset = CGPointMake(-5, 5);
            [view addSubview:AnnoimageView];
        }
        else if ([professionStr isEqualToString:@"Medical Radiation Practitioner"])
        {
            AnnoimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blue-pin.png"]];
            
            AnnoimageView.frame = CGRectMake(-15, -4, 45, 62);
            view.animatesDrop = YES;
            view.canShowCallout = NO;
            
            view.calloutOffset = CGPointMake(-5, 5);
            [view addSubview:AnnoimageView];
        }
        else if ([professionStr isEqualToString:@"Midwife"])
        {
            AnnoimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"green-pin.png"]];
            
            AnnoimageView.frame = CGRectMake(-15, -4, 45, 62);
            view.animatesDrop = YES;
            view.canShowCallout = NO;
            
            view.calloutOffset = CGPointMake(-5, 5);
            [view addSubview:AnnoimageView];
        }
        else if ([professionStr isEqualToString:@"Nurse"])
        {
            AnnoimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yellow-pin.png"]];
            
            AnnoimageView.frame = CGRectMake(-15, -4, 45, 62);
            view.animatesDrop = YES;
            view.canShowCallout = NO;
            
            view.calloutOffset = CGPointMake(-5, 5);
            [view addSubview:AnnoimageView];
        }
        else if ([professionStr isEqualToString:@"Occupational Therapistr"])
        {
            AnnoimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pink-pin.png"]];
            
            AnnoimageView.frame = CGRectMake(-15, -4, 45, 62);
            view.animatesDrop = YES;
            view.canShowCallout = NO;
            
            view.calloutOffset = CGPointMake(-5, 5);
            [view addSubview:AnnoimageView];
        }
        else if ([professionStr isEqualToString:@"Optometrist"])
        {
            AnnoimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red-pin.png"]];
            
            AnnoimageView.frame = CGRectMake(-15, -4, 45, 62);
            view.animatesDrop = YES;
            view.canShowCallout = NO;
            
            view.calloutOffset = CGPointMake(-5, 5);
            [view addSubview:AnnoimageView];
        }
        else if ([professionStr isEqualToString:@"Osteopath"])
        {
            AnnoimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blue-pin.png"]];
            
            AnnoimageView.frame = CGRectMake(-15, -4, 45, 62);
            view.animatesDrop = YES;
            view.canShowCallout = NO;
            
            view.calloutOffset = CGPointMake(-5, 5);
            [view addSubview:AnnoimageView];
        }
        else if ([professionStr isEqualToString:@"Pharmacist"])
        {
            AnnoimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skyblue-pin.png"]];
            
            AnnoimageView.frame = CGRectMake(-15, -4, 45, 62);
            view.animatesDrop = YES;
            view.canShowCallout = NO;
            
            view.calloutOffset = CGPointMake(-5, 5);
            [view addSubview:AnnoimageView];
        }
        else if ([professionStr isEqualToString:@"Physiotherapist"])
        {
            AnnoimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yellow-pin.png"]];
            
            AnnoimageView.frame = CGRectMake(-15, -4, 45, 62);
            view.animatesDrop = YES;
            view.canShowCallout = NO;
            
            view.calloutOffset = CGPointMake(-5, 5);
            [view addSubview:AnnoimageView];
        }
        else if ([professionStr isEqualToString:@"Podiatrist"])
        {
            AnnoimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red-pin.png"]];
            
            AnnoimageView.frame = CGRectMake(-15, -4, 45, 62);
            view.animatesDrop = YES;
            view.canShowCallout = NO;
            
            view.calloutOffset = CGPointMake(-5, 5);
            [view addSubview:AnnoimageView];
        }
        else if ([professionStr isEqualToString:@"Psychologist"])
        {
            AnnoimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"green-pin.png"]];
            
            AnnoimageView.frame = CGRectMake(-15, -4, 45, 62);
            view.animatesDrop = YES;
            view.canShowCallout = NO;
            
            view.calloutOffset = CGPointMake(-5, 5);
            [view addSubview:AnnoimageView];
        }
        else
        {
            AnnoimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"green-pin.png"]];
            
            AnnoimageView.frame = CGRectMake(-15, -4, 45, 62);
            view.animatesDrop = YES;
            view.canShowCallout = NO;
            
            view.calloutOffset = CGPointMake(-5, 5);
            [view addSubview:AnnoimageView];
        }
        
        
        
        return view;
    } else if ([annotation isKindOfClass:[CalloutAnnotation class]]) {
        MKAnnotationView *view = [patientMap dequeueReusableAnnotationViewWithIdentifier:calloutIdentifier];
        
        
        //if (!view) {
        id<MKAnnotation> ann = [[patientMap selectedAnnotations] objectAtIndex:0];
        
        // OR if you have custom annotation class with other properties...
        // (in this case may also want to check class of object first)
        
        
        NSLog(@"ann.title = %@", ann.title);
        
        NSString *idstr = [NSString stringWithFormat:@"%@^,##%@",[doctorArr valueForKey:@"DoctorName"],[doctorArr valueForKey:@"bookingid"]];
        if ([idstr isEqualToString:ann.title]) {
            NSLog(@"ann.title..... = %@ : id = %@", ann.title,idstr);
            view.annotation = annotation;
            view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:calloutIdentifier];
            CGSize size              = CGSizeMake(170.0, 70.0);
            view.frame               = CGRectMake(0.0, 0.0, size.width, size.height);
            view.backgroundColor     = [UIColor colorWithRed:(83/255.0) green:(83/255.0) blue:(83/255.0) alpha:1];
            view.layer.borderColor   = [UIColor blackColor].CGColor;
            view.layer.borderWidth   = 1;
            view.layer.cornerRadius  = 4;
            view.layer.shadowColor   = [UIColor blackColor].CGColor;
            view.layer.shadowOpacity = 0.5;
            view.layer.shadowRadius  = 5;
            view.layer.shadowOffset  = CGSizeMake(5, 5);
            
            UIButton *button         = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame             = CGRectMake(0.0, 0.0, 170.0, 70.0);
            [button setTitle:@"" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(didTouchUpInsideCalloutButton:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
            
            lblGratershow = [[UILabel alloc]  initWithFrame: CGRectMake ( 148, 20, 30 , 30)];
            lblGratershow.textColor = [UIColor whiteColor];
            lblGratershow.font =  [UIFont systemFontOfSize:22];
            lblGratershow.text=@">";
            [view addSubview:lblGratershow];
            
            lblnameshow = [[UILabel alloc]  initWithFrame: CGRectMake ( 8, 5, 150 , 20)];
            lblnameshow.textColor = [UIColor whiteColor];
            lblnameshow.font =  [UIFont systemFontOfSize:13];
            lblnameshow.text = [NSString stringWithFormat:@"Name: %@",[doctorArr valueForKey:@"DoctorName"]];
            [view addSubview:lblnameshow];
            
            
            lblDegree = [[UILabel alloc]  initWithFrame: CGRectMake ( 8, 26, 170 , 20)];
            lblDegree.textColor = [UIColor whiteColor];
            lblDegree.font =  [UIFont systemFontOfSize:12];
            lblDegree.text = [NSString stringWithFormat:@"Professinal: %@",[doctorArr valueForKey:@"Degree"]];
            [view addSubview:lblDegree];
            
            
            ratingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[doctorArr valueForKey:@"DoctorRating"]]]];
            
            
            ratingView.frame = CGRectMake( 8, 46, 100 , 19);
            
            [view addSubview:ratingView];
            
            
            
        }
        
        
        view.canShowCallout      = NO;
        view.centerOffset        = CGPointMake(0.0, -kMyCalloutOffset);
        
        return view;
    }
    
    return nil;
    
}

- (void)didTouchUpInsideCalloutButton:(UIButton *)sender {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, sender);
    
    id<MKAnnotation> ann = [[patientMap selectedAnnotations] objectAtIndex:0];
    
    //  NSString *idstr = [NSString stringWithFormat:@"%@^,##%@",[doctorArr valueForKey:@"Name"][i],[doctorArr valueForKey:@"d_id"][i]];
    //if ([idstr isEqualToString:ann.title]) {
    //   NSLog(@"ann.title..... = %@   %@", ann.title,idstr);
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, sender);
    
    for (int i =0 ; i < doctorArr.count; i++)
    {
        
        NSString *idstr = [NSString stringWithFormat:@"%@^,##%@",[doctorArr valueForKey:@"Name"][i],[doctorArr valueForKey:@"d_id"][i]];
        if ([idstr isEqualToString:ann.title]) {
            NSLog(@"ann.title..... = %@   %@", ann.title,idstr);
            app.bookPatientDir = [[NSMutableDictionary alloc]init];
            [app.bookPatientDir setObject:[doctorArr valueForKey:@"d_id"][i] forKey:@"d_id"];
            [app.bookPatientDir setObject:[doctorArr valueForKey:@"Name"][i] forKey:@"Name"];
            [app.bookPatientDir setObject:[doctorArr valueForKey:@"b_id"][i] forKey:@"b_id"];
            [app.bookPatientDir setObject:[doctorArr valueForKey:@"book_status"][i] forKey:@"book_status"];
            [app.bookPatientDir setObject:[doctorArr valueForKey:@"Patient_paypal_allow"][i] forKey:@"PaypalAllow"];
            NSLog(@"%@",app.bookPatientDir);
            
        }
    }
    
    [app.bookPatientDir setObject:[doctorArr valueForKey:@"DoctorID"] forKey:@"d_id"];
    
    
    //}
    [self performSegueWithIdentifier:@"PatientProfessionalViewController" sender:self];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[CustomAnnotation class]]) {
        CalloutAnnotation *calloutAnnotation = [[CalloutAnnotation alloc] initForAnnotation:view.annotation];
        [mapView addAnnotation:calloutAnnotation];
        dispatch_async(dispatch_get_main_queue(), ^{
            [mapView selectAnnotation:calloutAnnotation animated:YES];
        });
    }
}



// when user deselects annotation (i.e. taps elsewhere), remove the callout annotation if any

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[CalloutAnnotation class]]) {
        [patientMap removeAnnotation:view.annotation];
    }
}
- (void)zoomToLocation
{
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in patientMap.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [patientMap setVisibleMapRect:zoomRect animated:YES];
    
    
    
}
- (void)dealloc {
    [self setMapMemory];
    [super dealloc];
}
-(void)setMapMemory
{
    
    patientMap.showsUserLocation = NO;
    [patientMap.layer removeAllAnimations];
    [patientMap removeAnnotations:patientMap.annotations];
    patientMap = nil;
}
-(IBAction)BackBtnClickedOfCLV:(id)sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

#pragma mark - Stop
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
