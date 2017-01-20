//
//  DPHeader.h
//  DoctorOnDemandService
//
//  Created by isquare2 on 3/2/16.
//  Copyright © 2016 isquare2. All rights reserved.
//

#ifndef DPHeader_h
#define DPHeader_h

#define DATABASEURL @"http://46.166.173.116/FlippyCloud/halka_bholath"

#define BORDERCOLOR  [UIColor colorWithRed:89.0/255.0 green:90.0/255.0 blue:206.0/255.0 alpha:1.0].CGColor

#define BACKGROUNGCELL  [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0]


#define ALERT_VIEW(title,msg)\
{\
UIAlertView *av = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];\
[av show];\
}

#endif /* DPHeader_h */
