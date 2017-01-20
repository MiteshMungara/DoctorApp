 //
//  data.m
//  Bandii
//
//  Created by webastral on 4/30/15.
//  Copyright (c) 2015 webastral. All rights reserved.
//

#import "data.h"

#import <SystemConfiguration/SystemConfiguration.h>
#import "AppDelegate.h"
@implementation data

-(void)getdata:(NSURL *)url{
    
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
;
    

    
    //initialize url that is going to be fetched.
//    NSURL *url = [NSURL URLWithString:url];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;

    
    //start the connection
    [connection start];

}

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


- (void)postData: (NSString *)postString onUrl:(NSURL *) urlService
{

    
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[urlService standardizedURL]];
    
    //set http method
   // [request setHTTPMethod:@"POST"];
    
    //initialize a post data
//    NSString *postData = [[NSString alloc] initWithString:postString];
//    
//    //set request content type we MUST set this value.
//    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    
//    //set post data of request
//    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    self.connection = connection;
    
    //start the connection
    [connection start];
    
}
    

-(void)postEventWithImage:(NSString*)api withImage:(NSMutableArray*)imageData withImageName:(NSString*)imageName Withdic:(NSDictionary *)dic
{
  


    NSString *urlString =api;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    // NSData * filedata = UIImagePNGRepresentation(imageData);
    
    NSMutableData *body = [NSMutableData data];
    
    for(int i=0;i<[imageData count];i++)
    {
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        if(i==0)
        {
            [body appendData:[@"Content-Disposition: form-data; name=\"pic\"; filename=\"pic.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else
        {
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"pic%d\"; filename=\"pic%d.png\"\r\n",i ,i] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData[i]]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSArray *arrKeys=[dic allKeys];
    for (int i=0;i<[arrKeys count];i++)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", arrKeys[i]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dic valueForKey:arrKeys[i]]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [request setTimeoutInterval:7200];
    [request setHTTPBody:body];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    //    webData=[[NSMutableData alloc] init];
    
}



-(void)postEventImage:(NSString*)api withImage:(NSData*)imageData withImageName:(NSString*)imageName Withdic:(NSDictionary *)dic
{
 
    //change @"pic" to imagename
    

 
    
    [self.connection cancel];
    // product_pic
    NSString * pic;
    
   if ([api isEqualToString:@"http://112.196.16.94/bandiiapp/signup.php?"] ||[api isEqualToString: @"http://112.196.16.94/bandiiapp/editprofile.php?"]) {
       
       pic = @"user_pic";
   }else if ( [api isEqualToString:@"http://112.196.16.94/bandiiapp/client_chat.php?"]){
   
   pic = @"chat_img";
   }
   
   
   else{
        
        pic =@"product_pic";
    }
    
    
    NSLog( @"%@",api);
    NSString *urlString =api;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",pic,imageName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    
    //    [body appendData:[[NSString stringWithFormat:@"%@",dic] dataUsingEncoding:NSUTF8StringEncoding]];
    //
    //        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",pic,imageName] dataUsingEncoding:NSUTF8StringEncoding]];
    //
    
    //        NSLog(@"%@",body);
    //
    //       [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    //        [body appendData:[NSData dataWithData:imageData]];
    //        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //         //setting the body of the post to the reqeust
    //        [request setHTTPBody:body];
    
    NSArray *arrKeys=[dic allKeys];
    for (int i=0;i<[arrKeys count];i++)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", arrKeys[i]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dic valueForKey:arrKeys[i]]] dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    [request setTimeoutInterval:7200];
    [request setHTTPBody:body];
    
    
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    //    self.connection = connection;
    
    //start the connection
    [connection start];
 
    // now lets make the connection to the web
    //        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //        NSLog(@"%@",returnString);
    //        NSLog(@"finish");
    }



 // this method might be calling more than one times according to incoming data size

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.receivedData =[[NSMutableData alloc]init];

}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.receivedData appendData:data];
    NSLog(@"%@",self.receivedData);
}

// if there is an error occured, this method will be called by connection

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
  
    
    [self showalert:@"server error" andmessage:@"please try relaunching the app"];
    
    NSLog(@"an error has occurred");
}


 // if data is successfully received, this method will be called by connection

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    //initialize convert the received data to string with UTF8 encoding
    NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData
                                              encoding:NSUTF8StringEncoding];
 NSLog(@"%@" , htmlSTR);
    
    NSMutableDictionary * json = [NSJSONSerialization JSONObjectWithData:[htmlSTR dataUsingEncoding:NSUTF8StringEncoding] options:0 error:Nil];

    
   [self.delegate protocolmethod:self :json];
    
   
}


-(void)showalert:(NSString *)title andmessage:(NSString *)message{

    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];

    [alert show];
}
@end
