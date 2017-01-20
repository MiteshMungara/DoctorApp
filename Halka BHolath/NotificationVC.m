//
//  NotificationVC.m
//  Halka BHolath
//
//  Created by iSquare2 on 10/27/16.
//  Copyright © 2016 MitsSoft. All rights reserved.
//

#import "NotificationVC.h"

@interface NotificationVC ()
{
    NSArray *NotificationArr;
}
@end

@implementation NotificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if([[Reachability sharedReachability] internetConnectionStatus] == NotReachable){
        ALERT_VIEW(@"",@"Check Internet Connection.")
    }else{
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        [hud show:YES];
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(GetPushNotification) userInfo:nil repeats:NO];
        
    }
}


-(void)GetPushNotification
{
    
    jsonServiceNSObjectCall = [[ServiceNSObject alloc]init];
    NSDictionary *jsonDictionary =[jsonServiceNSObjectCall JsonServiceCall:[NSString stringWithFormat:@"http://46.166.173.116/FlippyCloud/halka_bholath/notification_list.php"]];
    
    NSLog(@"jsonDictionary :%@",jsonDictionary);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *successStr = [jsonDictionary valueForKey:@"success"];
    NSInteger success = [successStr intValue];
    if (success == 1)
    {
        NotificationArr = [[jsonDictionary valueForKey:@"posts"]valueForKey:@"website_name"];
        [notificationTableV reloadData];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [hud hide:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableVide
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return NotificationArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CGFloat msg = MessageLabel.frame.size.height + 20;
    return msg;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellPPIdentifier = @"MessageCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellPPIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellPPIdentifier];
    }
    MessageLabel = (UILabel *)[cell viewWithTag:1];
    MessageLabel.text = [NSString stringWithFormat:@"%@",[NotificationArr objectAtIndex:indexPath.row]];
    
    NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
    paragraphStyles.alignment = NSTextAlignmentJustified;      //justified text
    paragraphStyles.firstLineHeadIndent = 16.0;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyles};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString: MessageLabel.text attributes: attributes];
    
    MessageLabel.attributedText = attributedString;
    //MessageLabel.textAlignment = UITextAlignmentCenter;
    MessageLabel.numberOfLines = 0;
    MessageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize maximumLabelSize = CGSizeMake(MessageLabel.frame.size.width, CGFLOAT_MAX);
    CGSize expectSize = [MessageLabel sizeThatFits:maximumLabelSize];
    MessageLabel.frame = CGRectMake(MessageLabel.frame.origin.x, MessageLabel.frame.origin.y, MessageLabel.frame.size.width, expectSize.height);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
