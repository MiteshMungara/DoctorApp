//
//  CheckViewController.h
//  Bittencourt Property
//
//  Created by iSquare5 on 09/07/15.
//  Copyright (c) 2015 MitSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "MBProgressHUD.h"
#import "AsyncImageView.h"

@interface CheckViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,UICollectionViewDelegate,UICollectionViewDataSource,MFMailComposeViewControllerDelegate,UITextFieldDelegate>
{
    CGFloat animateDistance;
     MBProgressHUD *hud;
    UIImagePickerController *ipc;
    UIPopoverController *popover;
    IBOutlet UICollectionView *Collectview;
    AppDelegate *app;
    IBOutlet UIView *noteView;
    IBOutlet UITextView *noteTextView;
    NSInteger noteRow;
    NSIndexPath* pathCellInSelectPhoto;
    
    IBOutlet UIView *emailView;
    IBOutlet UITextView *emailTextView;
    IBOutlet UIImageView *emailImageView;
    IBOutlet UILabel *monthLab;
    IBOutlet UILabel *dayLab;
    IBOutlet UILabel *dateLab;
    IBOutlet UILabel *timeLab;
    IBOutlet UIButton *addRowTable;
    IBOutlet UIButton *backNoteButton;
    
}
@property (nonatomic,retain) NSArray *probnameedit;
@property (nonatomic,retain) NSArray *statusedit;
@property (nonatomic,retain) NSArray *noteviewedit;
@property (nonatomic,retain) NSArray *imageviewedit;
@property (nonatomic,retain) NSString *historyupdate;

//@property (nonatomic,retain) NSString *probname;


@property (weak, nonatomic) IBOutlet UITableView *listTableV;

@property (weak, nonatomic) IBOutlet UILabel *addressTextField;


//Button
//- (IBAction)addRowTable:(id)sender;
- (IBAction)cancleowenermailBtnPressed:(id)sender;

- (IBAction)owenermailBtnPressed:(id)sender;

- (IBAction)saveDatabaseBtnPressed:(id)sender;

- (IBAction)backBtnPressed:(id)sender;

-(IBAction)doneBtnNoteTextVClicked:(id)sender;

- (IBAction)backBtnOfNotePressed:(id)sender;

-(IBAction)emailBtnNoteTextVClicked:(id)sender;

@end
