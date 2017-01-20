//
//  LiveUpdateVC.h
//  Halka BHolath
//
//  Created by iSquare2 on 10/27/16.
//  Copyright © 2016 MitsSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "Reachability.h"
#import "ServiceNSObject.h"
#import "Header.h"
#import "MBProgressHUD.h"
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
@interface LiveUpdateVC : UIViewController
{
    MBProgressHUD *hud;
    IBOutlet UITableView *liveFeedsTableView;
    ServiceNSObject *jsonServiceNSObjectCall;
    IBOutlet UISegmentedControl *MainSegment;
    IBOutlet UIImageView *fullImageV;
    IBOutlet UIView *fullImageShowView;
    IBOutlet UIButton *backImageButton;
}
-(IBAction)backimagefullBtnPressed:(id)sender;
-(IBAction)backBtnPressed:(id)sender;
-(IBAction)SegmentButton:(id)sender;
@end
