//
//  ViewController.h
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
#import "AppDelegate.h"
@interface ViewController : UIViewController
{
    ServiceNSObject *jsonServiceNSObjectCall;
    MBProgressHUD *hud;
    AppDelegate *app;
}

//-(IBAction)HelpBtnPressed:(id)sender;
-(IBAction)JoinUsBtnPressed:(id)sender;
-(IBAction)DonetBtnPressed:(id)sender;
-(IBAction)NotificationBtnPressed:(id)sender;
-(IBAction)LiveBtnPressed:(id)sender;
-(IBAction)BabaPremSingBtnPressed:(id)sender;
-(IBAction)jagirKourBtnPressed:(id)sender;
-(IBAction)yuvrajSignBtnPressed:(id)sender;
@end

