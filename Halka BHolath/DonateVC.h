//
//  DonateVC.h
//  Halka BHolath
//
//  Created by iSquare2 on 10/26/16.
//  Copyright © 2016 MitsSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "Header.h"
#import "ServiceNSObject.h"
#import "Reachability.h"
@interface DonateVC : UIViewController
{
    IBOutlet UIImageView *radioMaleImageV, *radioFemaleImageV;
    IBOutlet UIButton *checkMaleButton, *checkFemaleButton, *submitButton;
    IBOutlet UITextField *fullNameTextf, *contactTextf, *emailTextf, *countryTextf, *regionTextf, *amountTextf, *remarkTextf;
    NSString *genderStr;
    MBProgressHUD *hud;
    CGRect screenBounds;
    CGFloat animateDistance;
    ServiceNSObject *jsonServiceNSObjectCall;
}
-(IBAction)SelectGenderBtnPressed:(id)sender;
-(IBAction)SubmitBtnPressed:(id)sender;
-(IBAction)backBtnPressed:(id)sender;
@end
