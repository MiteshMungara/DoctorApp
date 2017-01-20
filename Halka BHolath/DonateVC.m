//
//  DonateVC.m
//  Halka BHolath
//
//  Created by iSquare2 on 10/26/16.
//  Copyright © 2016 MitsSoft. All rights reserved.
//

#import "DonateVC.h"
#import "AFHTTPSessionManager.h"

@interface DonateVC () <NSURLSessionDelegate,NSURLSessionStreamDelegate,NSURLSessionDownloadDelegate,AFURLRequestSerialization,AFURLResponseSerialization>

@end

@implementation DonateVC

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
    
    UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedItem.width = screenBounds.size.width-80;
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(doneClickedOFpv:)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:fixedItem,doneButton, nil]];
    contactTextf.inputAccessoryView = keyboardDoneButtonView;
}

-(void)doneClickedOFpv:(id)sender
{
    [self.view endEditing:YES];
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
        NSString *amount = amountTextf.text;
        NSString *amountStr = [amount stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if ([fullNameStr isEqualToString:@""] || [contactStr isEqualToString:@""] || [emailStr isEqualToString:@""] || [emailStr isEqualToString:@""] || [countryStr isEqualToString:@""] || [regionStr isEqualToString:@""] || [amountStr isEqualToString:@""])
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
    
    
}


-(void)Submit
{
    @try {
        NSString *myRequestString = [NSString stringWithFormat:@"{\"name\":\"%@\",\"gender\":\"%@\",\"contact\":\"%@\",\"email\":\"%@\",\"country\":\"%@\",\"city\":\"%@\",\"donation_amount\":\"%@\",\"remark\":\"%@\"}",fullNameTextf.text,genderStr,contactTextf.text,emailTextf.text,countryTextf.text,regionTextf.text,amountTextf.text,remarkTextf.text];
        
        jsonServiceNSObjectCall = [[ServiceNSObject alloc]init];
        NSDictionary *jsonDictionary =[jsonServiceNSObjectCall JsonPostServiceCall:[NSString stringWithFormat:@"%@/donation_support.php",DATABASEURL] PostTagSet:myRequestString];
        NSLog(@"jsonDictionary :%@",jsonDictionary);
        if ([[jsonDictionary valueForKey:@"success"] isEqualToString:@"1"])
        {
            ALERT_VIEW(@"", @"Donet Successfully...");
            [self.navigationController popViewControllerAnimated:TRUE];
        }
        else
        {
            ALERT_VIEW(@"", @"Failed!.");
            
        }
    }
    @catch (NSException *exception) {
        NSString *error = [NSString stringWithFormat:@"%@",exception];
        ALERT_VIEW(@"", error);
    }
    @finally {
        
    }
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [hud hide:YES];
    
}

# pragma mark - View touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
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

-(IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
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

// NSDictionary *params = @ {@"name" :fullNameTextf.text, @"gender" :genderStr , @"contact" :contactTextf.text , @"email" :emailTextf.text , @"country" :countryTextf.text , @"city" :regionTextf.text , @"donation_amount" :amountTextf.text , @"remark" :remarkTextf.text };
//    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/donation_support.php",DATABASEURL]];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager POST:URL.absoluteString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//        ALERT_VIEW(@"", @"Success!.");
//        [hud hide:YES];
//        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
//        [self.navigationController popViewControllerAnimated:TRUE];
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"Error: %@", error);
//        ALERT_VIEW(@"", @"Failed!.");
//        [hud hide:YES];
//        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
//    }];
//

