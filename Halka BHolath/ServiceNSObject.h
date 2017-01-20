//
//  ServiceNSObject.h
//  MrGreens
//
//  Created by isquare2 on 9/3/15.
//  Copyright (c) 2015 isquare2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceNSObject : NSObject
{
    
}
@property(copy)NSString *ApiUrlStr;

-(NSDictionary *)JsonServiceCall :(NSString *)ApiStr;

-(NSDictionary *)JsonPostServiceCall:(NSString *)urlStr PostTagSet:(NSString *)postTagStr;

-(NSDictionary *)JsonPostServiceOfArrCall:(NSString *)urlStr PostDataSet:(NSData *)postDataStr;

-(NSDictionary *)JsonPostServiceBackgCall:(NSString *)urlStr PostTagBackgSet:(NSString *)postTagStr;

@end
