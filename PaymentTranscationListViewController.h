//
//  PaymentTranscationListViewController.h
//  PatientApp
//
//  Created by iSquare2 on 8/12/16.
//  Copyright © 2016 isquare2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "PHeader.h"
#import "AppDelegate.h"
#import "ServiceNSObject.h"
@interface PaymentTranscationListViewController : UIViewController
{
    ServiceNSObject *jsonServiceNSObjectCall;
    AppDelegate *app;
    MBProgressHUD *hud;
    IBOutlet UITableView *tbl_listDoctorCheck;
}

@property(strong,nonatomic)NSArray *dataPatientListArray;

-(IBAction)backBtnPressed:(id)sender;

@end
