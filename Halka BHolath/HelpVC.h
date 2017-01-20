//
//  HelpVC.h
//  Halka BHolath
//
//  Created by iSquare2 on 10/25/16.
//  Copyright © 2016 MitsSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#import "Reachability.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
@interface HelpVC : UIViewController
{
    MBProgressHUD *hud;
    IBOutlet UITextView *HelpTextV;
}

-(IBAction)HelpBtnPressed:(id)sender;
@end
