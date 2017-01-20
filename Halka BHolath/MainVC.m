//
//  MainVC.m
//  Halka BHolath
//
//  Created by iSquare2 on 10/25/16.
//  Copyright © 2016 MitsSoft. All rights reserved.
//

#import "MainVC.h"
#import "AFNetworking.h"
#import "GUIPlayerView.h"
#import "VideoPlayerViewController.h"
@interface MainVC () <NSURLSessionDelegate,NSURLSessionStreamDelegate,NSURLSessionDownloadDelegate,GUIPlayerViewDelegate>
{
    NSArray *imageContentArr;
    NSArray *videoContentArr;
    NSArray *musicContentArr;
    NSArray *textContentArr;
    NSInteger tag;
    NSMutableArray *cellheightarr, *checkPlayerStatusArr;
    NSString *CheckVideoScreenStatusStr;
    MPMoviePlayerController *moviePlayerController;
}
@property (nonatomic, retain) VideoPlayerViewController *myPlayerViewController;
//@property (weak, nonatomic) IBOutlet UIButton *addPlayerButton;
//@property (weak, nonatomic) IBOutlet UIButton *removePlayerButton;
//@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel;
@property (strong, nonatomic) GUIPlayerView *playerView;
- (IBAction)addPlayer:(UIButton *)sender;
- (IBAction)removePlayer:(UIButton *)sender;
//-(void)reachabilityChanged:(NSNotification*)note;
@property(strong) Reachability * internetConnectionReach;

@end

@implementation MainVC
@synthesize  playerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    //    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    //
    //    // Set the blocks
    //    reach.reachableBlock = ^(Reachability*reach)
    //    {
    //        // keep in mind this is called on a background thread
    //        // and if you are updating the UI it needs to happen
    //        // on the main thread, like this:
    //
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    //            [hud show:YES];
    //            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(AccessDataFromUrl) userInfo:nil repeats:NO];
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
    
    
}


-(void)AccessDataFromUrl
{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/get_media.php",DATABASEURL]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            //NSLog(@"%@ %@", response, responseObject);
            NSLog(@"jsonDictionary :%@",responseObject);
            NSString *successStr = [responseObject valueForKey:@"success"];
            NSInteger success = [successStr intValue];
            if (success == 1)
            {
                imageContentArr = [responseObject valueForKey:@"image"];
                videoContentArr = [responseObject valueForKey:@"video"];
                if (videoContentArr.count != 0) {
                    checkPlayerStatusArr = [[NSMutableArray alloc]init];
                    for (int i = 0; i<videoContentArr.count; i++) {
                        [checkPlayerStatusArr addObject:@"0"];
                    }
                    CheckVideoScreenStatusStr =  @"0";
                }
                
                musicContentArr = [responseObject valueForKey:@"audio"];
                textContentArr = [responseObject valueForKey:@"text"];
                cellheightarr = [[NSMutableArray alloc]init];
                for (int i=0; i<textContentArr.count; i++) {
                    [cellheightarr addObject:@""];
                }
                tag = 0;
                [hud hide:YES];
                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                [MainTableView reloadData];
                
            }
        }
    }];
    [dataTask resume];
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

-(IBAction)SegmentButton:(id)sender
{
    switch (((UISegmentedControl *) sender).selectedSegmentIndex)
    {
            
        case 0:
        {
            if (videoContentArr.count != 0) {
                checkPlayerStatusArr = [[NSMutableArray alloc]init];
                for (int i = 0; i<videoContentArr.count; i++) {
                    [checkPlayerStatusArr addObject:@"0"];
                }
                CheckVideoScreenStatusStr =  @"0";
            }
            
            tag = 0;
        }
            break;
        case 1:
        {
            if (videoContentArr.count != 0) {
                checkPlayerStatusArr = [[NSMutableArray alloc]init];
                for (int i = 0; i<videoContentArr.count; i++) {
                    [checkPlayerStatusArr addObject:@"0"];
                }
                CheckVideoScreenStatusStr =  @"0";
            }
            
            tag = 1;
        }
            break;
        case 2:
        {
            tag = 2;
        }
            break;
        case 3:
        {
            if (videoContentArr.count != 0) {
                checkPlayerStatusArr = [[NSMutableArray alloc]init];
                for (int i = 0; i<videoContentArr.count; i++) {
                    [checkPlayerStatusArr addObject:@"0"];
                }
                CheckVideoScreenStatusStr =  @"0";
            }
            
            tag = 3;
        }
            break;
        default:
            break;
    }
    [MainTableView reloadData];
}
#pragma mark - TableVide
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tag == 0)
    {
        return imageContentArr.count;
    }
    else if (tag == 1)
    {
        return textContentArr.count;
    }
    else if (tag == 2)
    {
        return videoContentArr.count;
    }
    else if (tag == 3)
    {
        return musicContentArr.count;
    }
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (tag == 0)
    {
        return 191;
    }
    else if (tag == 1)
    {
        if (cellheightarr) {
            NSString *heightStr = [NSString stringWithFormat:@"%@",[cellheightarr objectAtIndex:indexPath.row]];
            if (heightStr)
            {
                return [heightStr intValue];
            }
        }
    }
    else if (tag == 2)
    {
        return 215;
    }
    else if (tag == 3)
    {
        return 56;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (tag == 0) {
        static NSString *cellPPIdentifier = @"ImageCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellPPIdentifier];
        cell=nil;
        if (cell == nil)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellPPIdentifier];
        }
        [moviePlayerController stop];
        [moviePlayerController.view removeFromSuperview];
        NSLog(@"%@",[imageContentArr objectAtIndex:indexPath.row]);
        UIImageView *imgView = (UIImageView *)[cell viewWithTag:1];
        NSArray *imageArr = [imageContentArr objectAtIndex:indexPath.row];
        NSLog(@"%@",[imageArr valueForKey:@"thumb"]);
        NSString* encodedString = [[NSString stringWithFormat:@"%@",[imageArr valueForKey:@"thumb"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
        imgView.imageURL = [NSURL URLWithString:encodedString];
        //NSString *url = [[arrayDic objectAtIndex:indexPath.row] valueForKey:@"image"];
        NSArray *parts = [encodedString componentsSeparatedByString:@"/"];
        NSString *filename = [parts lastObject];
        NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        
        NSString* foofile = [documentsPath stringByAppendingPathComponent:filename];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
        if (fileExists  == NO)
        {
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            
            NSURL *URL = [NSURL URLWithString:encodedString];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            
            NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                NSLog(@"File downloaded to: %@", filePath);
                imgView.imageURL = filePath;
            }];
            [downloadTask resume];
        }
        else
        {
            imgView.imageURL = [NSURL fileURLWithPath:foofile];
        }
        //imgView.imageURL = [NSURL URLWithString:encodedString];
        
        
    }
    else if (tag == 1)
    {
        static NSString *cellPPIdentifier = @"TextCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellPPIdentifier];
        cell=nil;
        if (cell == nil)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellPPIdentifier];
        }
        //Video Song Remove
        [moviePlayerController stop];
        [moviePlayerController.view removeFromSuperview];
        
        
        NSArray *textArr = [textContentArr objectAtIndex:indexPath.row];
        NSString *textStr = [NSString stringWithFormat:@"%@",[textArr objectAtIndex:0]];
        UILabel *CellText = (UILabel *)[cell viewWithTag:5];
        CellText.text = textStr;
        CellText.textAlignment = UITextAlignmentCenter;
        CellText.numberOfLines = 0;
        CellText.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize maximumLabelSize = CGSizeMake(CellText.frame.size.width, CGFLOAT_MAX);
        CGSize expectSize = [CellText sizeThatFits:maximumLabelSize];
        CellText.frame = CGRectMake(CellText.frame.origin.x, CellText.frame.origin.y, CellText.frame.size.width, expectSize.height);
        CGFloat height = expectSize.height;
        int addition = roundf(height) + roundf(15.00);
        [cellheightarr replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%d",addition]];
        NSLog(@"total%d",addition);
    }
    else if (tag == 2)
    {
        static NSString *cellPPIdentifier = @"VideoCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellPPIdentifier];
        
        cell = nil;
        if (cell == nil)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellPPIdentifier];
            
        }
        
        NSString *checkStatus = [NSString stringWithFormat:@"%@",[checkPlayerStatusArr objectAtIndex:indexPath.row]];
        if (![checkStatus isEqualToString:@"0"]) {
            
            NSArray *imageArr = [videoContentArr objectAtIndex:indexPath.row];
            NSString* encodedString = [[NSString stringWithFormat:@"%@",[imageArr valueForKey:@"vid"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
            
            NSURL *videoURL = [NSURL URLWithString:encodedString];
            moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
            [moviePlayerController setControlStyle:MPMovieControlStyleNone];
            moviePlayerController.scalingMode = MPMovieScalingModeAspectFit;
            [moviePlayerController.view setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y , self.view.frame.size.width, cell.frame.size.height)];
            [cell.contentView addSubview:moviePlayerController.view];
            moviePlayerController.view.hidden = NO;
            [moviePlayerController prepareToPlay];
            [moviePlayerController play];
            
        }
        else
        {
            [moviePlayerController stop];
            [moviePlayerController.view removeFromSuperview];
            
            
            UIButton *playButton = (UIButton *)[cell viewWithTag:6];
            [playButton addTarget:self action:@selector(videoPlayer:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        // videoImageV.imageURL = [NSURL URLWithString:encodedString];
        
        
        
    }
    else if (tag == 3)
    {
        
        static NSString *cellPPIdentifier = @"AudioCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellPPIdentifier];
        cell=nil;
        if (cell == nil)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellPPIdentifier];
        }
        //Video Song Remove
        [moviePlayerController stop];
        [moviePlayerController.view removeFromSuperview];
        
        
        NSArray *musicArr = [musicContentArr objectAtIndex:indexPath.row];
        NSString *musicFileStr = [NSString stringWithFormat:@"%@",[musicArr objectAtIndex:0]];
        //NSString* encodedString = [musicFileStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
        
        NSArray *parts = [musicFileStr componentsSeparatedByString:@"/"];
        NSString *filename = [parts lastObject];
        UILabel *lblTitleAudio = (UILabel *)[cell viewWithTag:3];
        lblTitleAudio.text = [NSString stringWithFormat:@"%@",filename];
        
    }
    
    
    
    return cell;
}

-(void)videoPlayer:sender
{
    UIButton *senderButton = (UIButton *)sender;
    UITableViewCell *buttonCell = (UITableViewCell *)senderButton.superview.superview;
    NSIndexPath* pathOfTheCell = [MainTableView indexPathForCell:buttonCell];
    NSLog(@"pathOfTheCell.row :%ld",(long)pathOfTheCell.row);
    int index = (int) pathOfTheCell.row;
    CheckVideoScreenStatusStr = [NSString stringWithFormat:@"%d",index];
    if ([[checkPlayerStatusArr objectAtIndex:pathOfTheCell.row] isEqualToString:@"1"]) {
        [checkPlayerStatusArr replaceObjectAtIndex:pathOfTheCell.row withObject:@"0"];
    }
    else
    {
        [checkPlayerStatusArr replaceObjectAtIndex:pathOfTheCell.row withObject:@"1"];
    }
    
    
    [MainTableView beginUpdates];
    [MainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:pathOfTheCell] withRowAnimation:UITableViewRowAnimationAutomatic];
    [MainTableView endUpdates];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tag == 0)
    {
        
    }
    else if (tag == 1)
    {
        
        
    }
    else if (tag == 2)
    {
        
    }
    else if (tag == 3)
    {
        
        NSArray *musicArr = [musicContentArr objectAtIndex:indexPath.row];
        NSString *musicFileStr = [NSString stringWithFormat:@"%@",[musicArr objectAtIndex:0]];
        
        NSString* urlTextEscaped = [musicFileStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString: urlTextEscaped];
        
        MPMoviePlayerViewController *controller = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:controller];
    }
}

-(IBAction)BackBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}
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
