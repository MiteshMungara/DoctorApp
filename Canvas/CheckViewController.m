//
//  CheckViewController.m
//  Bittencourt Property
//
//  Created by iSquare5 on 09/07/15.
//  Copyright (c) 2015 MitSoft. All rights reserved.
//

#import "CheckViewController.h"
#import "CheckTableViewCell.h"
#import "ClientDetailViewController.h"
#import "Base64.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "AsyncImageView.h"
@interface CheckViewController ()
{
    NSArray *upidarr;
    NSMutableArray *checkupidarr;
    NSMutableArray *namearray;
    NSString *lastIndexPath;
    NSMutableArray *checkArray;
    NSMutableArray *negativeArray;
    NSMutableArray *noteArray;
    NSMutableArray *cameraArray;
    NSArray *recipeImages;
    NSMutableArray *imageArray;
    NSMutableArray *noteTextArr;
    NSMutableArray *imageFillArr;
    UITextField *nameTextfield;
    NSString *namestring;
    NSMutableArray *imageUpdateArr;
    NSMutableArray *imagecellupdate;
    NSString *removeItem;
    //=============================
    UIImage *imagePick;
    //================================
    NSMutableArray *copycheckarray;
    NSMutableArray *copynegativearray;
    NSMutableArray *copynoteArray;
    NSMutableArray *copynamearray;
    NSMutableArray *imagesUpdateallarray;
    NSMutableArray *copyimagecellarray;
    NSMutableArray *noteUpdateallarray;
    NSMutableArray *copynotecellarray;
    NSArray *dateedit;
    NSString *theDate;
    //===============================
    NSArray *fnamearray;
    NSArray *lnamearray;
    NSArray *addressarray;
    NSArray *emailarray;
    //NSString *emailStr;
}
//Button for fetch image
@property (nonatomic,strong) UIButton * Gallery;
@property(nonatomic,strong)UIButton *Camera;
@property(nonatomic,strong)UIImageView *cellImageView;
@property (strong, nonatomic) NSString* name;
@end
int collectionviewselectindexpathrowno;
int historyInt=0;
@implementation CheckViewController
@synthesize listTableV = listTableV;
@synthesize addressTextField;
@synthesize probnameedit,statusedit,noteviewedit,imageviewedit,historyupdate;

- (void)viewDidLoad {
    [super viewDidLoad];
    emailarray=[[NSMutableArray alloc]init];
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    app=[[UIApplication sharedApplication]delegate];
  //  NSLog(@"check id: %@",app.checkupidstr);
      // listTableV.allowsSelection = NO;
    copycheckarray = [[NSMutableArray alloc]init];
    copynegativearray = [[NSMutableArray alloc]init];
    copynoteArray = [[NSMutableArray alloc]init];
     copynamearray = [[NSMutableArray alloc]init];
    checkupidarr = [[NSMutableArray alloc]init];
    imagesUpdateallarray = [[NSMutableArray alloc]init];
    copyimagecellarray = [[NSMutableArray alloc]init];
    noteUpdateallarray = [[NSMutableArray alloc]init];
    copynotecellarray = [[NSMutableArray alloc]init];
    
    if ([[Reachability sharedReachability]internetConnectionStatus]==NotReachable)
    {
        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Check Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
    }
    else
    {
    [NSTimer scheduledTimerWithTimeInterval:0.1f
                                     target:self
                                   selector:@selector(dataLoadFromServer)
                                   userInfo:nil
                                    repeats:NO];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
   if(historyInt == 1)
    {
        [NSTimer scheduledTimerWithTimeInterval:0.1f
                                         target:self
                                       selector:@selector(dataLoadFromServer)
                                       userInfo:nil
                                       repeats:NO];
    }
}
-(void)dataLoadFromServer
{
    //set date and time
    nameTextfield.delegate = self;
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"hh:mm"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    dateFormatter.dateFormat = @"yyyy-MM-dd ";
    timeLab.text=dateString;
    [dateFormatter setDateFormat:@"MMM"];
    NSString *stringMonth = [dateFormatter stringFromDate:currDate];
    monthLab.text=stringMonth;
    [dateFormatter setDateFormat:@"dd"];
    NSString *stringDateno = [dateFormatter stringFromDate:currDate];
    dateLab.text =stringDateno;
    [dateFormatter setDateFormat:@"YYYY"];
    NSString *stringday = [dateFormatter stringFromDate:currDate];
    dayLab.text=stringday;
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://app.bittencourtproperty.com/bittencourt_api/get_address.php"];
    NSURL *url = [NSURL URLWithString:urlString];
   
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *myRequestString =[NSString stringWithFormat:@"{\"u_id\":\"%@\",\"client_info\":\"%@\"}",app.uidStr,@"client_info"];
    NSData *requestData = [NSData dataWithBytes:[myRequestString UTF8String] length:[myRequestString length]];
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: requestData];
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:nil];
    
    //  NSString *typescan = [[jsonDictionary valueForKey:@"posts"]valueForKey:@"fname"];
    fnamearray = [[jsonDictionary valueForKey:@"posts"]valueForKey:@"fname"];
    lnamearray = [[jsonDictionary valueForKey:@"posts"]valueForKey:@"lname"];
    addressarray = [[[jsonDictionary valueForKey:@"posts"]valueForKey:@"property_adderss"]valueForKey:@"address"];
    emailarray = [[jsonDictionary valueForKey:@"posts"]valueForKey:@"email"];
    
    
    [[NSUserDefaults standardUserDefaults] objectForKey:@"foo"];
    addressTextField.text =app.addressclient;
    
    //===============================================
   if(![app.historyupdate isEqualToString:@"1"])
   {
    
           checkupidarr = app.checkupidarr;
           
           namearray = [[NSMutableArray alloc]init];
           namearray = [probnameedit mutableCopy];
           checkArray = [[NSMutableArray alloc]init];
           negativeArray = [[NSMutableArray alloc]init];
           
           for(int i = 0; i<statusedit.count;i++)
           {
               [checkArray addObject:@"0"];
               [negativeArray addObject:@"0"];
               if([[statusedit objectAtIndex:i]isEqualToString:@"No selected"])
               {
                   
               }
               else if([[statusedit objectAtIndex:i]isEqualToString:@"Good"])
               {
                   [checkArray replaceObjectAtIndex:i withObject:@"1"];
                   
               }
               else{
                   [negativeArray replaceObjectAtIndex:i withObject:@"1"];
                   
               }
           }
       
       
       noteArray = [[NSMutableArray alloc]init];
       noteTextArr = [[NSMutableArray alloc]init];
       noteTextArr = [noteviewedit mutableCopy];
       for(int i = 0; i<noteviewedit.count;i++)
       {
           [noteArray addObject:@""];
           [noteUpdateallarray addObject:@"0"];
           [copynotecellarray addObject:@"0"];
           if(![[noteviewedit objectAtIndex:i]isEqualToString:@""])
           {
               [noteArray replaceObjectAtIndex:i withObject:@"1"];
               
           }
           
       }
       
       cameraArray = [[NSMutableArray alloc]init];
       imageFillArr = [[NSMutableArray alloc]init];
       imageArray = [[NSMutableArray alloc]init];
       
       imagecellupdate = [[NSMutableArray alloc]init];
       imageUpdateArr = [[NSMutableArray alloc]init];
       
       for(int i=0;i<probnameedit.count;i++)
       {
           //imageupdate array
           [imagecellupdate addObject:@"0"];
           [imageUpdateArr addObject:@"no"];
       }
       for(int i = 0; i<imageviewedit.count;i++)
       {
           [cameraArray addObject:@"0"];
           [imageFillArr addObject:@"no"];
           [imageArray addObject:@"no"];
           [imagesUpdateallarray addObject:@"0"];
           [copyimagecellarray addObject:@"0"];
           if(![[imageviewedit objectAtIndex:i]isEqualToString:@"http://app.bittencourtproperty.com/bittencourt_api/item_picture/no.jpg"])
           {
               [imageArray replaceObjectAtIndex:i withObject:[imageviewedit objectAtIndex:i]];
               [imageFillArr replaceObjectAtIndex:i withObject:@"yes"];
               [cameraArray replaceObjectAtIndex:i withObject:@"1"];
               
           }
           else
           {
               [imageArray replaceObjectAtIndex:i withObject:@"no"];
               [imageFillArr replaceObjectAtIndex:i withObject:@"no"];
               [cameraArray replaceObjectAtIndex:i withObject:@"0"];
           }
       }
       
           copycheckarray =[checkArray mutableCopy] ;
           copynegativearray = [negativeArray mutableCopy];
           // copynoteArray = [noteArray mutableCopy];
           copynamearray = [namearray mutableCopy];
           
       

   }
else
{
    urlString =nil;
    url=nil;
    urlString = [[NSString alloc]initWithFormat:@"http://app.bittencourtproperty.com/bittencourt_api/get_item_all.php"];
    url = [NSURL URLWithString:urlString];
    
    request=nil;
    request = [NSMutableURLRequest requestWithURL:url];
    myRequestString=nil;
    myRequestString =[NSString stringWithFormat:@"{\"u_id\":\"%@\",\"address\":\"%@\"}",app.uidStr,app.addressclient];
    requestData=nil;
    requestData = [NSData dataWithBytes:[myRequestString UTF8String] length:[myRequestString length]];
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: requestData];
    error=nil;
    response=nil;
    urlData = nil;
    urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    jsonDictionary=nil;
    jsonDictionary = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:nil];
    
    //  NSString *typescan = [[jsonDictionary valueForKey:@"posts"]valueForKey:@"fname"];
    upidarr = [[jsonDictionary valueForKey:@"posts"]valueForKey:@"id"];
    probnameedit = [[jsonDictionary valueForKey:@"posts"]valueForKey:@"problemname"];
    statusedit = [[jsonDictionary valueForKey:@"posts"]valueForKey:@"status"];
    noteviewedit = [[jsonDictionary valueForKey:@"posts"]valueForKey:@"note"];
    imageviewedit = [[jsonDictionary valueForKey:@"posts"]valueForKey:@"image"];
    dateedit = [[jsonDictionary valueForKey:@"posts"]valueForKey:@"date"];
    //   emailarray = [[jsonDictionary valueForKey:@"posts"]valueForKey:@"note"];
    
    //NSArray *datesarray = [dateedit sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"date : %@",theDate);
    
    NSDate *now = [[NSDate alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    theDate = [dateFormat stringFromDate:now];
    
    
    
    NSString *date = [NSString stringWithFormat:@"%@",[dateedit objectAtIndex:0] ];
    
        checkupidarr = [upidarr mutableCopy];
        if (probnameedit.count == 0)
        {
            namearray = [[NSMutableArray alloc]init];
            checkArray =[NSMutableArray arrayWithObjects:@"0",nil];
            negativeArray =[NSMutableArray arrayWithObjects:@"0",nil];
            noteArray=[NSMutableArray arrayWithObjects:@"0",nil];
            cameraArray=[NSMutableArray arrayWithObjects:@"0",nil];
            imageArray=[NSMutableArray arrayWithObjects:@"no",nil];
            noteTextArr = [NSMutableArray arrayWithObjects:@"",nil];
            imageFillArr = [NSMutableArray arrayWithObjects:@"no",nil];
    
            imagecellupdate =[NSMutableArray arrayWithObjects:@"0",nil];
            imageUpdateArr = [NSMutableArray arrayWithObjects:@"no",nil];
            
            checkupidarr = [NSMutableArray arrayWithObjects:@"insert",nil];
            copynamearray = [NSMutableArray arrayWithObjects:@"",nil];
            copycheckarray = [NSMutableArray arrayWithObjects:@"",nil];
            copynegativearray =[NSMutableArray arrayWithObjects:@"",nil];
            copynoteArray =[NSMutableArray arrayWithObjects:@"",nil];
            imagesUpdateallarray = [NSMutableArray arrayWithObjects:@"no",nil];
            copyimagecellarray = [NSMutableArray arrayWithObjects:@"no",nil];
            noteUpdateallarray = [NSMutableArray arrayWithObjects:@"0",nil];
            copynotecellarray =[NSMutableArray arrayWithObjects:@"0",nil];

            [self newrowadd];
        }
        else
        {
            namearray = [[NSMutableArray alloc]init];
            checkArray = [[NSMutableArray alloc]init];
            negativeArray = [[NSMutableArray alloc]init];
            noteArray = [[NSMutableArray alloc]init];
            noteTextArr = [[NSMutableArray alloc]init];
            cameraArray = [[NSMutableArray alloc]init];
            imageFillArr = [[NSMutableArray alloc]init];
            imageArray = [[NSMutableArray alloc]init];
            
            imagecellupdate = [[NSMutableArray alloc]init];
            imageUpdateArr = [[NSMutableArray alloc]init];
            
           if(![theDate isEqualToString:date])
           {
               for(int i=0;i< dateedit.count;i++)
               {
                   if ([[dateedit objectAtIndex:i] isEqualToString:date])
                   {
                       NSLog(@"__%d",i);
                       [namearray addObject:[probnameedit objectAtIndex:i]];
                       
                       [checkArray addObject:@"0"];
                       [negativeArray addObject:@"0"];
                       
                       [noteTextArr addObject:@""];
                       [noteArray addObject:@"0"];
                       [noteUpdateallarray addObject:@"0"];
                       [copynotecellarray addObject:@"0"];
                       [imagecellupdate addObject:@"0"];
                       [imageUpdateArr addObject:@"no"];
                       
                       [cameraArray addObject:@"0"];
                       [imageFillArr addObject:@"no"];
                       [imageArray addObject:@"no"];
                       [imagesUpdateallarray addObject:@"0"];
                       [copyimagecellarray addObject:@"0"];
                       //[imageArray addObject:@"no"];
                       //[imageFillArr addObject:@"no"];
                       [cameraArray addObject:@"0"];
   
                   }
               }
               
               //for (int i=0; i<probnameedit.count; i++) {
                 //  [namearray addObject:@""];
              // }
              
              /* for(int i = 0; i<statusedit.count;i++)
               {
                   [checkArray addObject:@"0"];
                   [negativeArray addObject:@"0"];
                   if([[statusedit objectAtIndex:i]isEqualToString:@"No selected"])
                   {
                       
                   }
                   else if([[statusedit objectAtIndex:i]isEqualToString:@"Good"])
                   {
                       [checkArray replaceObjectAtIndex:i withObject:@"0"];
                       
                   }
                   else{
                       [negativeArray replaceObjectAtIndex:i withObject:@"0"];
                       
                   }
               }
               noteArray = [[NSMutableArray alloc]init];
               noteTextArr = [[NSMutableArray alloc]init];
               // noteTextArr = [noteviewedit mutableCopy];
               for(int i = 0; i<noteviewedit.count;i++)
               {
                   [noteTextArr addObject:@""];
                   [noteArray addObject:@"0"];
                   [noteUpdateallarray addObject:@"0"];
                   [copynotecellarray addObject:@"0"];
                   if(![[noteviewedit objectAtIndex:i]isEqualToString:@""])
                   {
                       [noteArray replaceObjectAtIndex:i withObject:@"0"];
                       
                   }
                   
               }
               
               cameraArray = [[NSMutableArray alloc]init];
               imageFillArr = [[NSMutableArray alloc]init];
               imageArray = [[NSMutableArray alloc]init];
               
               imagecellupdate = [[NSMutableArray alloc]init];
               imageUpdateArr = [[NSMutableArray alloc]init];
               
               for(int i=0;i<probnameedit.count;i++)
               {
                   //imageupdate array
                   [imagecellupdate addObject:@"0"];
                   [imageUpdateArr addObject:@"no"];
               }
               for(int i = 0; i<imageviewedit.count;i++)
               {
                   [cameraArray addObject:@"0"];
                   [imageFillArr addObject:@"no"];
                   [imageArray addObject:@"no"];
                   [imagesUpdateallarray addObject:@"0"];
                   [copyimagecellarray addObject:@"0"];
                   if(![[imageviewedit objectAtIndex:i]isEqualToString:@"http://gonuts4appsclient.com/bittencourt/item_picture/no.jpg"])
                   {
                       [imageArray replaceObjectAtIndex:i withObject:@"no"];
                       [imageFillArr replaceObjectAtIndex:i withObject:@"no"];
                       [cameraArray replaceObjectAtIndex:i withObject:@"0"];
                       
                   }
                   else
                   {
                       [imageArray replaceObjectAtIndex:i withObject:@"no"];
                       [imageFillArr replaceObjectAtIndex:i withObject:@"no"];
                       [cameraArray replaceObjectAtIndex:i withObject:@"0"];
                   }
               }
               */
             //  copycheckarray =[checkArray mutableCopy] ;
             //  copynegativearray = [negativeArray mutableCopy];
               // copynoteArray = [noteArray mutableCopy];
                  [checkupidarr removeAllObjects];
               for (int i=0; i< namearray.count; i++) {
                   [copynamearray addObject:@""];
                   [checkupidarr addObject:@"insert"];
                  [copycheckarray addObject:@""];
                   [copynegativearray addObject:@""];
                     [copynoteArray addObject:@""];
               }
               //copynamearray = [namearray mutableCopy];
               
           }
           else
           {
               [checkupidarr removeAllObjects];
               namearray = [[NSMutableArray alloc]init];
               checkArray = [[NSMutableArray alloc]init];
               negativeArray = [[NSMutableArray alloc]init];
               noteArray = [[NSMutableArray alloc]init];
               noteTextArr = [[NSMutableArray alloc]init];
               cameraArray = [[NSMutableArray alloc]init];
               imageFillArr = [[NSMutableArray alloc]init];
               imageArray = [[NSMutableArray alloc]init];
               
               imagecellupdate = [[NSMutableArray alloc]init];
               imageUpdateArr = [[NSMutableArray alloc]init];
               
               for (int i=0; i< dateedit.count ; i++)
               {
                   if ([[dateedit objectAtIndex:i] isEqualToString:theDate])
                   {
                       NSLog(@"__%d",i);
                       
                       [namearray addObject:[probnameedit objectAtIndex:i]];
                       [checkupidarr addObject:[upidarr objectAtIndex:i]];
                       
                      
                       
                           
                           if([[statusedit objectAtIndex:i]isEqualToString:@"No selected"])
                           {
                               [checkArray addObject:@"0"];
                               [negativeArray addObject:@"0"];
                           }
                           else if([[statusedit objectAtIndex:i]isEqualToString:@"Good"])
                           {
                              // [checkArray replaceObjectAtIndex:i withObject:@"1"];
                               [checkArray addObject:@"1"];
                               [negativeArray addObject:@"0"];
                           }
                           else if([[statusedit objectAtIndex:i]isEqualToString:@"Bad"])
                           {
                               [negativeArray addObject:@"1"];
                                [checkArray addObject:@"0"];
                               //[negativeArray replaceObjectAtIndex:i withObject:@"1"];
                               
                           }
                           else
                           {
                               [checkArray addObject:@"0"];
                               [negativeArray addObject:@"0"];
                           }
                       
                       [noteTextArr addObject:[noteviewedit objectAtIndex:i]];
                      
                       
                           [noteUpdateallarray addObject:@"0"];
                           [copynotecellarray addObject:@"0"];
                           if(![[noteviewedit objectAtIndex:i]isEqualToString:@""])
                           {
                              // [noteArray replaceObjectAtIndex:i withObject:@"1"];
                               [noteArray addObject:@"1"];
                           }
                       else
                       {
                            [noteArray addObject:@"0"];
                       }
                           
                       
                       
                           //imageupdate array
                           [imagecellupdate addObject:@"0"];
                           [imageUpdateArr addObject:@"no"];
                       
                                              
                           [imagesUpdateallarray addObject:@"0"];
                           [copyimagecellarray addObject:@"0"];
                           if(![[imageviewedit objectAtIndex:i]isEqualToString:@"http://app.bittencourtproperty.com/bittencourt_api/item_picture/no.jpg"])
                           {
                               
                              // [imageArray replaceObjectAtIndex:i withObject:[imageviewedit objectAtIndex:i]];
                               [imageArray addObject:[imageviewedit objectAtIndex:i]];
                               NSLog(@"__%@",imageArray);
                               [imageFillArr addObject:@"yes"];
                             //[imageUpdateArr addObject:@"yes"];
                               [cameraArray addObject:@"1"];
                              // [imageFillArr replaceObjectAtIndex:i withObject:@"yes"];
                               //[cameraArray replaceObjectAtIndex:i withObject:@"1"];
                               
                           }
                           else
                           {
                              // [imageUpdateArr addObject:@"no"];
                               [imageFillArr addObject:@"no"];
                               [imageArray addObject:@"no"];
                               [cameraArray addObject:@"0"];
                              // [imageArray replaceObjectAtIndex:i withObject:@"no"];
                             //  [imageFillArr replaceObjectAtIndex:i withObject:@"no"];
                              // [cameraArray replaceObjectAtIndex:i withObject:@"0"];
                           }
                       
                   }
               }
          
               copycheckarray =[checkArray mutableCopy] ;
               copynegativearray = [negativeArray mutableCopy];
               // copynoteArray = [noteArray mutableCopy];
               copynamearray = [namearray mutableCopy];
               


           }
           //
        }
   // }

}
    
    
    
    [listTableV reloadData];
    [Collectview reloadData];
}





-(void)newrowadd
{
    NSString *string = @"";
    [namearray addObject:string];

}
#pragma mark - back Button for Note.....
- (IBAction)backBtnOfNotePressed:(id)sender
{
   // UITextView *noteTypeTV = (UITextView *)sender;
  //  CheckTableViewCell *buttonCell = (CheckTableViewCell *)noteTypeTV.superview.superview;
  //  NSIndexPath* pathOfTheCell = [listTableV indexPathForCell:buttonCell];
   // UITextView *noteTypeTV = (UITextView *)sender;
    //CheckTableViewCell *noteCell = (CheckTableViewCell *)noteTypeTV.superview.superview;
   // NSIndexPath* pathOfTheCell = [listTableV indexPathForCell:noteCell];
  //  NSLog(@"pathOfTheCell :%ld",(long)pathOfTheCell.row);
   // noteRow = [pathOfTheCell row];
    
    if ([[noteArray objectAtIndex:noteRow] isEqualToString:@"1"])
    {
        NSString *noteString=noteTextView.text;
        if([noteString isEqualToString:@""])
        {
            noteView.hidden=YES;
            [noteArray replaceObjectAtIndex:noteRow withObject:@"0"];
             [noteTextArr replaceObjectAtIndex:noteRow withObject:@""];
          //  noteTextView.text = [noteTextArr objectAtIndex:pathOfTheCell.row];
        }
        else
        {
            noteTextView.text = [noteTextArr objectAtIndex:noteRow];
        }
   }
    else
    {
        
    }
    [listTableV reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [namearray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"CheckTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    cell = nil;
    if(cell == nil){
      cell =[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
      cell.backgroundColor = [UIColor clearColor];
    }
    UIButton *checkBoxField;
    UIButton *negativeMark;
    UIButton *noteMark;
    UIButton *cameraMark;
    
    UITextField *Textfield = (UITextField *)[cell viewWithTag:7];
    Textfield.text =[namearray objectAtIndex: indexPath.row];
    
   // [Textfield.layer setBorderColor:[UIColor colorWithRed:176.0f/255.0f green:91.0f/255.0f blue:0/255.0f alpha:1].CGColor];
   // [Textfield.layer setBorderWidth:3.0f];
    Textfield.delegate=self;
    [Textfield addTarget:self action:@selector(updateLabelUsingContentsOfTextField:) forControlEvents:UIControlEventEditingChanged];
    //Textfield.tag=100+indexPath.row;
    
    
    
    checkBoxField = (UIButton *)[cell viewWithTag:2];
    [checkBoxField addTarget:self action:@selector(checkActionPressed:) forControlEvents:UIControlEventTouchUpInside];
    negativeMark = (UIButton *)[cell viewWithTag:3];
    [negativeMark addTarget:self action:@selector(nagetiveMarkActionPressed:)  forControlEvents:UIControlEventTouchUpInside];
    noteMark = (UIButton *)[cell viewWithTag:4];
     [noteMark addTarget:self action:@selector(notMarkActionPressed:)forControlEvents:UIControlEventTouchUpInside];
    cameraMark = (UIButton *)[cell viewWithTag:5];
      [cameraMark addTarget:self action:@selector(cameraMarkActionPressed:)  forControlEvents:UIControlEventTouchUpInside];

        if ([[checkArray objectAtIndex:indexPath.row] isEqualToString:@"1"])
        {
             UIImage *image = [UIImage imageNamed:@"selectCheckbox.png"];
            [checkBoxField setBackgroundImage:image forState:UIControlStateNormal];
        }
        else
        {
            UIImage *image = [UIImage imageNamed:@"checkbox.png"];
            [checkBoxField setBackgroundImage:image forState:UIControlStateNormal];
        }
        if ([[negativeArray objectAtIndex:indexPath.row] isEqualToString:@"1"])
        {
            UIImage *image = [UIImage imageNamed:@"nagetiveMark.png"];
            [negativeMark setBackgroundImage:image forState:UIControlStateNormal];
        }
        else
        {
            UIImage *image = [UIImage imageNamed:@"unnagetiveMark.png"];
            [negativeMark setBackgroundImage:image forState:UIControlStateNormal];
        }
        if ([[noteArray objectAtIndex:indexPath.row] isEqualToString:@"1"])
        {
            UIImage *image = [UIImage imageNamed:@"noteok.png"];
            [noteMark setBackgroundImage:image forState:UIControlStateNormal];
        }
        else
        {
            UIImage *image = [UIImage imageNamed:@"note.png"];
            [noteMark setBackgroundImage:image forState:UIControlStateNormal];
        }
        if ([[cameraArray objectAtIndex:indexPath.row] isEqualToString:@"1"])
        {
            UIImage *image = [UIImage imageNamed:@"selectCamera.png"];
            [cameraMark setBackgroundImage:image forState:UIControlStateNormal];
        }
        else
        {
            UIImage *image = [UIImage imageNamed:@"cameraun.png"];
            [cameraMark setBackgroundImage:image forState:UIControlStateNormal];
        }

   [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
      return cell;
}


- (void)updateLabelUsingContentsOfTextField:(id)sender
{
    UITextField *nameTypeTf = (UITextField *)sender;
    CheckTableViewCell *buttonCell = (CheckTableViewCell *)nameTypeTf.superview.superview;
    NSIndexPath* pathOfTheCell = [listTableV indexPathForCell:buttonCell];
    namestring = nil;
    if(probnameedit.count == 0)
    {
        namestring = nameTypeTf.text;
        [namearray replaceObjectAtIndex:pathOfTheCell.row withObject:namestring];
    }
    else
    {
        namestring = nameTypeTf.text;
        [namearray replaceObjectAtIndex:pathOfTheCell.row withObject:namestring];
    }
}
#pragma mark - UITextField
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
#pragma mark - Text Field method up
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    listTableV.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0);
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    listTableV.contentInset =  UIEdgeInsetsMake(0, 0, 150, 0);
    [self animateTextField:textField up:YES];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    listTableV.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0);
    [self animateTextField:textField up:NO];
}



#pragma mark - didSelectRowAtIndexPath
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    emailView.hidden = YES;
}

//==============    All Button   ======================
#pragma mark - CheckActionPressed
-(void)checkActionPressed:(id)sender
{
    
    UIButton *senderButton = (UIButton *)sender;
    CheckTableViewCell *buttonCell = (CheckTableViewCell *)senderButton.superview.superview;
    NSIndexPath* pathOfTheCell = [listTableV indexPathForCell:buttonCell];
    NSLog(@"pathOfTheCell.row :%ld",(long)pathOfTheCell.row);
    if ([[checkArray objectAtIndex:pathOfTheCell.row] isEqualToString:@"1"]) {
        [checkArray replaceObjectAtIndex:pathOfTheCell.row withObject:@"0"];
       
    }
    else{
        [checkArray replaceObjectAtIndex:pathOfTheCell.row withObject:@"1"];
        [negativeArray replaceObjectAtIndex:pathOfTheCell.row withObject:@"0"];
   }
  
    [listTableV beginUpdates];
    [listTableV reloadRowsAtIndexPaths:[NSArray arrayWithObjects:pathOfTheCell, nil] withRowAnimation:UITableViewRowAnimationNone];
    [listTableV endUpdates];
    
    }
#pragma mark - nagetiveMarkActionPressed
-(void)nagetiveMarkActionPressed:(id)sender
{
    
    UIButton *senderButton = (UIButton *)sender;
    CheckTableViewCell *buttonCell = (CheckTableViewCell *)senderButton.superview.superview;
    NSIndexPath* pathOfTheCell = [listTableV indexPathForCell:buttonCell];
    NSLog(@"pathOfTheCell :%ld",(long)pathOfTheCell.row);
    
    if ([[negativeArray objectAtIndex:pathOfTheCell.row] isEqualToString:@"1"]) {
        [negativeArray replaceObjectAtIndex:pathOfTheCell.row withObject:@"0"];
    }
    else{
     
        [negativeArray replaceObjectAtIndex:pathOfTheCell.row withObject:@"1"];
        [checkArray replaceObjectAtIndex:pathOfTheCell.row withObject:@"0"];
       
    }
    
    [listTableV beginUpdates];
    [listTableV reloadRowsAtIndexPaths:[NSArray arrayWithObjects:pathOfTheCell, nil] withRowAnimation:UITableViewRowAnimationNone];
    [listTableV endUpdates];
    
}
#pragma mark - notMarkActionPressed
-(void)notMarkActionPressed:(id)sender{
    UIButton *senderButton = (UIButton *)sender;
    CheckTableViewCell *buttonCell = (CheckTableViewCell *)senderButton.superview.superview;
    NSIndexPath* pathOfTheCell = [listTableV indexPathForCell:buttonCell];
    NSLog(@"pathOfTheCell :%ld",(long)pathOfTheCell.row);
    noteRow = [pathOfTheCell row];
  
    if ([[noteArray objectAtIndex:pathOfTheCell.row] isEqualToString:@"1"])
    {
        [noteArray replaceObjectAtIndex:pathOfTheCell.row withObject:@"0"];
        if(![[noteTextArr objectAtIndex:pathOfTheCell.row] isEqualToString:@""])
        {
            [copynotecellarray replaceObjectAtIndex:pathOfTheCell.row withObject:@"1"];
             [noteArray replaceObjectAtIndex:pathOfTheCell.row withObject:@"1"];
            noteTextView.text = [noteTextArr objectAtIndex:pathOfTheCell.row];
            noteView.hidden = NO;
        }
        else
        {
          [copynotecellarray replaceObjectAtIndex:pathOfTheCell.row withObject:@"0"];
        }
    }
    else
    {
        [noteArray replaceObjectAtIndex:pathOfTheCell.row withObject:@"1"];
        noteTextView.text = [noteTextArr objectAtIndex:pathOfTheCell.row];
        [copynotecellarray replaceObjectAtIndex:pathOfTheCell.row withObject:@"1"];
        noteView.hidden = NO;
    }
    NSLog(@"noteTextArr :%@",[noteTextArr objectAtIndex:pathOfTheCell.row]);
    [listTableV beginUpdates];
    [listTableV reloadRowsAtIndexPaths:[NSArray arrayWithObjects:pathOfTheCell, nil] withRowAnimation:UITableViewRowAnimationNone];
    [listTableV endUpdates];
}
#pragma mark - cameraMarkActionPressed
-(void)cameraMarkActionPressed:(id)sender{
    UIButton *senderButton = (UIButton *)sender;
    CheckTableViewCell *buttonCell = (CheckTableViewCell *)senderButton.superview.superview;
    
    pathCellInSelectPhoto = [listTableV indexPathForCell:buttonCell];
   
    if ([[cameraArray objectAtIndex:pathCellInSelectPhoto.row] isEqualToString:@"1"]) {
        [cameraArray replaceObjectAtIndex:pathCellInSelectPhoto.row withObject:@"0"];
        [imageUpdateArr replaceObjectAtIndex:pathCellInSelectPhoto.row withObject:@"null"];
        [imageArray replaceObjectAtIndex:pathCellInSelectPhoto.row withObject:@"no"];
        [imageFillArr replaceObjectAtIndex:pathCellInSelectPhoto.row withObject:@"no"];
        [copyimagecellarray replaceObjectAtIndex:pathCellInSelectPhoto.row withObject:@"1"];
        [Collectview reloadData];
    }
    else{
        
        NSString *other1 = @"Take a photo";
        NSString *other2 = @"Choose Existing Photo";
        
        NSString *cancelTitle = @"Cancle";
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:cancelTitle
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:other1, other2, nil];
        [actionSheet showInView:self.view];
        
    }
    
    [listTableV beginUpdates];
    [listTableV reloadRowsAtIndexPaths:[NSArray arrayWithObjects:pathCellInSelectPhoto, nil] withRowAnimation:UITableViewRowAnimationNone];
    [listTableV endUpdates];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    imagePick = info[UIImagePickerControllerEditedImage];
    if(!imagePick)imagePick=info[UIImagePickerControllerOriginalImage];

    [NSTimer scheduledTimerWithTimeInterval:0.1f
                                     target:self
                                   selector:@selector(imagepicker)
                                   userInfo:nil
                                    repeats:NO];
   // [self imagepicker];
   [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}

-(void)imagepicker{
       //pictureImg = [self rotateUIImage:image];
    
    UIImage *images = [self rotateUIImage:imagePick];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *imageData = UIImageJPEGRepresentation(images, 1);
    [defaults setObject:imageData forKey:@"image"];
    
    [cameraArray replaceObjectAtIndex:pathCellInSelectPhoto.row withObject:@"1"];
    [imageArray replaceObjectAtIndex:pathCellInSelectPhoto.row withObject:imageData];
    [imageFillArr replaceObjectAtIndex:pathCellInSelectPhoto.row withObject:@"yes"];
    
    //update image
    [imagecellupdate replaceObjectAtIndex:pathCellInSelectPhoto.row withObject:@"1"];
    [imageUpdateArr replaceObjectAtIndex:pathCellInSelectPhoto.row withObject:@"yes"];
    [copyimagecellarray replaceObjectAtIndex:pathCellInSelectPhoto.row withObject:@"1"];
    
    [listTableV beginUpdates];
    [listTableV reloadRowsAtIndexPaths:[NSArray arrayWithObjects:pathCellInSelectPhoto, nil] withRowAnimation:UITableViewRowAnimationNone];
    [listTableV endUpdates];
    [Collectview reloadData];
   
}

-(UIImage*)rotateUIImage:(UIImage*)src {
    
    // No-op if the orientation is already correct
    if (src.imageOrientation == UIImageOrientationUp) return src ;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (src.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, src.size.width, src.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, src.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, src.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (src.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, src.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, src.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, src.size.width, src.size.height,
                                             CGImageGetBitsPerComponent(src.CGImage), 0,
                                             CGImageGetColorSpace(src.CGImage),
                                             CGImageGetBitmapInfo(src.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (src.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,src.size.height,src.size.width), src.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,src.size.width,src.size.height), src.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}





-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex ; {
    if(buttonIndex==0)
    {
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }else if(buttonIndex==1)
    {
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.sourceType= UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}
#pragma mark - addRowTableCell Button
- (IBAction)addRowTable:(id)sender
{
    
    if(![[namearray lastObject] isEqualToString:@""])
    {
        
        NSString *str = @"";
        //nameTextfield.text = nil;
        [namearray addObject:str];
        [checkArray addObject:@"0"];
        [negativeArray addObject:@"0"];
        [noteArray addObject:@"0"];
        [cameraArray addObject:@"0"];
        [imageArray addObject:@"no"];
        [noteTextArr addObject:@""];
        [imageFillArr addObject:@"no"];
        [imagecellupdate addObject:@"0"];
        [imageUpdateArr addObject:@"no"];
        
        [checkupidarr addObject:@"insert"];
        [copynamearray addObject:@""];
        [copycheckarray addObject:@""];
        [copynegativearray addObject:@""];
        [copynoteArray addObject:@""];
        [imagesUpdateallarray addObject:@"no"];
        [copyimagecellarray addObject:@"no"];
        [noteUpdateallarray addObject:@"0"];
        [copynotecellarray addObject:@"0"];
        NSLog(@"checkupidarr :%@",checkupidarr);
        
        [listTableV reloadData];
        [Collectview reloadData];
    }
}

#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return imageArray.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CheckImageCell" forIndexPath:indexPath];
    cell =nil;
    if (cell == nil) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CheckImageCell" forIndexPath:indexPath];
    }
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:6];
    if ([@"no"isEqualToString:[imageFillArr objectAtIndex:indexPath.row]])
    {
      recipeImageView.image = [UIImage imageNamed:@"camera-check-list.png"];
    }
    else
    {
        if (probnameedit.count == 0)
        {
            recipeImageView.image = [UIImage imageWithData:[imageArray objectAtIndex:indexPath.row]];
        }
        else
        {
            if([[imageUpdateArr objectAtIndex:indexPath.row] isEqualToString:@"yes"])
            {
                 recipeImageView.image = [UIImage imageWithData:[imageArray objectAtIndex:indexPath.row]];
            }
            else
            {
                NSURL *imageUrl = [NSURL URLWithString:[imageArray objectAtIndex:indexPath.row]];
                //UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
                recipeImageView.imageURL = imageUrl;

            }
           
        }
   }
    return cell;
}

#pragma mark - UICollectionViewSelectRow
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    emailView.hidden = NO;
    emailTextView.text = [noteTextArr objectAtIndex:indexPath.row];
    if([[cameraArray objectAtIndex:indexPath.row] isEqualToString:@"0"] ){
        emailView.hidden = YES;
        emailImageView.image = [UIImage imageNamed:@"camera-check-list.png"];
    }else{
        if (probnameedit.count == 0)
        {
            
        emailImageView.image = [UIImage imageWithData:[imageArray objectAtIndex:indexPath.row]];
           // emailImageView.image  = [self modifiedImageWithImage:emailImageView.image];
            
        collectionviewselectindexpathrowno = indexPath.row;
        }
        else
        {
            if([[imageUpdateArr objectAtIndex:indexPath.row] isEqualToString:@"yes"])
            {
                emailImageView.image = [UIImage imageWithData:[imageArray objectAtIndex:indexPath.row]];
              //  emailImageView.image  = [self modifiedImageWithImage:emailImageView.image];
                collectionviewselectindexpathrowno = indexPath.row;

            }
            else
            {
                
                [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                 target:self
                                               selector:@selector(urlimageload)
                                               userInfo:nil
                                                repeats:NO];
           
            //emailImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
           collectionviewselectindexpathrowno = indexPath.row;
            }
        }
    }
}

-(void)urlimageload
{
     emailImageView.imageURL = [NSURL URLWithString:[imageArray objectAtIndex:collectionviewselectindexpathrowno]];
}

- (IBAction)cancleowenermailBtnPressed:(id)sender{
    emailView.hidden = YES;
}

#pragma mark - emailBtnNoteTextVClicked
-(IBAction)emailBtnNoteTextVClicked:(id)sender{
    //[emailarray addObject:emailStr];

    NSLog(@"%@",emailarray);
    NSLog(@"%@",[emailarray objectAtIndex:0]);

       emailView.hidden = YES;
    MFMailComposeViewController *emailDialog = [[MFMailComposeViewController alloc] init];
    emailDialog.mailComposeDelegate = self;
    NSMutableString *htmlMsg = [[NSMutableString alloc] initWithString:@"<html><body>"];
    //[htmlMsg appendString:@" <b>First Name:</b>"];
   // [htmlMsg appendString:[fnamearray objectAtIndex:0]];
   // [htmlMsg appendString:@"</br> <b>Last Name:</b>"];
   // [htmlMsg appendString:[lnamearray objectAtIndex:0]];
    [htmlMsg appendString:@"</br> <b>Address:</b>"];
    [htmlMsg appendString:app.addressclient];
    [htmlMsg appendString:@"</br> "];
    
        [htmlMsg appendString:@"<html><body>"];
         NSString *str ;
    [htmlMsg appendString:@" </br><b>Note:</b>"];
        [htmlMsg appendString:[noteTextArr objectAtIndex:collectionviewselectindexpathrowno]];
        [htmlMsg appendString:@" </br>"];
        
        if([[cameraArray objectAtIndex:collectionviewselectindexpathrowno] isEqualToString:@"0"] ){
            str =@"";
        }else{
            if (probnameedit.count == 0)
            {
               // UIImage *myImage = [UIImage imageWithData:emailImageView];
                NSData *imageData = UIImageJPEGRepresentation(emailImageView.image, 1);
                [emailDialog addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"Image"];
            }
            else
            {
                if([[imageUpdateArr objectAtIndex:collectionviewselectindexpathrowno] isEqualToString:@"yes"])
                {
                   // UIImage *myImage = [UIImage imageWithData:[imageArray objectAtIndex:collectionviewselectindexpathrowno]];
                    NSData *imageData = UIImageJPEGRepresentation(emailImageView.image, 1);
                    [emailDialog addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"Image"];
                }
                else
                {
                    
               
                
              //  UIImage *myImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
                NSData *imageData = UIImageJPEGRepresentation(emailImageView.image, 1);
                 [emailDialog addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"Image"];
                }
            }
            
            [htmlMsg appendString:@"</body></html>"];
        }
    UIImage *myImage = [UIImage imageNamed:@"email_footer.jpeg"];
    NSData *imageData = UIImageJPEGRepresentation(myImage, 1);
    [emailDialog addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"Image"];
    
    [emailDialog setSubject:@""];
    [emailDialog setMessageBody:htmlMsg isHTML:YES];
    [emailDialog setToRecipients:emailarray];
    [hud hide:YES];
    
    [self presentViewController:emailDialog animated:YES completion:nil];
}

#pragma mark - owenermailBtnPressed
- (IBAction)owenermailBtnPressed:(id)sender {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Process";
    [hud show:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.1f
                                     target:self
                                   selector:@selector(sendemail)
                                   userInfo:nil
                                    repeats:NO];
}

#pragma mark -sendemail
-(void)sendemail
{
  
   // [emailarray addObject:emailStr];

    NSLog(@"%@",emailarray);
    NSLog(@"%@",[emailarray objectAtIndex:0]);

     MFMailComposeViewController *emailDialog = [[MFMailComposeViewController alloc] init];
    emailDialog.mailComposeDelegate = self;
    NSMutableString *htmlMsg = [[NSMutableString alloc] initWithString:@"<html><body>"];
    
   // [htmlMsg appendString:@" <b>First Name:</b>"];
   // [htmlMsg appendString:[fnamearray objectAtIndex:0]];
   // [htmlMsg appendString:@"</br> <b>Last Name:</b>"];
   // [htmlMsg appendString:[lnamearray objectAtIndex:0]];
    [htmlMsg appendString:@"</br> <b>Address:</b>"];
    [htmlMsg appendString:app.addressclient];
    [htmlMsg appendString:@"</br> "];
    
    
    for (int i=0;i<[namearray count];i++)
    {
    [htmlMsg appendString:@"<html><body>"];
    [htmlMsg appendString:@" </br>- "];
  [htmlMsg appendString:[namearray objectAtIndex:i]];
    [htmlMsg appendString:@" </br><b>Status:</b>"];
    NSString *str ;
    if([[checkArray objectAtIndex:i]isEqualToString:@"1"]){
        str =@"Good";
    }else if([[negativeArray objectAtIndex:i]isEqualToString:@"1"])
    {
        str =@"Bad";
    }else
    {
        str=@"Not Selected";
    }
    [htmlMsg appendString:str];
    [htmlMsg appendString:@" </br><b>Note:</b>"];
    [htmlMsg appendString:[noteTextArr objectAtIndex:i]];
    [htmlMsg appendString:@" </br>"];
       
    if([[cameraArray objectAtIndex:i] isEqualToString:@"0"]){
        str =@"";
    }else{
        if (probnameedit.count == 0)
        {
            UIImage *myImage = [UIImage imageWithData:[imageArray objectAtIndex:i]];
            NSData *imageData = UIImageJPEGRepresentation(myImage, 0.25);
            [emailDialog addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"Image"];
        }
        else
        {
            if([[imageUpdateArr objectAtIndex:i] isEqualToString:@"yes"])
            {
                UIImage *myImage = [UIImage imageWithData:[imageArray objectAtIndex:i]];
                NSData *imageData = UIImageJPEGRepresentation(myImage, 0.25);
                [emailDialog addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"Image"];
            }
            else
            {
            NSURL *imageUrl = [NSURL URLWithString:[imageArray objectAtIndex:i]];
            
            UIImage *myImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
            NSData *imageData = UIImageJPEGRepresentation(myImage, 0.25);
            [emailDialog addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"Image"];
            }
        }
    
        [htmlMsg appendString:@"</br>"];
        
        [htmlMsg appendString:@"</body></html>"];
       
    }

    }
    UIImage *myImage = [UIImage imageNamed:@"email_footer.jpeg"];
    NSData *imageData = UIImageJPEGRepresentation(myImage, 1);
    [emailDialog addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"Image"];
    
    [emailDialog setSubject:@""];
    [emailDialog setMessageBody:htmlMsg isHTML:YES];
    [emailDialog setToRecipients:emailarray];
    
    [hud hide:YES];
 
    [self presentViewController:emailDialog animated:YES completion:nil];
}
-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - doneBtnNoteTextVClicked
-(IBAction)doneBtnNoteTextVClicked:(id)sender
{
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *notestring = [noteTextView.text stringByTrimmingCharactersInSet:whitespace];
    // NSString *clientInfovl = [clientinfo stringByTrimmingCharactersInSet:whitespace];
    //NSString *addtionalinfovl = [addtionalinfo stringByTrimmingCharactersInSet:whitespace];
    // if ([trimmed length] == 0) {
    
   // NSString *notestring = noteTextView.text;
    if(![notestring isEqualToString:@""])
    {
        [noteTextView resignFirstResponder];
        noteView.hidden = YES;
        [noteTextArr replaceObjectAtIndex:noteRow withObject:noteTextView.text];
        noteTextView.text = nil;
    }
    else
    {
        [self alertStatus:@"Note Is Empty" :@"Failed!"];

    }
    
}

- (IBAction)backBtnPressed:(id)sender
{
   [self.navigationController popViewControllerAnimated:YES];
    app.historyupdate=@"1";
    historyInt=0;
}

#pragma mark - saveDatabaseBtnPressed
- (IBAction)saveDatabaseBtnPressed:(id)sender
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Process";
    [hud show:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.1f
                                     target:self
                                   selector:@selector(senddataSever)
                                   userInfo:nil
                                    repeats:NO];
}
#pragma mark - senddataSever
-(void)senddataSever
{
    
    if ([[Reachability sharedReachability]internetConnectionStatus]==NotReachable)
    {
        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Check Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
    }
    else
    {
        if(![namearray containsObject:@""])
        {
            if(probnameedit.count == 0)
            {
                
              
                NSString *urlString = [[NSString alloc]initWithFormat:@"http://app.bittencourtproperty.com/bittencourt_api/add_item.php"];
                NSURL *url = [NSURL URLWithString:urlString];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                NSDictionary *jsonDictionary;
                
                for (int i=0;i<[namearray count];i++)
                {
                    
                            NSString *imageString;
                            if([[imageFillArr objectAtIndex:i] isEqualToString:@"yes"])
                            {
                                UIImage *myImage = [UIImage imageWithData:[imageArray objectAtIndex:i]];
                                NSData *imageData = UIImageJPEGRepresentation(myImage, 0.25);
                                [Base64 initialize];
                                imageString = [NSString stringWithFormat:@"%@",[Base64 encode:imageData]];
                            }
                            NSString *select;
                            if([[checkArray objectAtIndex:i]isEqualToString:@"1"]){
                                select =@"Good";
                            }else if([[negativeArray objectAtIndex:i]isEqualToString:@"1"])
                            {
                                select =@"Bad";
                            }else
                            {
                                select =@"No selected";
                            }
                            
                            NSString *myRequestString =[NSString stringWithFormat:@"{\"item\":[[\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\"]]}",app.uidStr,app.addressclient,[namearray objectAtIndex:i],select,@"no",[noteTextArr objectAtIndex:i],imageString];
                            NSData *requestData = [NSData dataWithBytes:[myRequestString UTF8String] length:[myRequestString length]];
                            
                            [request setHTTPMethod: @"POST"];
                            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                            [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                            [request setHTTPBody: requestData];
                            NSError *error;
                            NSURLResponse *response;
                            NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                            jsonDictionary = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:nil];
                            
                }
                        
                        NSString *successtr = [[jsonDictionary valueForKey:@"posts"]valueForKey:@"Success"] ;
                        NSInteger success = [successtr integerValue];
                        if(success == 1)
                        {
                            [self alertStatus:@"Send To DataBase..." :@"Success!"];
                            
                        }
                        else
                        {
                            
                            [self alertStatus:@"Sending failer..." :@"Failed!"];
                            //[MBProgressHUD hideHUDForView:self.view animated:NO];
                            
                        }
                
            }
            else
            {
                NSInteger success = 2;
        for (int i=0;i<[namearray count];i++)
        {
                    
        if(![[namearray objectAtIndex:i] isEqualToString:[copynamearray objectAtIndex:i]] || ![[checkArray objectAtIndex:i] isEqualToString:[copycheckarray objectAtIndex:i]] || ![[negativeArray objectAtIndex:i] isEqualToString:[copynegativearray objectAtIndex:i]] || ![[noteUpdateallarray objectAtIndex:i] isEqualToString:[copynotecellarray objectAtIndex:i]] || ![[imagesUpdateallarray objectAtIndex:i] isEqualToString:[copyimagecellarray objectAtIndex:i]])
        {
            
            
            NSLog(@"id: %@",[checkupidarr objectAtIndex:i]);
            if([[checkupidarr objectAtIndex:i] isEqualToString:@"insert"])
            {
                    NSString *urlString = [[NSString alloc]initWithFormat:@"http://app.bittencourtproperty.com/bittencourt_api/add_item.php"];
                    NSURL *url = [NSURL URLWithString:urlString];
                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                    NSDictionary *jsonDictionary;

                    NSString *imageString;
                    if([[imageFillArr objectAtIndex:i] isEqualToString:@"yes"])
                    {
                        UIImage *myImage = [UIImage imageWithData:[imageArray objectAtIndex:i]];
                        NSData *imageData = UIImageJPEGRepresentation(myImage, 0.25);
                        [Base64 initialize];
                        imageString = [NSString stringWithFormat:@"%@",[Base64 encode:imageData]];
                    }
                    NSString *select;
                    if([[checkArray objectAtIndex:i]isEqualToString:@"1"]){
                        select =@"Good";
                    }else if([[negativeArray objectAtIndex:i]isEqualToString:@"1"])
                    {
                        select =@"Bad";
                    }else
                    {
                        select =@"No selected";
                    }
                    
                    NSString *myRequestString =[NSString stringWithFormat:@"{\"item\":[[\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\"]]}",app.uidStr,app.addressclient,[namearray objectAtIndex:i],select,@"no",[noteTextArr objectAtIndex:i],imageString];
                    NSData *requestData = [NSData dataWithBytes:[myRequestString UTF8String] length:[myRequestString length]];
                    
                    [request setHTTPMethod: @"POST"];
                    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                    [request setHTTPBody: requestData];
                    NSError *error;
                    NSURLResponse *response;
                    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                    jsonDictionary = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:nil];
                NSString *successtr = [[jsonDictionary valueForKey:@"posts"]valueForKey:@"Success"] ;
                success = [successtr integerValue];
        
                        }
                        else
                        {
                            //Update code for add to database
                            NSString *urlString = [[NSString alloc]initWithFormat:@"http://app.bittencourtproperty.com/bittencourt_api/edit_item.php"];
                            NSURL *url = [NSURL URLWithString:urlString];
                            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                            NSDictionary *jsonDictionary;
                            
                            
                            NSString *imageString;
                            if([[imageUpdateArr objectAtIndex:i] isEqualToString:@"yes"])
                            {
                                UIImage *myImage = [UIImage imageWithData:[imageArray objectAtIndex:i]];
                                NSData *imageData = UIImageJPEGRepresentation(myImage, 0.25);
                                [Base64 initialize];
                                imageString = [NSString stringWithFormat:@"%@",[Base64 encode:imageData]];
                                NSString *select;
                                if([[checkArray objectAtIndex:i]isEqualToString:@"1"]){
                                    select =@"Good";
                                }else if([[negativeArray objectAtIndex:i]isEqualToString:@"1"])
                                {
                                    select =@"Bad";
                                }else
                                {
                                    select=@"No Selected";
                                }
                                //dk insert
                                NSString *myRequestString;
                                if ([[checkupidarr objectAtIndex:i] isEqualToString:@"insert"])
                                {
                                    myRequestString = [NSString stringWithFormat:@"{\"id\":\"%@\",\"u_id\":\"%@\",\"address\":\"%@\",\"problemname\":\"%@\",\"status\":\"%@\",\"negative\":\"%@\",\"note\":\"%@\",\"image\":\"%@\"}",[checkupidarr objectAtIndex:i],app.uidStr,app.addressclient,[namearray objectAtIndex:i],select,@"no",[noteTextArr objectAtIndex:i],imageString];
                                }
                                else
                                {
                                    myRequestString = [NSString stringWithFormat:@"{\"id\":\"%@\",\"problemname\":\"%@\",\"status\":\"%@\",\"negative\":\"%@\",\"note\":\"%@\",\"image\":\"%@\"}",[checkupidarr objectAtIndex:i],[namearray objectAtIndex:i],select,@"no",[noteTextArr objectAtIndex:i],imageString];
                                }
                                NSData *requestData = [NSData dataWithBytes:[myRequestString UTF8String] length:[myRequestString length]];
                                
                                [request setHTTPMethod: @"POST"];
                                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                                [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                                [request setHTTPBody: requestData];
                                NSError *error;
                                NSURLResponse *response;
                                NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                                jsonDictionary = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:nil];
                                NSString *successtr = [[jsonDictionary valueForKey:@"posts"]valueForKey:@"Success"] ;
                                success = [successtr integerValue];
                            }
                            else if([[imageUpdateArr objectAtIndex:i] isEqualToString:@"null"])
                            {
                                NSString *select;
                                if([[checkArray objectAtIndex:i]isEqualToString:@"1"]){
                                    select =@"Good";
                                }else if([[negativeArray objectAtIndex:i]isEqualToString:@"1"])
                                {
                                    select =@"Bad";
                                }else
                                {
                                    select=@"No Selected";
                                }
                                //dk insert
                                NSString *myRequestString;
                                if ([[checkupidarr objectAtIndex:i] isEqualToString:@"insert"])
                                {
                                    myRequestString =[NSString stringWithFormat:@"{\"id\":\"%@\",\"u_id\":\"%@\",\"address\":\"%@\",\"problemname\":\"%@\",\"status\":\"%@\",\"negative\":\"%@\",\"note\":\"%@\",\"image\":\"%@\"}",[checkupidarr objectAtIndex:i],app.uidStr,app.addressclient,[namearray objectAtIndex:i],select,@"no",[noteTextArr objectAtIndex:i],@"(null)"];
                                }
                                else
                                {
                                    myRequestString =[NSString stringWithFormat:@"{\"id\":\"%@\",\"problemname\":\"%@\",\"status\":\"%@\",\"negative\":\"%@\",\"note\":\"%@\",\"image\":\"%@\"}",[checkupidarr objectAtIndex:i],[namearray objectAtIndex:i],select,@"no",[noteTextArr objectAtIndex:i],@"delete"];
                                }
                                NSData *requestData = [NSData dataWithBytes:[myRequestString UTF8String] length:[myRequestString length]];
                                
                                [request setHTTPMethod: @"POST"];
                                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                                [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                                [request setHTTPBody: requestData];
                                NSError *error;
                                NSURLResponse *response;
                                NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                                jsonDictionary = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:nil];
                                NSString *successtr = [[jsonDictionary valueForKey:@"posts"]valueForKey:@"Success"] ;
                                success = [successtr integerValue];
                            

                            }
                            else
                            {
                                NSString *select;
                                if([[checkArray objectAtIndex:i]isEqualToString:@"1"]){
                                    select =@"Good";
                                }else if([[negativeArray objectAtIndex:i]isEqualToString:@"1"])
                                {
                                    select =@"Bad";
                                }else
                                {
                                    select=@"No Selected";
                                }
                                //dk insert
                                NSString *myRequestString;
                                if ([[checkupidarr objectAtIndex:i] isEqualToString:@"insert"])
                                {
                                    myRequestString =[NSString stringWithFormat:@"{\"id\":\"%@\",\"u_id\":\"%@\",\"address\":\"%@\",\"problemname\":\"%@\",\"status\":\"%@\",\"negative\":\"%@\",\"note\":\"%@\",\"image\":\"%@\"}",[checkupidarr objectAtIndex:i],app.uidStr,app.addressclient,[namearray objectAtIndex:i],select,@"no",[noteTextArr objectAtIndex:i],@"(null)"];
                                }
                                else
                                {
                                    myRequestString =[NSString stringWithFormat:@"{\"id\":\"%@\",\"problemname\":\"%@\",\"status\":\"%@\",\"negative\":\"%@\",\"note\":\"%@\",\"image\":\"%@\"}",[checkupidarr objectAtIndex:i],[namearray objectAtIndex:i],select,@"no",[noteTextArr objectAtIndex:i],@"(null)"];
                                }
                                NSData *requestData = [NSData dataWithBytes:[myRequestString UTF8String] length:[myRequestString length]];
                                
                                [request setHTTPMethod: @"POST"];
                                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                                [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
                                [request setHTTPBody: requestData];
                                NSError *error;
                                NSURLResponse *response;
                                NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                                jsonDictionary = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:nil];
                                NSString *successtr = [[jsonDictionary valueForKey:@"posts"]valueForKey:@"Success"] ;
                                success = [successtr integerValue];
                            }
                        }
            
            }
            else
            {
                
            }
                }
                if(success == 1)
                {
                    if([app.historyupdate isEqualToString:@"1"])
                    {
                        [self alertStatus:@"Recored Saved.." :@"Success!"];
                        [self dataLoadFromServer];
                    }
                    else
                    {
                        
                        historyInt=1;
                        [self alertStatus:@"Recored Saved.." :@"Success!"];
                        [self dataLoadFromServer];
                    }
                }
                else if(success == 2)
                {
                    [self alertStatus:@"Recored Already Saved.." :@"Success!"];
                }
                else
                {
                    [self alertStatus:@"Sending failer..." :@"Failed!"];
                }

            }
           
            [hud hide:YES];

        }
        else
        {
            [self alertStatus:@"Field Is Empty" :@"Error!"];
             [hud hide:YES];
        }
    }
    //[Collectview reloadData];
   // [listTableV reloadData];
}

- (void) alertStatus:(NSString *)msg :(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
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
        if (self.interfaceOrientation == UIDeviceOrientationPortrait)
            frame.origin.y = frame.origin.y + (up ? -animateDistance : animateDistance);
        else if (self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)
            frame.origin.y = frame.origin.y + (up ? animateDistance : -animateDistance);
        self.view.frame = frame;
    }
    
    [UIView commitAnimations];
}


#pragma mark : delete record
/*
 // Delete tableview Record
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 // [self refereseData];
 if(![[checkupidarr objectAtIndex:indexPath.row] isEqualToString:@""])
 {
 if (editingStyle == UITableViewCellEditingStyleDelete)
 {
 
 removeItem = [checkupidarr objectAtIndex:indexPath.row];
 
 [self DeletetodoList];
 [checkupidarr removeObjectAtIndex:indexPath.row];
 // [listArray removeObjectAtIndex:indexPath.row];
 //  [checkarraytodo removeObjectAtIndex:indexPath.row];
 // [self LoadData];
   for (int i=0; i< refdeletelistarr.count; i++)
 {
 
 
 if(![[refdeletelistarr objectAtIndex:i] isEqualToString:@""])
 {
 [listArray addObject:[refdeletelistarr objectAtIndex:i]];
 [checkarraytodo addObject:[refdeletecheckarr objectAtIndex:i]];
 [idArray addObject:@""];
 // [copylistarraytodo insertObject:@"0" atIndex:i];
 // [copycheckarraytodo insertObject:@"0" atIndex:i];
 
 
 NSLog(@"list %@",listArray);
 NSLog(@"check %@",checkarraytodo);
 }
 
 
 }
 
 [listTableV reloadData];
 }
 }
 else
 {
 [namearray removeObjectAtIndex:indexPath.row];
 [checkupidarr removeObjectAtIndex:indexPath.row];
 //[checkarraytodo removeObjectAtIndex:indexPath.row];
 // [TableViewtodoList reloadData];
 }
 
 
 }
 
 -(void)DeletetodoList
 {
 NSString *urlString = [[NSString alloc]initWithFormat:@"http://gonuts4appsclient.com/bittencourt/delete_item.php"];
 NSURL *url = [NSURL URLWithString:urlString];
 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
 NSDictionary *jsonDictionary;
 
 NSString *myRequestString =[NSString stringWithFormat:@"{\"id\":\"%@\"}",removeItem];
 NSData *requestData = [NSData dataWithBytes:[myRequestString UTF8String] length:[myRequestString length]];
 
 
 
 [request setHTTPMethod: @"POST"];
 [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
 [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
 [request setHTTPBody: requestData];
 NSError *error;
 NSURLResponse *response;
 NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
 jsonDictionary = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:nil];
 
 //  NSLog(@"delete %@",itemdelete);
 
 }
 */

@end
