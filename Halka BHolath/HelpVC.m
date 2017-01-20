//
//  HelpVC.m
//  Halka BHolath
//
//  Created by iSquare2 on 10/25/16.
//  Copyright © 2016 MitsSoft. All rights reserved.
//

#import "HelpVC.h"

@interface HelpVC ()
@property(strong) Reachability * internetConnectionReach;
@end

@implementation HelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
//    
//    reach.reachableBlock = ^(Reachability*reach)
//    {
//       
//        NSString * temp = [NSString stringWithFormat:@"InternetConnection Says Reachable(%@)", reach.currentReachabilityString];
//        NSLog(@"%@",temp);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
//            [hud show:YES];
//            [self AccessDataFromUrl];
//        });
//    };
//    
//    reach.unreachableBlock = ^(Reachability *reach)
//    {
//        NSString * temp = [NSString stringWithFormat:@"InternetConnection Block Says Unreachable(%@)", reach.currentReachabilityString];
//        ALERT_VIEW(@"Alert", temp);
//    };
//    
//    [reach startNotifier];
    
    
   
    if([self connectedToInternet] == NO)
    {
        // Not connected to the internet
        NSLog(@"No Internet Found");
    }
    else
    {
         [self AccessDataFromUrl];
        
        // Connected to the internet
    }

}
- (BOOL)connectedToInternet
{
    NSString *urlString = @"http://www.google.com/";
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"HEAD"];
    NSHTTPURLResponse *response;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: NULL];
    
    return ([response statusCode] == 200) ? YES : NO;
}

# pragma mark - View touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
   
}
-(void)AccessDataFromUrl
{
     
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/get_text.php",DATABASEURL]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            if(responseObject)
            {
                NSLog(@"jsonDictionary :%@",responseObject);
//                NSString *successStr = [responseObject valueForKey:@"success"];
//                NSInteger success = [successStr intValue];
//                if (success == 1)
//                {
                    NSString *HelpTextStr  = [NSString stringWithFormat:@"%@",[[[responseObject valueForKey:@"posts"]valueForKey:@"text"]objectAtIndex:0]];
                    
                    HelpTextV.text = [NSString stringWithFormat:@"%@",HelpTextStr];
                
                [hud hide:YES];
                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                
               // }
            }
            
        }
    }];
    [dataTask resume];
     
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)HelpBtnPressed:(id)sender;
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
