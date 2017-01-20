//
//  GenderView.h
//  PatientApp
//
//  Created by isquare2 on 3/16/16.
//  Copyright © 2016 isquare2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PHeader.h"
@interface GenderView : UIViewController
{
    AppDelegate *app;
    IBOutlet UILabel *userGenderLab;
    IBOutlet UIButton *cintinueBtn, *maleBtn, *femaleBtn, *notSayBtn;
    NSString *genderStr;
}
-(IBAction)BackBtnOfGV:(id)sender;
-(IBAction)genderBtnClicked:(id)sender;
-(IBAction)cintinueBtnClickedOfGV:(id)sender;
@end
