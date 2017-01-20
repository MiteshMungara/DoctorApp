//
//  AppDelegate.h
//  Halka BHolath
//
//  Created by iSquare2 on 10/25/16.
//  Copyright © 2016 MitsSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(nonatomic)BOOL allowRotation;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *deviceTokenStr;
//@property(strong,nonatomic) NSInteger ScreenMode;
@end

