//
//  Canvas.m
//  Drawi
//
//  Created by damian on 05/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Canvas.h"

@implementation Canvas
@synthesize location;

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   // app=[[UIApplication sharedApplication]delegate];
    UITouch *touch = [touches anyObject];
    self.location = [touch locationInView:self];
}
 - (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    int value;
    app=[[UIApplication sharedApplication]delegate];
   
   value=5;
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self];  
    
    UIGraphicsBeginImageContext(self.frame.size); 
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx, value);
    CGContextSetRGBStrokeColor(ctx, 255.0/255, 0.0/255, 0.0/255, 1.0);
         //   CGContextSetRGBStrokeColor(ctx, 1.0/255, 61.0/255, 255.0/255, 1.0);
  
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, location.x, location.y);
    CGContextAddLineToPoint(ctx, currentLocation.x, currentLocation.y);
    CGContextStrokePath(ctx);
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    location = currentLocation;
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    int value;
    value=5;
   
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self];
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();   
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx,value);
    CGContextSetRGBStrokeColor(ctx, 255.0/255, 0.0/255, 0.0/255, 1.0);
   
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, location.x, location.y);
    CGContextAddLineToPoint(ctx, currentLocation.x, currentLocation.y);
    CGContextStrokePath(ctx);
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    location = currentLocation;
}

@end
