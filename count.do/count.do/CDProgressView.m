//
//  CDProgressView.m
//  count.do
//
//  Created by Ali Can Bülbül on 6/6/13.
//  Copyright (c) 2013 Can Bülbül. All rights reserved.
//

#import "CDProgressView.h"
#define d2r(a) ((a)/180.0*M_PI)
#define f(a) [a floatValue]

@implementation CDProgressView
@synthesize angle;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        angle = @0;
        timer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                 target:self
                                               selector:@selector(increment)
                                               userInfo:nil
                                                repeats:YES ];
    }
    return self;
}

- (void) increment {
    if (f(angle)>357) {
        angle=@358.9;
        [timer invalidate];
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    NSLog(@"angle = %f",f(angle));
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(30, 30) radius:16 startAngle:d2r(180) endAngle:d2r(f(angle)-179) clockwise:true];
    path.lineWidth = 9;
    [[UIColor colorWithRed:(140+f(angle)/2.8)/255.0 green:(221-f(angle)/2.7)/255.0 blue:(205-f(angle)/1.7)/255.0 alpha:1] setStroke];
    [path stroke];
    
}

@end