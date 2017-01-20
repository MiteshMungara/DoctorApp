//
//  Canvas.h
//  Drawi
//
//  Created by damian on 05/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface Canvas : UIImageView
{
    AppDelegate *app;
    CGPoint location;
}
@property CGPoint location;
@end
