//
//  MainVC.h
//  Halka BHolath
//
//  Created by iSquare2 on 10/25/16.
//  Copyright © 2016 MitsSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceNSObject.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "Header.h"
#import "AsyncImageView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

@interface MainVC : UIViewController
{
    ServiceNSObject *jsonServiceNSObjectCall;
    MBProgressHUD *hud;
    IBOutlet UITableView *MainTableView;
    IBOutlet UISegmentedControl *MainSegment;
}
-(IBAction)BackBtnPressed:(id)sender;

@end
