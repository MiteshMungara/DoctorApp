//
//  PaymentTranscationListViewController.m
//  PatientApp
//
//  Created by iSquare2 on 8/12/16.
//  Copyright © 2016 isquare2. All rights reserved.
//

#import "PaymentTranscationListViewController.h"
#import "PaymentTransactionDetailsShowViewController.h"
@interface PaymentTranscationListViewController ()
{
    NSArray *listPatientReportArr;
    NSMutableArray *SelectedPatientReportArr;
}
@end

@implementation PaymentTranscationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
     [super viewWillAppear:NO];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getpreportListOfServer) userInfo:Nil repeats:NO];
    
}
-(void)getpreportListOfServer
{
    if([[Reachability sharedReachability] internetConnectionStatus] == NotReachable){
        ALERT_VIEW(@"",@"Check Internet Connection.")
    }else{
        @try
        {
            NSString *profileIDStr = [NSString stringWithFormat:@"%@",[[self.dataPatientListArray valueForKey:@"id"]objectAtIndex:0]];
            NSString *myRequestString =[NSString stringWithFormat:@"{\"profileid\":\"%@\"}",profileIDStr];
            jsonServiceNSObjectCall = [[ServiceNSObject alloc]init];
            NSDictionary *jsonDictionary =[jsonServiceNSObjectCall JsonPostServiceCall:[NSString stringWithFormat:@"%@/get_patients_payment_pdf.php",DATABASEURL] PostTagSet:myRequestString];
            NSLog(@"jsonDictionary :%@",jsonDictionary);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *successStr = [jsonDictionary valueForKey:@"Success"];
            NSInteger success = [successStr intValue];
            if (success == 1)
            {
                listPatientReportArr = [[NSMutableArray alloc]init];
                listPatientReportArr = [jsonDictionary valueForKey:@"posts"];
                [tbl_listDoctorCheck reloadData];
            }else{
                //patientArr = nil;
                [tbl_listDoctorCheck reloadData];
            }
            //  app.mapListArr = [patientArr mutableCopy];
        }@catch (NSException * e){}
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [listPatientReportArr count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *deviceType = [UIDevice currentDevice].model;
    NSLog(@"iphone %@",deviceType);
    if([deviceType isEqualToString:@"iPhone"])
    {
        return 65;
    }
    else
    {
        return 80;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    static NSString *CellIdentifier = @"patientListCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    @try
    {
        UILabel *Number =  (UILabel *) [cell viewWithTag:1];
        UILabel *doctorname =  (UILabel *) [cell viewWithTag:2];
        UIButton *LreportButton =  (UIButton *) [cell viewWithTag:6];
        UILabel *DateL =  (UILabel *) [cell viewWithTag:7];
        
        // NSString *dateTimeStr = [[listPatientReportArr valueForKey:@"Paypal Date"] objectAtIndex:indexPath.row];
        // NSArray *DateArray = [dateTimeStr componentsSeparatedByString:@" "];
        
        
        NSString *dateString = [[listPatientReportArr valueForKey:@"Paypal Date"]objectAtIndex:indexPath.row];
        dateString = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        dateString = [dateString stringByReplacingOccurrencesOfString:@"Z" withString:@""];
        DateL.text =dateString;
        LreportButton.layer.cornerRadius = 10;
        UIButton *reportButton = (UIButton *)[cell viewWithTag:3];
        UIView *reportV = (UIView *)[cell viewWithTag:4];
        reportV.backgroundColor = [UIColor whiteColor]; //[UIColor colorWithRed:73/255.0f green:207/255.0f blue:182/255.0f alpha:1.0f];
        reportV.layer.cornerRadius = 4;
        reportV.clipsToBounds = YES;
        [reportV.layer setBorderColor:BORDERCOLOR];
        [reportV.layer setBorderWidth: 2.0];
        reportV.layer.cornerRadius = 8;
        Number.text = @"Doctor Name"; //[NSString stringWithFormat:@"%d)",no];
        doctorname.text = [[listPatientReportArr valueForKey:@"Doctor Name"]objectAtIndex:indexPath.row];
        
        [reportButton addTarget:self action:@selector(SelectedPatientReport:) forControlEvents:UIControlEventTouchUpInside];
        
    }@catch (NSException * e){}
    return cell;
}

-(void)SelectedPatientReport:sender
{
    UIButton *senderButton = (UIButton *)sender;
    UITableViewCell *buttonCell = (UITableViewCell *)senderButton.superview.superview;
    NSIndexPath *indexPathOnBtnClicked = [tbl_listDoctorCheck indexPathForCell:buttonCell];
    NSLog(@"Open Path : %ld",(long)indexPathOnBtnClicked.row);
    NSLog(@"Path : %ld",(long)buttonCell);
    SelectedPatientReportArr = [[NSMutableArray alloc]init];
    [SelectedPatientReportArr addObject:[listPatientReportArr objectAtIndex:indexPathOnBtnClicked.row]];
    [self performSegueWithIdentifier:@"PaymentTransactionDetailsShowViewController" sender:self];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // app.selectPatientDir = [[patientArr objectAtIndex:indexPath.row]mutableCopy];
    //  [self performSegueWithIdentifier:@"ProfessionalView" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"PaymentTransactionDetailsShowViewController"]) {
        PaymentTransactionDetailsShowViewController *vc = (PaymentTransactionDetailsShowViewController *)segue.destinationViewController;
        vc.dataPatientArray = SelectedPatientReportArr;
    }
    
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
