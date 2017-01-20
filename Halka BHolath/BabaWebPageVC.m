//
//  BabaWebPageVC.m
//  Halka BHolath
//
//  Created by iSquare2 on 10/28/16.
//  Copyright © 2016 MitsSoft. All rights reserved.
//

#import "BabaWebPageVC.h"

@interface BabaWebPageVC () <UIWebViewDelegate>

@end

@implementation BabaWebPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    titleLabel.text = [NSString stringWithFormat:@"%@",self.checkbabaUrlString];
    NSURL *weburl = [NSURL URLWithString:self.UrlString];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:weburl];
    [webShowBaba loadRequest:requestObj];
    webShowBaba.scalesPageToFit=YES;
    webShowBaba.delegate=self;
    [self.view addSubview:webShowBaba];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)babaWebViewBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}



- (void)webViewDidStartLoad:(UIWebView *)mwebView {
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [hud hide:YES];
    
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    return YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    ALERT_VIEW(@"", @"Web Page Load Failed");
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [hud hide:YES];
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
