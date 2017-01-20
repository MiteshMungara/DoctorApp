//
//  DoctorMapView.m
//  DoctorApp
//
//  Created by isquare2 on 4/12/16.
//  Copyright © 2016 isquare2. All rights reserved.
//
double degrees = 0;
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#import "DoctorMapView.h"
#import "CustomAnnotation.h"
#import "CalloutAnnotation.h"
static CGFloat kMyCalloutOffset = 80.0;
@interface DoctorMapView ()
{
    MKPinAnnotationView *Pinview;
    MKAnnotationView *Annoview;
    CustomAnnotation *CustomeAnnotation;
    UIImageView *AnnoimageView;
    UILabel *lblnameshow, *lblDegree;
}
@end

@implementation DoctorMapView
@synthesize locationManager;


- (void)viewDidLoad
{
    [super viewDidLoad];
    app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //    locationManager = [[CLLocationManager alloc] init];
    //    locationManager.delegate = self;
    //    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
    //        [locationManager requestWhenInUseAuthorization];
    //    }
    //       [locationManager startUpdatingLocation];
    // [locationManager requestWhenInUseAuthorization];
    // [locationManager requestAlwaysAuthorization];
    
    
}

//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//   [patientMap setRegion:MKCoordinateRegionMake(patientMap.userLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01)) animated:NO];
//}


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
             //[patientMap setRegion:MKCoordinateRegionMake(patientMap.userLocation.coordinate, MKCoordinateSpanMake(0.3, 0.3)) animated:NO];
             [locationManager startUpdatingLocation];
             //[locationManager startMonitoringSignificantLocationChanges];
         }else{
             
         }
     }];
}


//
//- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
//{
//    CLLocationDirection heading = newHeading.magneticHeading;
// //   self.textField.text = [NSString stringWithFormat:@"%.2f", heading];
//    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
//    MKAnnotationView *annotationView = [patientMap dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
//
//    UIImageView *pin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0.png"]];
//        pin.transform = CGAffineTransformMakeRotation((degrees-newHeading.trueHeading) * M_PI / 180);
//
//    //[annotationView setTransform:CGAffineTransformMakeRotation(heading)];
//}
//


//
//-(void) calculateUserAngle:(CLLocationCoordinate2D)current {
//    double x = 0, y = 0 , deg = 0,delLon = 0;
//    float fixLon = 72.829742;
//    float fixLat =21.188813;
//    delLon = fixLon - current.longitude;
//    y = sin(delLon) * cos(fixLat);
//    x = cos(current.latitude) * sin(fixLat) - sin(current.latitude) * cos(fixLat) * cos(delLon);
//    deg = RADIANS_TO_DEGREES(atan2(y, x));
//
//    if(deg<0){
//        deg = -deg;
//    } else {
//        deg = 360 - deg;
//    }
//    degrees = deg;
//}
//
//
//-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
//
//    CLLocationCoordinate2D here =  newLocation.coordinate;
//    [self calculateUserAngle:here];
//}
//
//
//- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
//{
//    UIImageView *pin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-car01.png"]];
//    pin.transform = CGAffineTransformMakeRotation((degrees-newHeading.trueHeading) * M_PI / 180);
//    NSLog(@"Rotation: %f",(degrees-newHeading.trueHeading) * M_PI / 180);
//}
//


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == 2)
    {
        ALERT_VIEW(@"Start Location",@"Settings -> Privacy -> Location Services -> DoctorApp")
        [locationManager startUpdatingLocation];
        // [locationManager startMonitoringSignificantLocationChanges];
    }
}



-(void)viewWillAppear:(BOOL)animated
{
        [super viewWillAppear:NO];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    patientMap.showsUserLocation=YES;
    patientMap.showsBuildings = YES;
    //[locationManager startMonitoringSignificantLocationChanges];
    [locationManager startUpdatingLocation];
    if (app.mapListArr) {
        
        [self showpatientOnMap];
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:(BOOL)animated];
    
    NSInteger toRemoveCount = patientMap.annotations.count;
    NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:toRemoveCount];
    for (id annotation in patientMap.annotations)
        if (annotation != patientMap.userLocation)
            [toRemove addObject:annotation];
    [patientMap removeAnnotations:toRemove];
    [patientMap removeFromSuperview];
    
    [Annoview removeFromSuperview];
    [Pinview  removeFromSuperview];
    Pinview = nil;
    CustomeAnnotation = nil;
    [self.view removeFromSuperview];
    //[self removeAllPinsButUserLocation2];
}

-(void)showpatientOnMap
{
    if(!patientMap)
    {
        patientMap = [[MKMapView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    @try{
        
        float longitudeFloat, latitudeFloat;
        CLLocationCoordinate2D theCoordinate1;
        //
        
        double miles = 5.0;
        double scalingFactor = ABS( (cos(2 * M_PI * locationManager.location.coordinate.latitude / 360.0) ));
        
        MKCoordinateSpan span;
        
        span.latitudeDelta = miles/69.0;
        span.longitudeDelta = miles/(scalingFactor * 69.0);
        
        MKCoordinateRegion region;
        region.span = span;
        region.center = locationManager.location.coordinate;
        
        
        // patientMap.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude), MKCoordinateSpanMake(0.09,0.09));
        
        NSLog(@"%@",app.mapListArr);
        for (int i=0;i<app.mapListArr.count; i++)
        {
            NSString *lonStr =[NSString stringWithFormat:@"%@",[app.mapListArr valueForKey:@"Longitude"][i]];
            //;
            NSString *latStr =[NSString stringWithFormat:@"%@",[app.mapListArr valueForKey:@"Latitiude"][i]]; //;
            
            longitudeFloat = [lonStr floatValue];
            latitudeFloat = [latStr floatValue];
            
            theCoordinate1.latitude =latitudeFloat;
            theCoordinate1.longitude =longitudeFloat;
            
            
            
            
            CustomeAnnotation = [[CustomAnnotation alloc] init];
            CustomeAnnotation.coordinate = theCoordinate1;
            // CustomeAnnotation.title = [NSString stringWithFormat:@"Cool"];
            CustomeAnnotation.title = [NSString stringWithFormat:@"%@ %@^,##%@",[app.mapListArr valueForKey:@"FirstName"][i],[app.mapListArr valueForKey:@"Surname"][i],[app.mapListArr valueForKey:@"PatientID"][i]];
            
            [patientMap addAnnotation:CustomeAnnotation];
            [patientMap setRegion:region animated:NO];
            
            
            //[patientMap setRegion:patientMap.region animated:YES];
        }
        [self.view addSubview:patientMap];
        //[patientMap reloadInputViews];
    }@catch (NSException * e){}
    
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(StopLoad) userInfo:nil repeats:NO];
}


-(void)StopLoad
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapview viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *customIdentifier  = @"CustomAnnotation";
    static NSString *calloutIdentifier = @"CalloutAnnotation";
    
    
    if ([annotation isKindOfClass:[CustomAnnotation class]]) {
        // MKPinAnnotationView *
        Pinview = (id)[patientMap dequeueReusableAnnotationViewWithIdentifier:customIdentifier];
        
        if (!Pinview) {
            Pinview = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customIdentifier];
            
            
            Pinview.canShowCallout       = NO;
            Pinview.animatesDrop         = YES;
        } else {
            
            Pinview.annotation = annotation;
        }
        
        AnnoimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0.png"]];
        
        AnnoimageView.frame = CGRectMake(-15, -4, 45, 62);
        Pinview.animatesDrop = YES;
        Pinview.canShowCallout = NO;
        
        Pinview.calloutOffset = CGPointMake(-5, 5);
        [Pinview addSubview:AnnoimageView];
        
        
        return Pinview;
    }
    else if ([annotation isKindOfClass:[CalloutAnnotation class]]) {
        Annoview = [patientMap dequeueReusableAnnotationViewWithIdentifier:calloutIdentifier];
        
        
        //if (!view) {
        id<MKAnnotation> ann = [[patientMap selectedAnnotations] objectAtIndex:0];
        
        // OR if you have custom annotation class with other properties...
        // (in this case may also want to check class of object first)
        
        
        NSLog(@"ann.title = %@", ann.title);
        for (int i =0 ; i < app.mapListArr.count; i++)
        {
            NSString *idstr = [NSString stringWithFormat:@"%@ %@^,##%@",[app.mapListArr valueForKey:@"FirstName"][i],[app.mapListArr valueForKey:@"Surname"][i],[app.mapListArr valueForKey:@"PatientID"][i]];
            
            if ([idstr isEqualToString:ann.title]) {
                NSLog(@"ann.title..... = %@ : id = %@", ann.title,idstr);
                Annoview.annotation = annotation;
                Annoview = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:calloutIdentifier];
                CGSize size              = CGSizeMake(170.0, 80.0);
                Annoview.frame               = CGRectMake(0.0, 0.0, size.width, size.height);
                Annoview.backgroundColor     = [UIColor colorWithRed:(83/255.0) green:(83/255.0) blue:(83/255.0) alpha:1] ;
                Annoview.layer.borderColor   = [UIColor blackColor].CGColor;
                Annoview.layer.borderWidth   = 1;
                Annoview.layer.cornerRadius  = 4;
                Annoview.layer.shadowColor   = [UIColor blackColor].CGColor;
                Annoview.layer.shadowOpacity = 0.5;
                Annoview.layer.shadowRadius  = 5;
                Annoview.layer.shadowOffset  = CGSizeMake(5, 5);
                UIButton *button         = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                button.frame             = CGRectMake(0.0, 0.0, 170.0, 80.0);
                [button setTitle:@"" forState:UIControlStateNormal];
                [button addTarget:self action:@selector(didTouchUpInsideCalloutButton:) forControlEvents:UIControlEventTouchUpInside];
                [Annoview addSubview:button];
                UILabel *lblGratershow = [[UILabel alloc]  initWithFrame: CGRectMake ( 148, 20, 30 , 30)];
                lblGratershow.textColor = [UIColor whiteColor];
                lblGratershow.font =  [UIFont systemFontOfSize:22];
                lblGratershow.text=@">";
                [Annoview addSubview:lblGratershow];
                lblnameshow = [[UILabel alloc]  initWithFrame: CGRectMake ( 8, 5, 150 , 20)];
                lblnameshow.textColor = [UIColor whiteColor];
                lblnameshow.font =  [UIFont systemFontOfSize:13];
                lblnameshow.text = [NSString stringWithFormat:@"Name: %@ %@",[app.mapListArr valueForKey:@"FirstName"][i],[app.mapListArr valueForKey:@"Surname"][i]];
                [Annoview addSubview:lblnameshow];
                
                
                lblDegree = [[UILabel alloc]  initWithFrame: CGRectMake ( 8, 26, 170 , 20)];
                //                lblDegree.textColor = [UIColor whiteColor];
                //                lblDegree.font =  [UIFont systemFontOfSize:12];
                //                lblDegree.text = [NSString stringWithFormat:@"Symptomes: %@",[app.mapListArr valueForKey:@"Symptoms"][i]];
                //                [view addSubview:lblDegree];
                //
                //
                //                UILabel *lbldetail = [[UILabel alloc] initWithFrame:CGRectMake( 8, 38, 130 ,70)];
                lblDegree.text = [NSString stringWithFormat:@"Symptomes: %@",[app.mapListArr valueForKey:@"Symptoms"][i]];
                
                lblDegree.textColor = [UIColor whiteColor];
                lblDegree.font =  [UIFont systemFontOfSize:12];
                
                lblDegree.numberOfLines = 0;
                lblDegree.lineBreakMode = NSLineBreakByWordWrapping;
                
                [Annoview addSubview:lblDegree];
                
            }
            
        }
        
        
        Annoview.canShowCallout      = NO;
        Annoview.centerOffset        = CGPointMake(0.0, -kMyCalloutOffset);
        
        return Annoview;
    }
    
    return nil;
    
}
- (void)didTouchUpInsideCalloutButton:(UIButton *)sender {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, sender);
    
    id<MKAnnotation> ann = [[patientMap selectedAnnotations] objectAtIndex:0];
    for (int i =0 ; i < app.mapListArr.count; i++)
    {
        NSString *idstr = [NSString stringWithFormat:@"%@ %@^,##%@",[app.mapListArr valueForKey:@"FirstName"][i],[app.mapListArr valueForKey:@"Surname"][i],[app.mapListArr valueForKey:@"PatientID"][i]];
        
        if ([idstr isEqualToString:ann.title]) {
            NSLog(@"ann.title..... = %@   %@", ann.title,idstr);
            
            app.selectPatientDir = [[app.mapListArr objectAtIndex:i]mutableCopy];
            [self performSegueWithIdentifier:@"ProfessionalView" sender:self];
            
        }
    }
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



//
//- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
//    double heading = newHeading.trueHeading; //in degree relative to true north
//    double bearing = ... //get current bearing in degree relative to true north
//    //with the JS library mentioned below it would be something like
//    //bearing = userLoc.bearingTo(destionation);
//
//    //just two lines, the the sake of the example
//    double rotationInDegree = (bearing - heading);  //the important line
//    rotationInDegree = fmod((rotationInDegree + 360), 360);  //just to be on the safe side :-)
//    compassViewPerhapsAsImage.transform=CGAffineTransformMakeRotation(DegreesToRadians(rotationInDegree));
//}

/*- (MKAnnotationView *)mapView:(MKMapView *)mapview viewForAnnotation:(id <MKAnnotation>)annotation
 {
 @try{
 if ([annotation isKindOfClass:[MKUserLocation class]])
 return nil;
 static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
 MKAnnotationView *annotationView = [patientMap dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
 if(annotationView){
 [patientMap.userLocation setTitle:@"I am here"];
 return annotationView;
 }
 else
 {
 MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
 
 annotationView.canShowCallout = YES;
 annotationView.image = [UIImage imageNamed:@"0.png"];
 [annotationView setFrame:CGRectMake(0,0, 23, 32)];
 
 NSString *Str = [[NSString alloc]init];
 Str =annotation.title;
 NSString *atStr = [[NSString alloc]initWithFormat:@"%@",[Str componentsSeparatedByString:@"^,##"][0]];
 NSString *btStr = [[NSString alloc]initWithFormat:@"%@",[Str componentsSeparatedByString:@"^,##"][1]];
 //set Title
 [annotation setTitle:atStr];
 
 UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
 [rightButton addTarget:self action:@selector(clickedMapBtn:) forControlEvents:UIControlEventTouchUpInside];
 [rightButton setTitle:btStr forState:UIControlStateNormal];
 annotationView.rightCalloutAccessoryView = rightButton;
 
 annotationView.canShowCallout = YES;
 annotationView.draggable = YES;
 return annotationView;
 }
 }@catch (NSException * e){
 return nil;
 }
 }*/
//-(void)clickedMapBtn:(id)sender
//{
//    NSString *pidStr = ((UIButton*)sender).currentTitle;
//    int indexValue = (int)[[app.mapListArr valueForKey:@"PatientID"] indexOfObject:pidStr];
//    NSLog(@"doctorArr :%@",[app.mapListArr objectAtIndex:indexValue]);
//    app.selectPatientDir = [[app.mapListArr objectAtIndex:indexValue]mutableCopy];
//    [self performSegueWithIdentifier:@"ProfessionalView" sender:self];
//}


#pragma mark - Button Action
-(IBAction)backBtnClickedOFMapV:(id)sender
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
