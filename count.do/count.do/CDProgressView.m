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
@synthesize tangle;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        angle = @0;
        animation = true;
        [self startAnimation];
    }
    return self;
}

- (void) increment {
    if (f(angle)>359) {
        angle=@358.9;
    }
    [self setNeedsDisplay];
}

- (void) animate {
    if (!animation) {
        [timer invalidate];
        return;
    }
    if (f(tangle)-f(angle)>=1) {
        angle = [NSNumber numberWithFloat:([angle floatValue] + [[NSNumber numberWithFloat:f(tangle)-f(angle)] floatValue]/45.0 + 0.5)];
    }else if (f(tangle)-f(angle)<=-1) {
        angle = [NSNumber numberWithFloat:([angle floatValue] + [[NSNumber numberWithFloat:f(tangle)-f(angle)] floatValue]/45.0 - 0.5)];
    }else {
        [self stopAnimation];
    }
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (void) stopAnimation {
    animation = false;
    [timer invalidate];
}

- (void) startAnimation {
    animation = true;
    if(animation){
        timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(animate) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

- (void)drawRect:(CGRect)rect
{
    [self increment];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(30, 30) radius:15 startAngle:d2r(180) endAngle:d2r(f(angle)-179) clockwise:true];
    path.lineWidth = 6.5;
    [[UIColor colorWithRed:(140+f(angle)/3.9)/255.0 green:(221-f(angle)/2.4)/255.0 blue:(205-f(angle)/2.2)/255.0 alpha:1] setStroke];
    [path stroke];
    
}

- (BOOL) animation {
    return animation;
}

@end
