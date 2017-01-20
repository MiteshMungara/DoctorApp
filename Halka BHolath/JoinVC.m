//
//  JoinVC.m
//  Halka BHolath
//
//  Created by iSquare2 on 10/26/16.
//  Copyright © 2016 MitsSoft. All rights reserved.
//

#import "JoinVC.h"

@interface JoinVC ()

@end

@implementation JoinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    submitButton.layer.borderColor= [[UIColor whiteColor]CGColor];
    submitButton.layer.borderWidth = 2;
    submitButton.layer.cornerRadius = 19;
    //Gender
    genderStr = @"Male";
    radioMaleImageV.image = [UIImage imageNamed:@"RadioCheck"];
    checkMaleButton.selected=YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)SelectGenderBtnPressed:(id)sender
{
    if (checkMaleButton.selected == NO)
    {
        radioMaleImageV.image = [UIImage imageNamed:@"RadioCheck"];
        radioFemaleImageV.image = [UIImage imageNamed:@"UncheckRadio"];
        checkMaleButton.selected=YES;
        checkFemaleButton.selected=NO;
        genderStr = @"Male";
    }
    else
    {
        radioMaleImageV.image = [UIImage imageNamed:@"UncheckRadio"];
        radioFemaleImageV.image = [UIImage imageNamed:@"RadioCheck"];
        checkMaleButton.selected=NO;
        checkFemaleButton.selected=YES;
        genderStr = @"Female";
    }
}

-(IBAction)SubmitBtnPressed:(id)sender
{
    if([[Reachability sharedReachability] internetConnectionStatus] == NotReachable){
        ALERT_VIEW(@"",@"Check Internet Connection.")
    }else{
        @try {
            NSString *fullName = fullNameTextf.text;
            NSString *fullNameStr = [fullName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *contact = contactTextf.text;
            NSString *contactStr = [contact stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *email = emailTextf.text;
            NSString *emailStr = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *country = countryTextf.text;
            NSString *countryStr = [country stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *region = regionTextf.text;
            NSString *regionStr = [region stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([fullNameStr isEqualToString:@""] || [contactStr isEqualToString:@""] || [emailStr isEqualToString:@""] || [emailStr isEqualToString:@""] || [countryStr isEqualToString:@""] || [regionStr isEqualToString:@""])
            {
                ALERT_VIEW(@"", @"Please Fill Empty Fields...")
            }
            else
            {
                hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
                [hud show:YES];
                [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(Submit) userInfo:nil repeats:NO];
                
            }
        }
        @catch (NSException *exception) {
            NSString *error = [NSString stringWithFormat:@"%@",exception];
            ALERT_VIEW(@"", error);
        }
        @finally {
            
        }
        
    }
    
}

# pragma mark - View touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(void)Submit
{
    NSString *myRequestString = [NSString stringWithFormat:@"{\"name\":\"%@\",\"gender\":\"%@\",\"contact\":\"%@\",\"email\":\"%@\",\"country\":\"%@\",\"city\":\"%@\"}",fullNameTextf.text,genderStr,contactTextf.text,emailTextf.text,countryTextf.text,regionTextf.text];
    
    jsonServiceNSObjectCall = [[ServiceNSObject alloc]init];
    NSDictionary *jsonDictionary =[jsonServiceNSObjectCall JsonPostServiceCall:[NSString stringWithFormat:@"%@/support_us.php",DATABASEURL] PostTagSet:myRequestString];
    NSLog(@"jsonDictionary :%@",jsonDictionary);
    if ([[jsonDictionary valueForKey:@"success"] isEqualToString:@"1"])
    {
        ALERT_VIEW(@"", @"Join Successfully...");
        [self.navigationController popViewControllerAnimated:TRUE];
    }
    else
    {
        ALERT_VIEW(@"", @"Failed!.");
        
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [hud hide:YES];
    
}
-(IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}


#pragma mark - Text delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [self animateTextField:textField up:YES];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}
- (void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    CGRect frame = self.view.frame;
    CGFloat keyboardHeight = 200.f;
    
    if (up)
    {
        CGRect textFieldFrame = textField.frame;
        CGFloat bottomYPos = textFieldFrame.origin.y + textFieldFrame.size.height;
        
        animateDistance = bottomYPos + 100 + keyboardHeight - frame.size.height;
        if (animateDistance < 0)
            animateDistance = 0;
        else
            animateDistance = fabs(animateDistance);
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.25];
    
    if (!(!up && frame.origin.y == 20.f)) {
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait)
            frame.origin.y = frame.origin.y + (up ? -animateDistance : animateDistance);
        else if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortraitUpsideDown)
            frame.origin.y = frame.origin.y + (up ? animateDistance : -animateDistance);
        self.view.frame = frame;
    }
    [UIView commitAnimations];
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
