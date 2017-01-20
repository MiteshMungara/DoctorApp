//
//  LiveUpdateVC.m
//  Halka BHolath
//
//  Created by iSquare2 on 10/27/16.
//  Copyright © 2016 MitsSoft. All rights reserved.
//

#import "LiveUpdateVC.h"

@interface LiveUpdateVC ()
{
    NSArray *AllDataArr;
    NSString *typeStr;
    NSMutableArray *imageArr,*videoArr,*textArr,*audioArr;
    NSMutableArray *imageHeightArr,*videoHeightArr,*textHeightArr,*audioHeightArr;
    MPMoviePlayerController * moviePlayerController;
}
@end

@implementation LiveUpdateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    backImageButton.layer.cornerRadius = backImageButton.frame.size.width / 2 ;
    backImageButton.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:120.0/255.0 blue:175.0/255.0 alpha:1];
    
    if([[Reachability sharedReachability] internetConnectionStatus] == NotReachable){
        ALERT_VIEW(@"",@"Check Internet Connection.")
    }else{
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        [hud show:YES];
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(loadDataFromServer) userInfo:nil repeats:NO];
    }
}

-(void)loadDataFromServer
{
    
    jsonServiceNSObjectCall = [[ServiceNSObject alloc]init];
    NSDictionary *jsonDictionary =[jsonServiceNSObjectCall JsonServiceCall:[NSString stringWithFormat:@"http://46.166.173.116/FlippyCloud/halka_bholath/live_update.php"]];
    
    // PostTagSet:myRequestString];//:[NSString stringWithFormat:@"%@/donation_support.php",DATABASEURL] PostTagSet:myRequestString];
    NSLog(@"jsonDictionary :%@",jsonDictionary);
    if ([[jsonDictionary valueForKey:@"success"] isEqualToString:@"1"])
    {
        NSArray *DataArr = [jsonDictionary valueForKey:@"posts"];
        imageArr = [[NSMutableArray alloc]init];
        audioArr = [[NSMutableArray alloc]init];
        videoArr = [[NSMutableArray alloc]init];
        textArr = [[NSMutableArray alloc]init];
        imageHeightArr = [[NSMutableArray alloc]init];
        videoHeightArr = [[NSMutableArray alloc]init];
        textHeightArr = [[NSMutableArray alloc]init];
        audioHeightArr = [[NSMutableArray alloc]init];
        
        for (int i=0; i < DataArr.count; i++)
        {
            NSString *typeLoadStr = [NSString stringWithFormat:@"%@",[[DataArr valueForKey:@"type"]objectAtIndex:i]];
            
            if ([typeLoadStr  isEqualToString:@"image"])
            {
                [imageArr addObject:[DataArr objectAtIndex:i]];
                [imageHeightArr addObject:@""];
            }
            else if([typeLoadStr  isEqualToString:@"audio"])
            {
                [audioArr addObject:[DataArr objectAtIndex:i]];
                [audioHeightArr addObject:@""];
            }
            else if([typeLoadStr  isEqualToString:@"video"])
            {
                [videoArr addObject:[DataArr objectAtIndex:i]];
                [videoHeightArr addObject:@""];
            }
            else if([typeLoadStr  isEqualToString:@"text"])
            {
                [textArr addObject:[DataArr objectAtIndex:i]];
                [textHeightArr addObject:@""];
            }
            
        }
        AllDataArr = [imageArr copy];
        typeStr = @"image";
        [liveFeedsTableView reloadData];
        // ALERT_VIEW(@"", @"Donete Successfully...");
        //[self.navigationController popViewControllerAnimated:TRUE];
    }
    else
    {
        ALERT_VIEW(@"", @"Failed!.");
        
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [hud hide:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(IBAction)SegmentButton:(id)sender
{
    switch (((UISegmentedControl *) sender).selectedSegmentIndex)
    {
            
        case 0:
        {
            AllDataArr = [imageArr copy];
        }
            break;
        case 1:
        {
            AllDataArr = [textArr copy];
        }
            break;
        case 2:
        {
            AllDataArr = [videoArr copy];
        }
            break;
        case 3:
        {
            AllDataArr = [audioArr copy];
        }
            break;
        default:
            break;
    }
    [liveFeedsTableView reloadData];
}

#pragma mark - TableVide
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return AllDataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *typeLoadStr = [NSString stringWithFormat:@"%@",[[AllDataArr valueForKey:@"type"]objectAtIndex:indexPath.row]];
    
    if ([typeLoadStr isEqualToString:@"image"])
    {
        NSString *ImageCellheightStr = [NSString stringWithFormat:@"%@",[imageHeightArr objectAtIndex:indexPath.row]];
        int height = [ImageCellheightStr intValue];
        return height;
    }
    else if ([typeLoadStr isEqualToString:@"video"])
    {
        NSString *videoCellheightStr = [NSString stringWithFormat:@"%@",[videoHeightArr objectAtIndex:indexPath.row]];
        int height = [videoCellheightStr intValue];
        return height;
    }
    else if ([typeLoadStr isEqualToString:@"text"])
    {
        NSString *textCellheightStr = [NSString stringWithFormat:@"%@",[textHeightArr objectAtIndex:indexPath.row]];
        int height = [textCellheightStr intValue];
        return height;
    }
    else if ([typeLoadStr isEqualToString:@"audio"])
    {
        NSString *audioCellheightStr = [NSString stringWithFormat:@"%@",[audioHeightArr objectAtIndex:indexPath.row]];
        int height = [audioCellheightStr intValue];
        return height;
    }
    return 280;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    static NSString *cellPPIdentifier = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellPPIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellPPIdentifier];
    }
    
    NSLog(@"%@",[[AllDataArr valueForKey:@"type"]objectAtIndex:indexPath.row]);
    NSString *typeLoadStr = [NSString stringWithFormat:@"%@",[[AllDataArr valueForKey:@"type"]objectAtIndex:indexPath.row]];
    
    if ([typeLoadStr isEqualToString:@"image"])
    {
        UIImageView *ProfileImage = (UIImageView *)[cell viewWithTag:1];
        ProfileImage.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[AllDataArr valueForKey:@"profile"]objectAtIndex:indexPath.row]]];
        NSLog(@"%@",[NSString stringWithFormat:@"%@",[[AllDataArr valueForKey:@"profile"]objectAtIndex:indexPath.row]]);
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:2];
        titleLabel.text = [NSString stringWithFormat:@"%@",[[AllDataArr valueForKey:@"title"]objectAtIndex:indexPath.row]];
        UILabel *subTitleLabel = (UILabel *)[cell viewWithTag:3];
        subTitleLabel.text = [NSString stringWithFormat:@"%@",[[AllDataArr valueForKey:@"sub_title"]objectAtIndex:indexPath.row]];
        UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:4];
        descriptionLabel.text = [NSString stringWithFormat:@"%@",[[AllDataArr valueForKey:@"description"]objectAtIndex:indexPath.row]];
        
        descriptionLabel.textAlignment = UITextAlignmentCenter;
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
        paragraphStyles.alignment = NSTextAlignmentJustified;      //justified text
        paragraphStyles.firstLineHeadIndent = 10.0;
        NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyles};
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString: descriptionLabel.text attributes: attributes];
        
        descriptionLabel.attributedText = attributedString;
        
        CGSize maximumLabelSize = CGSizeMake(descriptionLabel.frame.size.width, CGFLOAT_MAX);
        CGSize expectSize = [descriptionLabel sizeThatFits:maximumLabelSize];
        descriptionLabel.frame = CGRectMake(descriptionLabel.frame.origin.x, descriptionLabel.frame.origin.y, descriptionLabel.frame.size.width, expectSize.height);
        
        
        NSArray *imagesArr = [[AllDataArr valueForKey:@"image"]objectAtIndex:indexPath.row];
        
        UIView *contentV = (UIView *)[cell viewWithTag:6];
        contentV.frame = CGRectMake(0, descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + 5, self.view.frame.size.width, 50);
        UIScrollView *scroll = [[UIScrollView alloc]init];
        
        scroll.backgroundColor = [UIColor whiteColor];
        
        
        CGFloat y = 5;
        
        CGFloat lastcellweight = 0.0;
        CGFloat width = 0.0;
        CGFloat height = 0.0;
        CGFloat x = 0.0;
        int headerSport = (int) imagesArr.count;
        for (int i=0; i< headerSport; i++)
        {
            
            
            AsyncImageView *imgV = [[AsyncImageView alloc]init];
            NSString *url = [NSString stringWithFormat:@"%@",[[imagesArr valueForKey:@"img"] objectAtIndex:i]];
            imgV.imageURL = [NSURL URLWithString:url];
            UIButton *imgButton = [[UIButton alloc]init];
            
            
            if (i == 0) {
                NSString *indexStr = [NSString stringWithFormat:@"1001%d1001%ld",i,(long)indexPath.row];
                int index = [indexStr intValue];
                imgButton.tag = index;
            }
            else
            {
                NSString *indexStr = [NSString stringWithFormat:@"1001%d1001%ld",i,(long)indexPath.row];
                int index = [indexStr intValue];
                imgButton.tag = index;
            }
            
            
            int total = (int) imagesArr.count- 1 ;
            if( i == total)
            {
                
                imgV.frame = CGRectMake(x, y , 50, 50);
                imgButton.frame = CGRectMake(x, y , 50, 50);
                lastcellweight = imgV.frame.size.width;
                scroll.contentSize = CGSizeMake(imgV.frame.origin.x + imgV.frame.size.width + 30, imgV.frame.origin.y + imgV.frame.size.height);
                
                scroll.frame = CGRectMake(0, 0,self.view.frame.size.width, imgV.frame.origin.y + imgV.frame.size.height+10);
                NSInteger cellhieght = contentV.frame.size.height + contentV.frame.origin.y + 15;
                
                [imageHeightArr replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%ld",(long)cellhieght]];
                
            }
            else if (i == 0) {
                imgV.frame = CGRectMake(8, y , 50, 50);
                imgButton.frame = CGRectMake(8, y , 50, 50);
                x = x +5;
            }
            else
            {
                imgButton.frame = CGRectMake(x, y, 50, 50);
                imgV.frame = CGRectMake(x, y, 50, 50);
                
            }
            
            if (i==0)
            {
                y = imgV.frame.origin.y;
                width = imgV.frame.size.width;
                height = imgV.frame.size.height;
                x = imgV.frame.origin.x + width + 5;
                
                [scroll addSubview:imgV];
                [imgButton addTarget:self action:@selector(SelectedImageButton:) forControlEvents:UIControlEventTouchUpInside];
                [scroll addSubview:imgButton];
            }
            else
            {
                y = imgV.frame.origin.y ;
                width = imgV.frame.size.width;
                height = imgV.frame.size.height;
                x =imgV.frame.origin.x + height;
                [imgButton addTarget:self action:@selector(SelectedImageButton:) forControlEvents:UIControlEventTouchUpInside];
                [scroll addSubview:imgV];
                [scroll addSubview:imgButton];
            }
        }
        
        
        [contentV addSubview:scroll];
    }
    else if ([typeLoadStr isEqualToString:@"video"])
    {
        UIImageView *ProfileImage = (UIImageView *)[cell viewWithTag:1];
        ProfileImage.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[AllDataArr valueForKey:@"profile"]objectAtIndex:indexPath.row]]];
        NSLog(@"%@",[NSString stringWithFormat:@"%@",[[AllDataArr valueForKey:@"profile"]objectAtIndex:indexPath.row]]);
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:2];
        titleLabel.text = [NSString stringWithFormat:@"%@",[[AllDataArr valueForKey:@"title"]objectAtIndex:indexPath.row]];
        UILabel *subTitleLabel = (UILabel *)[cell viewWithTag:3];
        subTitleLabel.text = [NSString stringWithFormat:@"%@",[[AllDataArr valueForKey:@"sub_title"]objectAtIndex:indexPath.row]];
        UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:4];
        descriptionLabel.text = [NSString stringWithFormat:@"%@",[[AllDataArr valueForKey:@"description"]objectAtIndex:indexPath.row]];
        
        descriptionLabel.textAlignment = UITextAlignmentCenter;
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
        paragraphStyles.alignment = NSTextAlignmentJustified;      //justified text
        paragraphStyles.firstLineHeadIndent = 10.0;
        NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyles};
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString: descriptionLabel.text attributes: attributes];
        
        descriptionLabel.attributedText = attributedString;
        
        CGSize maximumLabelSize = CGSizeMake(descriptionLabel.frame.size.width, CGFLOAT_MAX);
        CGSize expectSize = [descriptionLabel sizeThatFits:maximumLabelSize];
        descriptionLabel.frame = CGRectMake(descriptionLabel.frame.origin.x, descriptionLabel.frame.origin.y, descriptionLabel.frame.size.width, expectSize.height);
        
        NSArray *VideoImageArr = [[AllDataArr valueForKey:@"video"]objectAtIndex:indexPath.row];
        
        UIView *contentV = (UIView *)[cell viewWithTag:6];
        contentV.frame = CGRectMake(0, descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + 5, self.view.frame.size.width, 50);
        UIScrollView *scroll = [[UIScrollView alloc]init];
        
        scroll.backgroundColor = [UIColor whiteColor];
        
        CGFloat y = 0;
        
        CGFloat lastcellweight = 0.0;
        CGFloat width = 0.0;
        CGFloat height = 0.0;
        CGFloat x = 0.0;
        int headerSport = (int) VideoImageArr.count;
        for (int i=0; i< headerSport; i++)
        {
            
            
            AsyncImageView *imgV = [[AsyncImageView alloc]init];
            // NSString *url = [NSString stringWithFormat:@"%@",[[VideoImageArr valueForKey:@"vid"] objectAtIndex:i]];
            // imgV.imageURL = [NSURL URLWithString:url];
            imgV.image = [UIImage imageNamed:@"Videothumb"];
            UIButton *imgButton = [[UIButton alloc]init];
            
            
            if (i == 0) {
                NSString *indexStr = [NSString stringWithFormat:@"1001%d1001%ld",i,(long)indexPath.row];
                int index = [indexStr intValue];
                imgButton.tag = index;
            }
            else
            {
                NSString *indexStr = [NSString stringWithFormat:@"1001%d1001%ld",i,(long)indexPath.row];
                int index = [indexStr intValue];
                imgButton.tag = index;
            }
            
            [imgButton addTarget:self action:@selector(SelectedVideoButton:) forControlEvents:UIControlEventTouchUpInside];
            int total = (int) VideoImageArr.count- 1 ;
            if( i == total)
            {
                
                imgV.frame = CGRectMake(x, y , 50, 50);
                imgButton.frame = CGRectMake(x, y , 50, 50);
                lastcellweight = imgV.frame.size.width;
                scroll.contentSize = CGSizeMake(imgV.frame.origin.x + imgV.frame.size.width + 30, imgV.frame.origin.y + imgV.frame.size.height);
                
                scroll.frame = CGRectMake(0, 0,self.view.frame.size.width, imgV.frame.origin.y + imgV.frame.size.height+10);
                NSInteger cellhieght = contentV.frame.size.height + contentV.frame.origin.y + 15;
                
                [videoHeightArr replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%ld",(long)cellhieght]];
                
            }
            else if (i == 0) {
                imgV.frame = CGRectMake(8, y , 50, 50);
                imgButton.frame = CGRectMake(8, y , 50, 50);
                x = x +5;
            }
            else
            {
                
                imgV.frame = CGRectMake(x, y, 50, 50);
                imgButton.frame = CGRectMake(x, y, 50, 50);
            }
            
            if (i==0)
            {
                y = imgV.frame.origin.y;
                width = imgV.frame.size.width;
                height = imgV.frame.size.height;
                x = imgV.frame.origin.x + width + 5;
                
                [scroll addSubview:imgV];
                [scroll addSubview:imgButton];
            }
            else
            {
                y = imgV.frame.origin.y ;
                width = imgV.frame.size.width;
                height = imgV.frame.size.height;
                x =imgV.frame.origin.x + height;
                
                [scroll addSubview:imgV];
                [scroll addSubview:imgButton];
            }
        }
        
        
        [contentV addSubview:scroll];
    }
    else if ([typeLoadStr isEqualToString:@"audio"])
    {
        
        ///      Audio
        UIImageView *ProfileImage = (UIImageView *)[cell viewWithTag:1];
        ProfileImage.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[AllDataArr valueForKey:@"profile"]objectAtIndex:indexPath.row]]];
        NSLog(@"%@",[NSString stringWithFormat:@"%@",[[AllDataArr valueForKey:@"profile"]objectAtIndex:indexPath.row]]);
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:2];
        titleLabel.text = [NSString stringWithFormat:@"%@",[[AllDataArr valueForKey:@"title"]objectAtIndex:indexPath.row]];
        UILabel *subTitleLabel = (UILabel *)[cell viewWithTag:3];
        subTitleLabel.text = [NSString stringWithFormat:@"%@",[[AllDataArr valueForKey:@"sub_title"]objectAtIndex:indexPath.row]];
        UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:4];
        descriptionLabel.text = [NSString stringWithFormat:@"%@",[[AllDataArr valueForKey:@"description"]objectAtIndex:indexPath.row]];
        
        descriptionLabel.textAlignment = UITextAlignmentCenter;
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
        paragraphStyles.alignment = NSTextAlignmentJustified;      //justified text
        paragraphStyles.firstLineHeadIndent = 10.0;
        NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyles};
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString: descriptionLabel.text attributes: attributes];
        
        descriptionLabel.attributedText = attributedString;
        
        CGSize maximumLabelSize = CGSizeMake(descriptionLabel.frame.size.width, CGFLOAT_MAX);
        CGSize expectSize = [descriptionLabel sizeThatFits:maximumLabelSize];
        descriptionLabel.frame = CGRectMake(descriptionLabel.frame.origin.x, descriptionLabel.frame.origin.y, descriptionLabel.frame.size.width, expectSize.height);
        
        
        NSArray *AudioImageArr = [[AllDataArr valueForKey:@"audio"]objectAtIndex:indexPath.row];
        
        UIView *contentV = (UIView *)[cell viewWithTag:6];
        contentV.frame = CGRectMake(0, descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + 5, self.view.frame.size.width, 50);
        UIScrollView *scroll = [[UIScrollView alloc]init];
        
        scroll.backgroundColor = [UIColor whiteColor];
        
        CGFloat y = 0;
        
        CGFloat lastcellweight = 0.0;
        CGFloat width = 0.0;
        CGFloat height = 0.0;
        CGFloat x = 0.0;
        int headerSport = (int) AudioImageArr.count;
        for (int i=0; i< headerSport; i++)
        {
            
            
            AsyncImageView *imgV = [[AsyncImageView alloc]init];
            // NSString *url = [NSString stringWithFormat:@"%@",[[AudioImageArr valueForKey:@"audio"] objectAtIndex:i]];
            // imgV.imageURL = [NSURL URLWithString:url];
            imgV.image = [UIImage imageNamed:@"AudioPlayButton"];
            UIButton *imgButton = [[UIButton alloc]init];
            
            if (i == 0) {
                NSString *indexStr = [NSString stringWithFormat:@"1001%d1001%ld",i,(long)indexPath.row];
                int index = [indexStr intValue];
                imgButton.tag = index;
            }
            else
            {
                NSString *indexStr = [NSString stringWithFormat:@"1001%d1001%ld",i,(long)indexPath.row];
                int index = [indexStr intValue];
                imgButton.tag = index;
            }
            
            
            [imgButton addTarget:self action:@selector(SelectedAudioButton:) forControlEvents:UIControlEventTouchUpInside];
            int total = (int) AudioImageArr.count- 1 ;
            
            
            if( i == total)
            {
                
                imgV.frame = CGRectMake(x, y , 50, 50);
                imgButton.frame = CGRectMake(x, y , 50, 50);
                lastcellweight = imgV.frame.size.width;
                scroll.contentSize = CGSizeMake(imgV.frame.origin.x + imgV.frame.size.width + 30, imgV.frame.origin.y + imgV.frame.size.height);
                
                scroll.frame = CGRectMake(0, 0,self.view.frame.size.width, imgV.frame.origin.y + imgV.frame.size.height+10);
                NSInteger cellhieght = contentV.frame.size.height + contentV.frame.origin.y + 15;
                
                [audioHeightArr replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%ld",(long)cellhieght]];
                
            }
            else if (i == 0) {
                imgV.frame = CGRectMake(8, y , 50, 50);
                imgButton.frame = CGRectMake(8, y , 50, 50);
                x = x +5;
            }
            else
            {
                imgButton.frame = CGRectMake(x, y, 50, 50);
                imgV.frame = CGRectMake(x, y, 50, 50);
                
            }
            
            if (i==0)
            {
                y = imgV.frame.origin.y;
                width = imgV.frame.size.width;
                height = imgV.frame.size.height;
                x = imgV.frame.origin.x + width + 5;
                
                [scroll addSubview:imgV];
                [scroll addSubview:imgButton];
            }
            else
            {
                y = imgV.frame.origin.y ;
                width = imgV.frame.size.width;
                height = imgV.frame.size.height;
                x =imgV.frame.origin.x + height;
                
                [scroll addSubview:imgV];
                [scroll addSubview:imgButton];
            }
        }
        
        
        [contentV addSubview:scroll];
    }
    else if ([typeLoadStr isEqualToString:@"text"])
    {
        
        ///      Audio
        UIImageView *ProfileImage = (UIImageView *)[cell viewWithTag:1];
        ProfileImage.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[AllDataArr valueForKey:@"profile"]objectAtIndex:indexPath.row]]];
        NSLog(@"%@",[NSString stringWithFormat:@"%@",[[AllDataArr valueForKey:@"profile"]objectAtIndex:indexPath.row]]);
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:2];
        titleLabel.text = [NSString stringWithFormat:@"%@",[[AllDataArr valueForKey:@"title"]objectAtIndex:indexPath.row]];
        UILabel *subTitleLabel = (UILabel *)[cell viewWithTag:3];
        subTitleLabel.text = [NSString stringWithFormat:@"%@",[[AllDataArr valueForKey:@"sub_title"]objectAtIndex:indexPath.row]];
        UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:4];
        descriptionLabel.text = [NSString stringWithFormat:@"%@",[[AllDataArr valueForKey:@"description"]objectAtIndex:indexPath.row]];
        
        descriptionLabel.textAlignment = UITextAlignmentCenter;
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
        paragraphStyles.alignment = NSTextAlignmentJustified;      //justified text
        paragraphStyles.firstLineHeadIndent = 10.0;
        NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyles};
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString: descriptionLabel.text attributes: attributes];
        
        descriptionLabel.attributedText = attributedString;
        
        CGSize maximumLabelSize = CGSizeMake(descriptionLabel.frame.size.width, CGFLOAT_MAX);
        CGSize expectSize = [descriptionLabel sizeThatFits:maximumLabelSize];
        descriptionLabel.frame = CGRectMake(descriptionLabel.frame.origin.x, descriptionLabel.frame.origin.y, descriptionLabel.frame.size.width, expectSize.height);
        
        
        
        UIView *contentV = (UIView *)[cell viewWithTag:6];
        contentV.frame = CGRectMake(5, descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + 5, 50, 50);
        
        UILabel *OthertextLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        NSString *TextArr = [[AllDataArr valueForKey:@"text"]objectAtIndex:indexPath.row];
        OthertextLabel.text = [NSString stringWithFormat:@"%@",[[TextArr valueForKey:@"text"]objectAtIndex:0]];
        
        OthertextLabel.textAlignment = UITextAlignmentCenter;
        OthertextLabel.numberOfLines = 0;
        OthertextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        OthertextLabel.font = [UIFont boldSystemFontOfSize:12];
        NSMutableParagraphStyle *OtherparagraphStyles = [[NSMutableParagraphStyle alloc] init];
        OtherparagraphStyles.alignment = NSTextAlignmentJustified;      //justified text
        OtherparagraphStyles.firstLineHeadIndent = 10.0;
        
        NSDictionary *attributesother = @{NSParagraphStyleAttributeName: OtherparagraphStyles};
        NSAttributedString *attributedOtherString = [[NSAttributedString alloc] initWithString: OthertextLabel.text attributes: attributesother];
        
        OthertextLabel.attributedText = attributedOtherString;
        
        CGSize maximumLabelSizeOther = CGSizeMake(OthertextLabel.frame.size.width, CGFLOAT_MAX);
        CGSize expectSizeOther = [OthertextLabel sizeThatFits:maximumLabelSizeOther];
        OthertextLabel.frame = CGRectMake(OthertextLabel.frame.origin.x, OthertextLabel.frame.origin.y, OthertextLabel.frame.size.width, expectSizeOther.height);
        
        [contentV addSubview:OthertextLabel];
        NSInteger cellhieght = contentV.frame.size.height + contentV.frame.origin.y;
        
        [textHeightArr replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%ld",(long)cellhieght]];
    }
    
    
    return  cell;
}

-(void)SelectedAudioButton:sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"Audio%ld",(long)btn.tag);
    
    NSString * str =[NSString stringWithFormat:@"%ld",(long)btn.tag];
    NSArray * arr = [str componentsSeparatedByString:@"1001"];
    NSLog(@"Array values are : %@",arr);
    NSInteger SubIndex = [[arr objectAtIndex:1]intValue];;
    NSInteger MainIndex = [[arr objectAtIndex:2]intValue];
    NSLog(@"Array values are :s %ld m %ld",(long)SubIndex,(long)MainIndex);
    
    NSArray *AudioImageArr = [[AllDataArr valueForKey:@"audio"]objectAtIndex:MainIndex];
    
    NSString *audioString = [NSString stringWithFormat:@"%@",[[AudioImageArr valueForKey:@"audio"] objectAtIndex:SubIndex]];
    NSLog(@"Array values are :s %@",audioString);
    //    NSArray *musicArr = [musicContentArr objectAtIndex:indexPath.row];
    //  NSString *musicFileStr = [NSString stringWithFormat:@"%@",[musicArr objectAtIndex:0]];
    
    NSString* urlTextEscaped = [audioString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString: urlTextEscaped];
    
    MPMoviePlayerViewController *controller = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [self presentMoviePlayerViewControllerAnimated:controller];
    
    
}

-(void)SelectedImageButton:Sender
{
    UIButton *btn = (UIButton *)Sender;
    NSLog(@"Video%ld",(long)btn.tag);
    NSString * str =[NSString stringWithFormat:@"%ld",(long)btn.tag];
    NSArray * arr = [str componentsSeparatedByString:@"1001"];
    NSLog(@"Array values are : %@",arr);
    NSInteger SubIndex = [[arr objectAtIndex:1]intValue];;
    NSInteger MainIndex = [[arr objectAtIndex:2]intValue];
    NSLog(@"Array values are :s %ld m %ld",(long)SubIndex,(long)MainIndex);
    
    NSArray *VideoImageArr = [[AllDataArr valueForKey:@"image"]objectAtIndex:MainIndex];
    
    NSString *VideoString = [NSString stringWithFormat:@"%@",[[VideoImageArr valueForKey:@"img"] objectAtIndex:SubIndex]];
    NSLog(@"Array values are :s %@",VideoString);
    NSString* urlTextEscaped = [VideoString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    fullImageShowView.hidden=NO;
    
    fullImageV.imageURL = [NSURL URLWithString:urlTextEscaped];
}

-(IBAction)backimagefullBtnPressed:(id)sender
{
    fullImageShowView.hidden=YES;
}
-(void)SelectedVideoButton:Sender
{
    UIButton *btn = (UIButton *)Sender;
    NSLog(@"Video%ld",(long)btn.tag);
    NSString * str =[NSString stringWithFormat:@"%ld",(long)btn.tag];
    NSArray * arr = [str componentsSeparatedByString:@"1001"];
    NSLog(@"Array values are : %@",arr);
    NSInteger SubIndex = [[arr objectAtIndex:1]intValue];;
    NSInteger MainIndex = [[arr objectAtIndex:2]intValue];
    NSLog(@"Array values are :s %ld m %ld",(long)SubIndex,(long)MainIndex);
    
    NSArray *VideoImageArr = [[AllDataArr valueForKey:@"video"]objectAtIndex:MainIndex];
    
    NSString *VideoString = [NSString stringWithFormat:@"%@",[[VideoImageArr valueForKey:@"vid"] objectAtIndex:SubIndex]];
    NSLog(@"Array values are :s %@",VideoString);
    NSString* urlTextEscaped = [VideoString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *videoURL = [NSURL URLWithString:urlTextEscaped];
    //    moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    //    [moviePlayerController setControlStyle:MPMovieControlStyleNone];
    //    moviePlayerController.scalingMode = MPMovieScalingModeAspectFit;
    //    [moviePlayerController.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y , self.view.frame.size.width, self.view.frame.size.height)];
    //    [self.view addSubview:moviePlayerController.view];
    //
    //    [moviePlayerController prepareToPlay];
    //    [moviePlayerController play];
    MPMoviePlayerViewController *controller = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    [self presentMoviePlayerViewControllerAnimated:controller];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSArray *musicArr = [musicContentArr objectAtIndex:indexPath.row];
    //        NSString *musicFileStr = [NSString stringWithFormat:@"%@",[musicArr objectAtIndex:0]];
    //
    //        NSString* urlTextEscaped = [musicFileStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //        NSURL *url = [NSURL URLWithString: urlTextEscaped];
    //
    //        MPMoviePlayerViewController *controller = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    //        [self presentMoviePlayerViewControllerAnimated:controller];
    
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
