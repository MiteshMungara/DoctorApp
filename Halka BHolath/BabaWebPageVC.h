//
//  BabaWebPageVC.h
//  Halka BHolath
//
//  Created by iSquare2 on 10/28/16.
//  Copyright © 2016 MitsSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Header.h"
@interface BabaWebPageVC : UIViewController
{
    IBOutlet UIWebView *webShowBaba;
    IBOutlet UILabel *titleLabel;
    MBProgressHUD *hud;
}

@property(strong,nonatomic)NSString *checkbabaUrlString, *UrlString;
-(IBAction)babaWebViewBtnPressed:(id)sender;

@end
