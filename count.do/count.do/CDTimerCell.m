//
//  CDTimerCell.m
//  count.do
//
//  Created by Ali Can Bülbül on 6/6/13.
//  Copyright (c) 2013 Can Bülbül. All rights reserved.
//

#import "CDTimerCell.h"
#import "CDProgressView.h"

@implementation CDTimerCell
@synthesize comps;
@synthesize init;

- (void) initialize {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    timerTarget = [cal dateFromComponents:comps];
    
    firstLeft = [timerTarget timeIntervalSinceReferenceDate] - [init timeIntervalSinceReferenceDate];
    firstLeft = firstLeft>0 ? firstLeft : 0;
    [self printTimer];
    if (firstLeft>0) {
        [self.progressView increment];
        timer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                 target:self
                                               selector:@selector(printTimer)
                                               userInfo:nil
                                                repeats:YES ];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    
    
}

- (void) printTimer {
    timeLeft = [timerTarget timeIntervalSinceReferenceDate] - [NSDate timeIntervalSinceReferenceDate];
    timeLeft = timeLeft>0 ? timeLeft : 0;
    int tempLeft = timeLeft;
    self.progressView.angle = @(358.9 - ((timeLeft/(firstLeft+0.001))*360));
    self.progressView.angle = [self.progressView.angle floatValue]>0 ? self.progressView.angle : @0.001;
    int years  = tempLeft / 31104000;
    tempLeft   = tempLeft - years*31104000;
    int months = tempLeft / 2592000;
    tempLeft   = tempLeft - months*2592000;
    int days  = tempLeft / 86400;
    tempLeft  = tempLeft - days*86400;
    
    int hours = tempLeft / 3600;
    tempLeft  = tempLeft - hours*3600;
    int mins  = tempLeft / 60;
    tempLeft  = tempLeft - mins*60;
    int secs  = tempLeft;
    NSString *yearString, *monthString, *dayString, *hourString, *minString, *secString;
    yearString = [NSString stringWithFormat:@"%d",years];
    monthString = [NSString stringWithFormat:@"%d",months];
    dayString = [NSString stringWithFormat:@"%d",days];
    hourString = [NSString stringWithFormat:@"%d",hours];

    minString = [NSString stringWithFormat:@"%d",mins];
    secString = [NSString stringWithFormat:@"%d",secs];
    self.yearLabel.text = yearString;
    self.monthLabel.text = monthString;
    self.dayLabel.text = dayString;
    self.hourLabel.text = hourString;
    self.minuteLabel.text = minString;
    self.secondLabel.text = secString;
    if(timeLeft<0.6) [timer invalidate];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
