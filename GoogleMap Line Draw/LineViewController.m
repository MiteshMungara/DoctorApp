//
//  LineViewController.m
//  GmapDemo
//
//  Created by iSquare2 on 8/6/16.
//  Copyright © 2016 MitsSoft. All rights reserved.
//

#import "LineViewController.h"

@interface LineViewController () <GMSMapViewDelegate>
{
   
    BOOL _firstLocationUpdate;
}
@property(strong,nonatomic) NSURLSession *markerSession;
@property(strong,nonatomic) GMSMapView *mapView;

@property(strong,nonatomic) GMSPolyline *polyline;

@property(strong,nonatomic) UIButton *directionsButton;
@end

@implementation LineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
                                                            longitude:151.2086
                                                                 zoom:12];
    
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.mapType=kGMSTypeNormal;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    
    self.mapView.myLocationEnabled=YES;
    // Listen to the myLocation property of GMSMapView.
    [self.mapView addObserver:self
              forKeyPath:@"myLocation"
                 options:NSKeyValueObservingOptionNew
                 context:NULL];
    
    
    
    [self.mapView setMinZoom:3 maxZoom:18];
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mapView.myLocationEnabled = YES;
    });
    
    // Listen to the myLocation property of GMSMapView.
//    [self.mapView addObserver:self
//              forKeyPath:@"myLocation"
//                 options:NSKeyValueObservingOptionNew
//                 context:NULL];
    
    
    
    [self.mapView setMinZoom:3 maxZoom:18];
//    // Ask for My Location data after the map has already been added to the UI.
//    dispatch_async(dispatch_get_main_queue(), ^{
//          self.mapView.myLocationEnabled = YES;
//    });
  
    self.mapView.delegate = self;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.URLCache = [[NSURLCache alloc]initWithMemoryCapacity:2 * 1024 * 1024 diskCapacity:10 * 1024 * 1024 diskPath:@"MakerData"];
    
    self.markerSession = [NSURLSession sessionWithConfiguration:config];
    
    self.directionsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.directionsButton.alpha= 1.0;
    
   // UITapGestureRecognizer *touchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTouchTap:)];
   // [self.view addGestureRecognizer:touchTap];
    
    NSArray *sampleMarkerLocations = [[NSArray alloc] initWithObjects: [[CLLocation alloc] initWithLatitude:22.311127 longitude:70.798860],
                                      [[CLLocation alloc] initWithLatitude:22.303028 longitude:70.803055],
                                      [[CLLocation alloc] initWithLatitude:22.305926 longitude:70.808880],
                                      [[CLLocation alloc] initWithLatitude:22.302015 longitude:70.794289], nil];
    
    NSUInteger index = 0;
    for (CLLocation *sampleMarkerLocation in sampleMarkerLocations)
    {
        // Initialize the marker.
     GMSMarker *marker;
        marker = [GMSMarker markerWithPosition:sampleMarkerLocation.coordinate];
        
        
        
        marker.icon = [GMSMarker markerImageWithColor:[UIColor colorWithWhite:0.2 alpha:1.0]];
        marker.snippet = @"I am here.!";
        
        // Add the marker to the map.
        marker.map = self.mapView;
        index++;
    }
     self.view=self.mapView;
}
//-(void)tapTouchTap:(UITapGestureRecognizer*)touchGesture
//{
   // CGPoint point = [touchGesture locationInView:self.view];
   // CLLocationCoordinate2D coord = [self.mapView.projection coordinateForPoint:point];
  //  NSLog(@"%f %f", coord.latitude, coord.longitude);
//}
//-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(nonnull GMSMarker *)marker
//{
//    
//}

- (void)mapView:(GMSMapView *)mapView
didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
}

-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
   
    if (self.mapView.myLocation != nil) {
        
        self.polyline.map = nil;
        self.polyline =nil;
        NSLog(@"%f",marker.position.longitude);
        NSLog(@"%f",marker.position.latitude);
        //float longitute = 70.798398;
        //float latitude = 22.306621;
        NSString *urlString = [NSString stringWithFormat:@"%@?origin=%f,%f&destination=%f,%f&sensor=true&key=%@",@"https://maps.googleapis.com/maps/api/directions/json",mapView.myLocation.coordinate.latitude,mapView.myLocation.coordinate.longitude,marker.position.latitude,marker.position.longitude,@"AIzaSyBgJ3wq_LOLNgQwH6ni2idbgbkfF0dSiJM"];
        // NSString *urlString = [NSString stringWithFormat:@"%@?origin=%f,%f&destination=%f,%f&sensor=true&key=%@",@"https://maps.googleapis.com/maps/api/directions/json",mapView.myLocation.coordinate.latitude,mapView.myLocation.coordinate.longitude,marker.position.latitude,marker.position.longitude,@"AIzaSyBjPM-dfAnEJkBVMr-NxSObHR2pfaar4v8"];
        NSURL *directionURL = [NSURL URLWithString:urlString];
        
        NSURLSessionDataTask *directionsTask = [self.markerSession dataTaskWithURL:directionURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *e) {
            NSError *error =nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (!error) {
                
                
                NSDictionary *steps = [json objectForKey:@"routes"][0][@"legs"][0][@"steps"][0];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    GMSPath *path = [GMSPath pathFromEncodedPath:json[@"routes"][0][@"overview_polyline"][@"points"]];
                    self.polyline = [GMSPolyline polylineWithPath:path];
                    self.polyline.strokeWidth = 5;
                    self.polyline.strokeColor = [UIColor blackColor];
                    self.polyline.map = self.mapView;
                }];
                
            }
            
        }];
        [directionsTask resume];
        
        
    }
    return YES;
}
/*- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
    if (self.mapView.myLocation != nil) {
        
        self.polyline.map = nil;
        self.polyline =nil;
        
        //float longitute = 70.798398;
        //float latitude = 22.306621;
        NSString *urlString = [NSString stringWithFormat:@"%@?origin=%f,%f&destination=%f,%f&sensor=true&key=%@",@"https://maps.googleapis.com/maps/api/directions/json",mapView.myLocation.coordinate.latitude,mapView.myLocation.coordinate.longitude,coordinate.latitude,coordinate.longitude,@"AIzaSyBgJ3wq_LOLNgQwH6ni2idbgbkfF0dSiJM"];
        // NSString *urlString = [NSString stringWithFormat:@"%@?origin=%f,%f&destination=%f,%f&sensor=true&key=%@",@"https://maps.googleapis.com/maps/api/directions/json",mapView.myLocation.coordinate.latitude,mapView.myLocation.coordinate.longitude,marker.position.latitude,marker.position.longitude,@"AIzaSyBjPM-dfAnEJkBVMr-NxSObHR2pfaar4v8"];
        NSURL *directionURL = [NSURL URLWithString:urlString];
        
        NSURLSessionDataTask *directionsTask = [self.markerSession dataTaskWithURL:directionURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *e) {
            NSError *error =nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (!error) {
                
                
                NSDictionary *steps = [json objectForKey:@"routes"][0][@"legs"][0][@"steps"][0];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    GMSPath *path = [GMSPath pathFromEncodedPath:json[@"routes"][0][@"overview_polyline"][@"points"]];
                    self.polyline = [GMSPolyline polylineWithPath:path];
                    self.polyline.strokeWidth = 5;
                    self.polyline.strokeColor = [UIColor blackColor];
                    self.polyline.map = self.mapView;
                }];
               
            }
            
        }];
        [directionsTask resume];
        
        
    }
}
*/
- (void)dealloc {
    [self.mapView removeObserver:self
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
        self.mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                        zoom:14];
    }
}

//
//- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
//   // [self fadeMarker:marker];
//    return YES;
//}
//
//- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
//    //[self fadeMarker:nil];
//}

//
//
-(void)directionTapped:(id)sender
{
       // DirectionsListVC *
    
    /*
     https://developers.google.com/maps/documentation/ios-sdk/marker
     
     CLLocationCoordinate2D position = CLLocationCoordinate2DMake(10, 10);
     GMSMarker *marker = [GMSMarker markerWithPosition:position];
     marker.title = @"Hello World";
     marker.map = mapView;
     \
     
     Remove a marker
     GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.8683
     longitude:151.2086
     zoom:6];
     mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
     ...
     [mapView clear];
     
     
     
     If you wish to make modifications to a marker after you've added it to the map, ensure that you keep hold of the GMSMarker object. You can modify the marker later by making changes to this object.
     
     GMSMarker *marker = [GMSMarker markerWithPosition:position];
     marker.map = mapView;
     ...
     marker.map = nil
     
     
     Change the marker color
     
     You can customize the color of the default marker image by requesting a tinted version of the default icon with markerImageWithColor:, and passing the resulting image to the GMSMarker's icon property
     
     
     marker.icon = [GMSMarker markerImageWithColor:[UIColor blackColor]];
     
     
     Customize the marker image
     
     If you want to change the default marker image you can set a custom icon, using the marker's icon or iconView property.
     
     If iconView is set, the API ignores the icon property. Updates to the current icon are not recognised as long as the iconView is set.
     
     Use the marker's icon property
     
     The following snippet creates a marker with a custom icon provided as a UIImage in the icon property. The icon is centered at London, England. The snippet assumes that your application contains an image named "house.png".
     
     CLLocationCoordinate2D position = CLLocationCoordinate2DMake(51.5, -0.127);
     GMSMarker *london = [GMSMarker markerWithPosition:position];
     london.title = @"London";
     london.icon = [UIImage imageNamed:@"house"];
     london.map = mapView;
     
     Use the marker's iconView property
     
     The following snippet creates a marker with a custom icon by setting the marker's iconView property, and animates a change in the color of the marker. The snippet assumes that your application contains an image named "house.png"
     
     #import "ViewController.h"
     @import GoogleMaps;
     
     @interface ViewController () <GMSMapViewDelegate>
     @property (strong, nonatomic) IBOutlet GMSMapView *mapView;
     @end
     
     @implementation ViewController {
     GMSMarker *_london;
     UIImageView *_londonView;
     }
     
     - (void)viewDidLoad {
     [super viewDidLoad];
     
     _mapView.delegate = self;
     
     UIImage *house = [UIImage imageNamed:@"House"];
     house = [house imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
     _londonView = [[UIImageView alloc] initWithImage:house];
     _londonView.tintColor = [UIColor redColor];
     
     CLLocationCoordinate2D position = CLLocationCoordinate2DMake(51.5, -0.127);
     _london = [GMSMarker markerWithPosition:position];
     _london.title = @"London";
     _london.iconView = _londonView;
     _london.tracksViewChanges = YES;
     _london.map = self.mapView;
     }
     
     - (void)mapView:(GMSMapView *)mapView
     idleAtCameraPosition:(GMSCameraPosition *)position {
     [UIView animateWithDuration:5.0
     animations:^{
     _londonView.tintColor = [UIColor blueColor];
     }
     completion:^(BOOL finished) {
     // Stop tracking view changes to allow CPU to idle.
     _london.tracksViewChanges = NO;
     }];
     }
     
     @end
     
     
     
     Markers
     
     Markers indicate single locations on the map.
     
     By default, markers use a standard icon that has the common Google Maps look and feel. If you want to customize your marker, you can change the color of the default marker, or replace the marker image with a custom icon, or change other properties of the marker.
     
     Add a marker
     
     To add a marker, create a GMSMarker object that includes a position and title, and set its map.
     
     The following example demonstrates how to add a marker to an existing GMSMapView object. The marker is created at coordinates 10,10, and displays the string "Hello world" in an info window when clicked.
     
     OBJECTIVE-CSWIFT
     CLLocationCoordinate2D position = CLLocationCoordinate2DMake(10, 10);
     GMSMarker *marker = [GMSMarker markerWithPosition:position];
     marker.title = @"Hello World";
     marker.map = mapView;
     You can animate the addition of new markers to the map by setting the marker.appearAnimation property to kGMSMarkerAnimationPop.
     
     Remove a marker
     
     You can remove a marker from the map by setting the map property of the GMSMarker to nil. Alternatively, you can remove all of the overlays (including markers) currently on the map by calling the GMSMapView clear method.
     
     OBJECTIVE-CSWIFT
     GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.8683
     longitude:151.2086
     zoom:6];
     mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
     ...
     [mapView clear];
     If you wish to make modifications to a marker after you've added it to the map, ensure that you keep hold of the GMSMarker object. You can modify the marker later by making changes to this object.
     
     OBJECTIVE-CSWIFT
     GMSMarker *marker = [GMSMarker markerWithPosition:position];
     marker.map = mapView;
     ...
     marker.map = nil
     Change the marker color
     
     You can customize the color of the default marker image by requesting a tinted version of the default icon with markerImageWithColor:, and passing the resulting image to the GMSMarker's icon property.
     
     OBJECTIVE-CSWIFT
     marker.icon = [GMSMarker markerImageWithColor:[UIColor blackColor]];
     Customize the marker image
     
     If you want to change the default marker image you can set a custom icon, using the marker's icon or iconView property.
     
     If iconView is set, the API ignores the icon property. Updates to the current icon are not recognised as long as the iconView is set.
     
     Use the marker's icon property
     
     The following snippet creates a marker with a custom icon provided as a UIImage in the icon property. The icon is centered at London, England. The snippet assumes that your application contains an image named "house.png".
     
     OBJECTIVE-CSWIFT
     CLLocationCoordinate2D position = CLLocationCoordinate2DMake(51.5, -0.127);
     GMSMarker *london = [GMSMarker markerWithPosition:position];
     london.title = @"London";
     london.icon = [UIImage imageNamed:@"house"];
     london.map = mapView;
     If you are creating several markers with the same image, use the same instance of UIImage for each of the markers. This helps improve the performance of your application when displaying many markers.
     
     This image may have multiple frames. Additionally, the alignmentRectInsets property is respected, which is useful if a marker has a shadow or other unusable region.
     
     Use the marker's iconView property
     
     The following snippet creates a marker with a custom icon by setting the marker's iconView property, and animates a change in the color of the marker. The snippet assumes that your application contains an image named "house.png".
     
     OBJECTIVE-CSWIFT
     #import "ViewController.h"
     @import GoogleMaps;
     
     @interface ViewController () <GMSMapViewDelegate>
     @property (strong, nonatomic) IBOutlet GMSMapView *mapView;
     @end
     
     @implementation ViewController {
     GMSMarker *_london;
     UIImageView *_londonView;
     }
     
     - (void)viewDidLoad {
     [super viewDidLoad];
     
     _mapView.delegate = self;
     
     UIImage *house = [UIImage imageNamed:@"House"];
     house = [house imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
     _londonView = [[UIImageView alloc] initWithImage:house];
     _londonView.tintColor = [UIColor redColor];
     
     CLLocationCoordinate2D position = CLLocationCoordinate2DMake(51.5, -0.127);
     _london = [GMSMarker markerWithPosition:position];
     _london.title = @"London";
     _london.iconView = _londonView;
     _london.tracksViewChanges = YES;
     _london.map = self.mapView;
     }
     
     - (void)mapView:(GMSMapView *)mapView
     idleAtCameraPosition:(GMSCameraPosition *)position {
     [UIView animateWithDuration:5.0
     animations:^{
     _londonView.tintColor = [UIColor blueColor];
     }
     completion:^(BOOL finished) {
     // Stop tracking view changes to allow CPU to idle.
     _london.tracksViewChanges = NO;
     }];
     }
     
     @end
     Because iconView accepts a UIView, you can have a hierarchy of standard UI controls defining your markers, each view having the standard set of animation capabilities. You can include changes to the marker size, color, and alpha levels, as well as applying arbitrary transformations. The iconView property supports animation of all animatable properties of UIView except frame and center.
     
     Please note the following considerations when using iconView:
     
     The UIView can be demanding on resources when tracksViewChanges is set to YES, which may result in increased battery usage. In comparison, a single frame UIImage is static and does not need to be re-rendered.
     Some devices may struggle to render the map if you have many markers on screen, and each marker has its own UIView, and all markers are tracking changes at the same time.
     An iconView does not respond to user interaction, as it is simply a snapshot of the view.
     The view behaves as if clipsToBounds is set to YES, regardless of its actual value. You can apply transforms that work outside the bounds, but the object you draw must be within the bounds of the object. All transforms/shifts are monitored and applied. In short: subviews must be contained within the view.
     To decide when to set the tracksViewChanges property, you should weigh up performance considerations against the advantages of having the marker redrawn automatically. For example:
     
     If you have a series of changes to make, you can change the property to YES then back to NO.
     When an animation is running or the contents are being loaded asynchronously, you should keep the property set to YES until the actions are complete.
     
     
     
     
     =>Change the marker opacity
     
     marker.opacity = 0.6;
     
     
   =>  Flatten a marker
     
     Marker icons are normally drawn oriented against the device's screen rather than the map's surface, so rotating, tilting or zooming the map does not necessarily change the orientation of the marker.
     
     You can set the orientation of a marker to be flat against the earth. Flat markers rotate when the map is rotated, and change perspective when the map is tilted. As with regular markers, flat markers retain their size when the map is zoomed in or out.
     
     To change the orientation of the marker, set the marker's flat property to YES or tru
     
     CLLocationCoordinate2D position = CLLocationCoordinate2DMake(51.5, -0.127);
     GMSMarker *london = [GMSMarker markerWithPosition:position];
     london.flat = YES;
     london.map = mapView;
     
     Rotate a marker
     
     CLLocationCoordinate2D position = CLLocationCoordinate2DMake(51.5, -0.127);
     CLLocationDegrees degrees = 90;
     GMSMarker *london = [GMSMarker markerWithPosition:position];
     london.groundAnchor = CGPointMake(0.5, 0.5);
     london.rotation = degrees;
     london.map = mapView;
     
     
     Add an info window
     Use an info window to display information to the user when they tap on a marker. Only one info window is displayed at a time. If a user taps on another marker, the current window is hidden and the new info window opens. The contents of the info window are defined by the title and snippet properties. Clicking the marker does not display an info window if both the title and snippet properties are blank or nil.
     
     The following snippet creates a simple marker, with only a title for the text of the info window.
     CLLocationCoordinate2D position = CLLocationCoordinate2DMake(51.5, -0.127);
     GMSMarker *london = [GMSMarker markerWithPosition:position];
     london.title = @"London";
     london.map = mapView;
     
     With the snippet property, you can add additional text that will appear below the title in a smaller font. Strings that are longer than the width of the info window are automatically wrapped over several lines. Very long messages may be truncated.
     CLLocationCoordinate2D position = CLLocationCoordinate2DMake(51.5, -0.127);
     GMSMarker *london = [GMSMarker markerWithPosition:position];
     london.title = @"London";
     london.snippet = @"Population: 8,174,100";
     london.map = mapView;
     
    ==> Set an info window to refresh automatically
     
     Set tracksInfoWindowChanges on the marker to YES or true if you want new properties or the content of the info window to be immediately displayed when changed, rather than having to wait for the info window to hide and then show again. The default is NO or false
     
     marker.tracksInfoWindowChanges = YES;
     To decide when to set the tracksInfoWindowChanges property, you should weigh up performance considerations against the advantages of having the info window redrawn automatically. For example:
     
     If you have a series of changes to make, you can change the property to YES then back to NO.
     When an animation is running or the contents are being loaded asynchronously, you should keep the property set to YES until the actions are complete.
     Refer also to the notes for consideration when using the iconView property of the marker.
     
     =>Change the position of an info window
     An info window is drawn oriented against the device's screen, centered above its associated marker. You can alter the position of the info window relative to the marker by setting the infoWindowAnchor property. This property accepts a CGPoint, defined as an (x,y) offset where both x and y range between 0.0 and 1.0. The default offset is (0.5, 0.0), that is, the center top. Setting the infoWindowAnchor offset is useful for aligning the info window against a custom icon.
     

     CLLocationCoordinate2D position = CLLocationCoordinate2DMake(51.5, -0.127);
     GMSMarker *london = [GMSMarker markerWithPosition:position];
     london.title = @"London";
     london.snippet = @"Population: 8,174,100";
     london.infoWindowAnchor = CGPointMake(0.5, 0.5);
     london.icon = [UIImage imageNamed:@"house"];
     london.map = mapView;
     
     Handle events on markers and info windows
     
     You can listen to events that occur on the map, such as when a user taps a marker or an info window. To listen to events, you must implement the GMSMapViewDelegate protocol. See the guide to events and the list of methods on the GMSMapViewDelegate. For Street View events, see the GMSPanoramaViewDelegate.
     //============================ MOST IMPORTANT   ==================
     
     
     https://developers.google.com/maps/documentation/ios-sdk/events
     

     Events
     
     Using the Google Maps SDK for iOS, you can listen to events that occur on the map, such as camera change events or marker tap events.
     
     Introduction
     
     To listen to events, you must implement the GMSMapViewDelegate protocol. Typically, you implement this protocol on the view controller that displays the map. Below is an example header file:
     
     OBJECTIVE-CSWIFT
     @import UIKit;
     @import GoogleMaps;
     
     @interface DemoViewController : UIViewController<GMSMapViewDelegate>
     @end
     When the GMSMapView is created, you can set its delegate to your view controller. The GMSMapViewDelegate provides only optional methods. To listen to any particular event, you must implement the relevant method.
     
     OBJECTIVE-CSWIFT
     - (void)loadView {
     GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:1.285
     longitude:103.848
     zoom:12];
     GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
     mapView.delegate = self;
     self.view = mapView;
     }
     
     #pragma mark - GMSMapViewDelegate
     
     - (void)mapView:(GMSMapView *)mapView
     didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
     NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
     }
     Camera position
     
     Using the GMSMapViewDelegate, you can listen to changes to the camera position used to render the map. There are three distinct events.
     
     mapView:willMove: indicates that the camera position is about to change. If the gesture argument is set to YES, this is due to a user performing a natural gesture on the GMSMapView, such as a pan or tilt. Otherwise, NO indicates that this is part of a programmatic change - for example, via methods such as animateToCameraPosition: or updating the map's layer directly. This may also be NO if a user has tapped on the My Location or compass buttons, which generate animations that change the camera.
     This method may be called several times before mapView:idleAtCameraPosition: is invoked, although this typically happens only if animations and gestures occur at the same time - a gesture will cancel any current animation, for instance, and will call mapView:willMove: a second time.
     
     mapView:didChangeCameraPosition: is called repeatedly during a gesture or animation, always after a call to mapView:willMove:. It is passed the intermediate camera position.
     Finally, mapView:idleAtCameraPosition: is invoked once the camera position on GMSMapView becomes idle, and specifies the relevant camera position. At this point, all animations and gestures have stopped.
     Applications can use this event to trigger a refresh of markers or other content being displayed on the GMSMapView, rather than, for example, reloading the content on every camera change.
     
     For example, an application can clear the GMSMapView on move, and then reverse geocode the position the camera comes to rest on.
     
     OBJECTIVE-CSWIFT
     // You must define a GMSGeocoder property in your .h file and initialize it
     // in your initializer or viewDidLoad method.
     
     #pragma mark - GMSMapViewDelegate
     
     - (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture {
     [mapView clear];
     }
     
     - (void)mapView:(GMSMapView *)mapView
     idleAtCameraPosition:(GMSCameraPosition *)cameraPosition {
     id handler = ^(GMSReverseGeocodeResponse *response, NSError *error) {
     if (error == nil) {
     GMSReverseGeocodeResult *result = response.firstResult;
     GMSMarker *marker = [GMSMarker markerWithPosition:cameraPosition.target];
     marker.title = result.lines[0];
     marker.snippet = result.lines[1];
     marker.map = mapView;
     }
     };
     [self.geocoder reverseGeocodeCoordinate:cameraPosition.target completionHandler:handler];
     }

     
     Events
     
     Using the Google Maps SDK for iOS, you can listen to events that occur on the map, such as camera change events or marker tap events.
     
     Introduction
     
     To listen to events, you must implement the GMSMapViewDelegate protocol. Typically, you implement this protocol on the view controller that displays the map. Below is an example header file:
     
     OBJECTIVE-CSWIFT
     @import UIKit;
     @import GoogleMaps;
     
     @interface DemoViewController : UIViewController<GMSMapViewDelegate>
     @end
     When the GMSMapView is created, you can set its delegate to your view controller. The GMSMapViewDelegate provides only optional methods. To listen to any particular event, you must implement the relevant method.
     
     OBJECTIVE-CSWIFT
     - (void)loadView {
     GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:1.285
     longitude:103.848
     zoom:12];
     GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
     mapView.delegate = self;
     self.view = mapView;
     }
     
     #pragma mark - GMSMapViewDelegate
     
     - (void)mapView:(GMSMapView *)mapView
     didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
     NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
     }
     Camera position
     
     Using the GMSMapViewDelegate, you can listen to changes to the camera position used to render the map. There are three distinct events.
     
     mapView:willMove: indicates that the camera position is about to change. If the gesture argument is set to YES, this is due to a user performing a natural gesture on the GMSMapView, such as a pan or tilt. Otherwise, NO indicates that this is part of a programmatic change - for example, via methods such as animateToCameraPosition: or updating the map's layer directly. This may also be NO if a user has tapped on the My Location or compass buttons, which generate animations that change the camera.
     This method may be called several times before mapView:idleAtCameraPosition: is invoked, although this typically happens only if animations and gestures occur at the same time - a gesture will cancel any current animation, for instance, and will call mapView:willMove: a second time.
     
     mapView:didChangeCameraPosition: is called repeatedly during a gesture or animation, always after a call to mapView:willMove:. It is passed the intermediate camera position.
     Finally, mapView:idleAtCameraPosition: is invoked once the camera position on GMSMapView becomes idle, and specifies the relevant camera position. At this point, all animations and gestures have stopped.
     Applications can use this event to trigger a refresh of markers or other content being displayed on the GMSMapView, rather than, for example, reloading the content on every camera change.
     
     For example, an application can clear the GMSMapView on move, and then reverse geocode the position the camera comes to rest on.
     
     OBJECTIVE-CSWIFT
     // You must define a GMSGeocoder property in your .h file and initialize it
     // in your initializer or viewDidLoad method.
     
     #pragma mark - GMSMapViewDelegate
     
     - (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture {
     [mapView clear];
     }
     
     - (void)mapView:(GMSMapView *)mapView
     idleAtCameraPosition:(GMSCameraPosition *)cameraPosition {
     id handler = ^(GMSReverseGeocodeResponse *response, NSError *error) {
     if (error == nil) {
     GMSReverseGeocodeResult *result = response.firstResult;
     GMSMarker *marker = [GMSMarker markerWithPosition:cameraPosition.target];
     marker.title = result.lines[0];
     marker.snippet = result.lines[1];
     marker.map = mapView;
     }
     };
     [self.geocoder reverseGeocodeCoordinate:cameraPosition.target completionHandler:handler];
     }
     //=====================================================
     ==>
     Other events
     
     https://developers.google.com/maps/documentation/ios-sdk/reference/protocol_g_m_s_map_view_delegate-p
     
     */
}

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
