//
//  NotificationVC.h
//  Halka BHolath
//
//  Created by iSquare2 on 10/27/16.
//  Copyright © 2016 MitsSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "ServiceNSObject.h"
#import "MBProgressHUD.h"
#import "Header.h"
@interface NotificationVC : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    MBProgressHUD *hud;
    ServiceNSObject *jsonServiceNSObjectCall;
    IBOutlet UITableView *notificationTableV;
     UILabel *MessageLabel;
}
-(IBAction)backBtnPressed:(id)sender;
@end
