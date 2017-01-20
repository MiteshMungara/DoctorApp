//
//  data.h
//  Bandii
//
//  Created by webastral on 4/30/15.
//  Copyright (c) 2015 webastral. All rights reserved.
//

#import <Foundation/Foundation.h>
@ class data;

@protocol datadelegate <NSObject>

-(void) protocolmethod:(data *)getdata :(NSDictionary * )datadictionary;

@end



@interface data : NSObject<NSURLConnectionDataDelegate>


@property(copy)NSString *ApiUrlStr;
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *receivedData;
@property (weak, nonatomic) id <datadelegate> delegate;
-(void)getdata:(NSURL *)url;
- (void)postData: (NSString *)postString onUrl:(NSURL *) urlService;
-(void)postEventWithImage:(NSString*)api withImage:(NSMutableArray*)imageData withImageName:(NSString*)imageName Withdic:(NSDictionary *)dic;
-(void)postEventImage:(NSString*)api withImage:(NSData*)imageData withImageName:(NSString*)imageName Withdic:(NSDictionary *)dic;

-(NSDictionary *)JsonServiceCall :(NSString *)ApiStr;

@end
