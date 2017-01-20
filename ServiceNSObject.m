//
//  ServiceNSObject.m
//  MrGreens
//
//  Created by isquare2 on 9/3/15.
//  Copyright (c) 2015 isquare2. All rights reserved.
//

#import "ServiceNSObject.h"

@implementation ServiceNSObject
-(NSDictionary *)JsonServiceCall :(NSString *)ApiStr
{
    NSDictionary *jsonDictionaryRespose;
    NSURL *url = [NSURL URLWithString:[ApiStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod: @"GET"];
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //
    if (!urlData)
    {}
    else{
        jsonDictionaryRespose = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:nil];
    }
    return jsonDictionaryRespose;
}
-(NSDictionary *)JsonPostServiceCall:(NSString *)urlStr PostTagSet:(NSString *)postTagStr
{
    NSDictionary *jsonDictionaryRespose;
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    NSData *requestData = [NSData dataWithBytes:[postTagStr UTF8String] length:[postTagStr length]];
    [request setHTTPBody: requestData];
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!urlData)
    {}
    else{
        jsonDictionaryRespose = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:nil];
    }
    
    return jsonDictionaryRespose;
}


-(NSDictionary *)JsonPostServiceOfArrCall:(NSString *)urlStr PostDataSet:(NSData *)requestData
{
    NSDictionary *jsonDictionaryRespose;
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    //NSData *requestData = [NSJSONSerialization dataWithJSONObject:postDataStr options:0 error:nil];
    [request setHTTPBody: requestData];
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!urlData)
    {}
    else{
        jsonDictionaryRespose = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:nil];
    }
    
    return jsonDictionaryRespose;
}

-(NSDictionary *)JsonPostServiceBackgCall:(NSString *)urlStr PostTagBackgSet:(NSString *)postTagStr
{
    NSDictionary *jsonDictionaryRespose;
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    NSData *requestData = [NSData dataWithBytes:[postTagStr UTF8String] length:[postTagStr length]];
    [request setHTTPBody: requestData];
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!urlData)
    {}
    else{
        jsonDictionaryRespose = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:nil];
    }
    
    return jsonDictionaryRespose;
}

@end
