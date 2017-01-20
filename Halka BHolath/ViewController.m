//
//  ViewController.m
//  Halka BHolath
//
//  Created by iSquare2 on 10/25/16.
//  Copyright © 2016 MitsSoft. All rights reserved.
//


// Home Screen View Controller
#import "ViewController.h"
#import "Reachability.h"
#import "Header.h"

#import "BabaWebPageVC.h"
@interface ViewController ()
{
    NSString *urlStr;
    NSString *babaTitleStr;
    NSString *babaPremUrlStr;
    NSString *jagirUrlStr;
    NSString *yuvrajSingUrlStr;
}
//-(void)reachabilityChanged:(NSNotification*)note;
@property(strong) Reachability * internetConnectionReach;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    // Start the notifier, which will cause the reachability object to retain itself!
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshDeviceTokenHno:) name:@"DeviceRegister" object:nil];
    if([[Reachability sharedReachability] internetConnectionStatus] == NotReachable){
        ALERT_VIEW(@"",@"Check Internet Connection.")
    }else{
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        [hud show:YES];
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(WebUrlButton) userInfo:nil repeats:NO];
    }

}
-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)WebUrlButton
{
    if([[Reachability sharedReachability] internetConnectionStatus] == NotReachable){
        ALERT_VIEW(@"",@"Check Internet Connection.")
    }else{
    jsonServiceNSObjectCall = [[ServiceNSObject alloc]init];
    NSDictionary *jsonDictionary =[jsonServiceNSObjectCall JsonServiceCall:[NSString stringWithFormat:@"http://46.166.173.116/FlippyCloud/halka_bholath/website.php"]];
    NSLog(@"jsonDictionary :%@",jsonDictionary);
       babaPremUrlStr = [[jsonDictionary valueForKey:@"posts"]valueForKey:@"santbabapremsingh"];
        jagirUrlStr = [[jsonDictionary valueForKey:@"posts"] valueForKey:@"bibijagirkaur"];
        yuvrajSingUrlStr = [[jsonDictionary  valueForKey:@"posts"]valueForKey:@"yuvrajbhupindarsingh"];
    
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
}
- (void)RefreshDeviceTokenHno:(id)object
{
    if([[Reachability sharedReachability] internetConnectionStatus] == NotReachable){
        ALERT_VIEW(@"",@"Check Internet Connection.")
    }else{
            NSString *valueToSave = [[NSUserDefaults standardUserDefaults]stringForKey:@"DeviceToken"];
            if (!valueToSave)
            {
                [self TokenStore];
            }
            
    }
    
}
-(IBAction)BabaPremSingBtnPressed:(id)sender
{
    babaTitleStr = @"Sant Baba Prem Singh";
    urlStr = babaPremUrlStr;
    [self performSegueWithIdentifier:@"BabaWebPageVC" sender:self];
}


-(IBAction)jagirKourBtnPressed:(id)sender
{
    babaTitleStr = @"Bibi Jagir Kaur";
    urlStr = jagirUrlStr;
    [self performSegueWithIdentifier:@"BabaWebPageVC" sender:self];
}
-(IBAction)yuvrajSignBtnPressed:(id)sender
{
     babaTitleStr = @"Yuvraj Bhupindar Singh";
    urlStr = yuvrajSingUrlStr;
    [self performSegueWithIdentifier:@"BabaWebPageVC" sender:self];
}

-(void)TokenStore
{
    NSString *MyRequestString = [NSString stringWithFormat:@"{\"token\":\"%@\"}",app.deviceTokenStr];
    jsonServiceNSObjectCall = [[ServiceNSObject alloc]init];
    NSDictionary *jsonDictionary =[jsonServiceNSObjectCall JsonPostServiceCall:[NSString stringWithFormat:@"http://46.166.173.116/FlippyCloud/halka_bholath/token.php"] PostTagSet:MyRequestString];
    
    NSLog(@"jsonDictionary :%@",jsonDictionary);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *successStr = [jsonDictionary valueForKey:@"success"];
    NSInteger success = [successStr intValue];
    if (success == 1)
    {
        NSString *valueToSave = [NSString stringWithFormat:@"%@",app.deviceTokenStr];
        [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"DeviceToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
       
    }

[MBProgressHUD hideAllHUDsForView:self.view animated:NO];
}

-(IBAction)LiveBtnPressed:(id)sender
{
    [self performSegueWithIdentifier:@"LiveUpdateVC" sender:self];
}
-(IBAction)JoinUsBtnPressed:(id)sender
{
    [self performSegueWithIdentifier:@"JoinVC" sender:self];
}
-(IBAction)DonetBtnPressed:(id)sender
{
     [self performSegueWithIdentifier:@"DonateVC" sender:self];
}
-(IBAction)NotificationBtnPressed:(id)sender
{
    [self performSegueWithIdentifier:@"NotificationVC" sender:self];
}


 #pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
// Get the new view controller using [segue destinationViewController].
// Pass the selected object to the new view controller.
 if ([[segue identifier] isEqualToString:@"BabaWebPageVC"]) {
     BabaWebPageVC *babaVC = (BabaWebPageVC *)segue.destinationViewController;
     babaVC.checkbabaUrlString = babaTitleStr;
     babaVC.UrlString = urlStr;
 }

}
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
