//
//  GenderView.m
//  PatientApp
//
//  Created by isquare2 on 3/16/16.
//  Copyright © 2016 isquare2. All rights reserved.
//

#import "GenderView.h"

@interface GenderView ()

@end

@implementation GenderView

- (void)viewDidLoad {
    [super viewDidLoad];
    app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    //
    cintinueBtn.layer.cornerRadius = 4;
    cintinueBtn.clipsToBounds = YES;
    maleBtn.layer.cornerRadius = maleBtn.frame.size.width/2;
    maleBtn.clipsToBounds = YES;
    [maleBtn.layer setBorderColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor];
    [maleBtn.layer setBorderWidth:2.0];
    femaleBtn.layer.cornerRadius = femaleBtn.frame.size.width/2;
    femaleBtn.clipsToBounds = YES;
    [femaleBtn.layer setBorderColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor];
    [femaleBtn.layer setBorderWidth:2.0];
    //
    userGenderLab.text = [NSString stringWithFormat:@"What is %@ %@ gender?",[app.registerDir valueForKey:@"title"],[app.registerDir valueForKey:@"surname"]];
    
    if ( [app.DataCopyString isEqualToString:@"1"])
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *UserStr = [prefs stringForKey:@"SexKey"];
        if(UserStr.length != 0)
        {
            genderStr = [prefs stringForKey:@"SexKey"];
            if ([genderStr isEqualToString:@"Male"]) {
                genderStr = @"Male";
                maleBtn.selected = YES;
                femaleBtn.selected = NO;
                maleBtn.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
                femaleBtn.backgroundColor = [UIColor clearColor];
                [maleBtn.layer setBorderColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor];
                [maleBtn.layer setBorderWidth:2.0];
                [femaleBtn.layer setBorderColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor];
                [femaleBtn.layer setBorderWidth:2.0];
                [notSayBtn setTitleColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            }
            else if([genderStr isEqualToString:@"Female"])
            {
                genderStr = @"Female";
                maleBtn.selected = NO;
                femaleBtn.selected = YES;
                femaleBtn.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
                maleBtn.backgroundColor = [UIColor clearColor];
                [maleBtn.layer setBorderColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor];
                [maleBtn.layer setBorderWidth:2.0];
                [femaleBtn.layer setBorderColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor];
                [femaleBtn.layer setBorderWidth:2.0];
                [notSayBtn setTitleColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            }
            else
            {
                genderStr = @"Not stated";
                maleBtn.selected = NO;
                femaleBtn.selected = NO;
                femaleBtn.backgroundColor = [UIColor clearColor];
                maleBtn.backgroundColor = [UIColor clearColor];
                [maleBtn.layer setBorderColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor];
                [maleBtn.layer setBorderWidth:2.0];
                [femaleBtn.layer setBorderColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor];
                [femaleBtn.layer setBorderWidth:2.0];
                [notSayBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            
        }
    }
    
    
    
    if ([[app.SocialLoginDir valueForKey:@"SocialLogin"] isEqualToString:@"FaceBook"])
    {
        
        genderStr = [app.SocialLoginDir  valueForKey:@"Gender"];
        if ([genderStr isEqualToString:@"male"]) {
            genderStr = @"Male";
            maleBtn.selected = YES;
            femaleBtn.selected = NO;
            maleBtn.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
            femaleBtn.backgroundColor = [UIColor clearColor];
            [maleBtn.layer setBorderColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor];
            [maleBtn.layer setBorderWidth:2.0];
            [femaleBtn.layer setBorderColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor];
            [femaleBtn.layer setBorderWidth:2.0];
            [notSayBtn setTitleColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        }
        else if([genderStr isEqualToString:@"female"])
        {
            genderStr = @"Female";
            maleBtn.selected = NO;
            femaleBtn.selected = YES;
            femaleBtn.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
            maleBtn.backgroundColor = [UIColor clearColor];
            [maleBtn.layer setBorderColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor];
            [maleBtn.layer setBorderWidth:2.0];
            [femaleBtn.layer setBorderColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor];
            [femaleBtn.layer setBorderWidth:2.0];
            [notSayBtn setTitleColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        }
        else
        {
            genderStr = @"Not stated";
            maleBtn.selected = NO;
            femaleBtn.selected = NO;
            femaleBtn.backgroundColor = [UIColor clearColor];
            maleBtn.backgroundColor = [UIColor clearColor];
            [maleBtn.layer setBorderColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor];
            [maleBtn.layer setBorderWidth:2.0];
            [femaleBtn.layer setBorderColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor];
            [femaleBtn.layer setBorderWidth:2.0];
            [notSayBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        
    }
    else  if ([[app.SocialLoginDir valueForKey:@"SocialLogin"] isEqualToString:@"Gmail"]) {
        
    }
    else  if ([[app.SocialLoginDir valueForKey:@"SocialLogin"] isEqualToString:@"LinkedIn"]) {
        
    }
    else if ([[app.SocialLoginDir valueForKey:@"SocialLogin"] isEqualToString:@"Twitter"]) {
        
        
    }
    
    
}
-(IBAction)genderBtnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag==1) {
        genderStr = @"Male";
        maleBtn.selected = YES;
        femaleBtn.selected = NO;
        maleBtn.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
        femaleBtn.backgroundColor = [UIColor clearColor];
        [maleBtn.layer setBorderColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor];
        [maleBtn.layer setBorderWidth:2.0];
        [femaleBtn.layer setBorderColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor];
        [femaleBtn.layer setBorderWidth:2.0];
        [notSayBtn setTitleColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    }else if (btn.tag==2){
        genderStr = @"Female";
        maleBtn.selected = NO;
        femaleBtn.selected = YES;
        femaleBtn.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
        maleBtn.backgroundColor = [UIColor clearColor];
        [maleBtn.layer setBorderColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor];
        [maleBtn.layer setBorderWidth:2.0];
        [femaleBtn.layer setBorderColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor];
        [femaleBtn.layer setBorderWidth:2.0];
        [notSayBtn setTitleColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    }else if (btn.tag==3){
        genderStr = @"Not stated";
        maleBtn.selected = NO;
        femaleBtn.selected = NO;
        femaleBtn.backgroundColor = [UIColor clearColor];
        maleBtn.backgroundColor = [UIColor clearColor];
        [maleBtn.layer setBorderColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor];
        [maleBtn.layer setBorderWidth:2.0];
        [femaleBtn.layer setBorderColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor];
        [femaleBtn.layer setBorderWidth:2.0];
        [notSayBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    
}
-(IBAction)BackBtnOfGV:(id)sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}
-(IBAction)cintinueBtnClickedOfGV:(id)sender
{
    [self.view endEditing:YES];
    if ( [genderStr length]==0 )
    {
        ALERT_VIEW(@"Please select gender.",@"")
    }else
    {
        [app.registerDir setObject:genderStr forKey:@"sex"];
      //  [app.registerDir setObject:@"23" forKey:@"age"];
        
        [self performSegueWithIdentifier:@"AddressView" sender:self];
    }
}
#pragma mark - Stop
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
