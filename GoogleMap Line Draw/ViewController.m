//
//  ViewController.m
//  GmapDemo
//
//  Created by iSquare2 on 8/1/16.
//  Copyright © 2016 MitsSoft. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()
{
    
    BOOL _firstLocationUpdate;
    GMSMapView *mapView;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
                                                            longitude:151.2086
                                                                 zoom:12];
    
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.mapType=kGMSTypeNormal;
    mapView.settings.compassButton = YES;
    mapView.settings.myLocationButton = YES;
    
    mapView.myLocationEnabled=YES;
    // Listen to the myLocation property of GMSMapView.
    [mapView addObserver:self
              forKeyPath:@"myLocation"
                 options:NSKeyValueObservingOptionNew
                 context:NULL];
    
    

    [mapView setMinZoom:3 maxZoom:18];
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView.myLocationEnabled = YES;
    });
     mapView.padding = UIEdgeInsetsMake(self.TopLabel.frame.size.height + 5, 0, self.BottomLabel.frame.size.height + 5, 0);
     self.view=mapView;
    
    
    //Draw Single Line
   /* GMSMutablePath *singleLinePath = [[GMSMutablePath alloc]init];
    [singleLinePath addLatitude:22.306621 longitude:70.798398];
    [singleLinePath addLatitude:22.303028 longitude:70.803055];
    
    GMSPolyline *singleLine = [GMSPolyline polylineWithPath:singleLinePath];
    singleLine.strokeWidth = 5;
    singleLine.strokeColor = [UIColor blackColor];
    singleLine.map = mapView;*/
    
    //GMS Polugone to Draw the shap
    /*GMSMutablePath *singleLinePath = [[GMSMutablePath alloc]init];
    [singleLinePath addLatitude:22.306621 longitude:70.798398];
    [singleLinePath addLatitude:22.303028 longitude:70.803055];
    [singleLinePath addLatitude:22.302512 longitude:70.800523];
    [singleLinePath addLatitude:22.302015 longitude:70.797883];
    
   
    GMSPolygon *shap = [GMSPolygon polygonWithPath:singleLinePath];
    shap.strokeColor = [UIColor blueColor];
    shap.strokeWidth = 5;
    shap.fillColor = [UIColor yellowColor];
    shap.map = mapView;*/
    
    
    // Place sample marker to the map.
   /* NSArray *sampleMarkerLocations = [[NSArray alloc] initWithObjects: [[CLLocation alloc] initWithLatitude:22.306621 longitude:70.798398],
                                      [[CLLocation alloc] initWithLatitude:22.303028 longitude:70.803055],
                                      [[CLLocation alloc] initWithLatitude:22.302512 longitude:70.800523],
                                      [[CLLocation alloc] initWithLatitude:22.302015 longitude:70.797883], nil];
    
    NSUInteger index = 0;
    for (CLLocation *sampleMarkerLocation in sampleMarkerLocations)
    {
        // Initialize the marker.
        GMSMarker *marker = [GMSMarker markerWithPosition:sampleMarkerLocation.coordinate];
        
       
           
                marker.icon = [GMSMarker markerImageWithColor:[UIColor colorWithWhite:0.2 alpha:1.0]];
                marker.snippet = @"I am not draggable!";
               
                    // Add the marker to the map.
        marker.map = mapView;
        index++;
    }
*/
    
}


-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)dealloc {
    [mapView removeObserver:self
                 forKeyPath:@"myLocation"
                    context:NULL];
}

#pragma mark - KVO updates

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!_firstLocationUpdate) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        _firstLocationUpdate = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                        zoom:14];
    }
}



@end
