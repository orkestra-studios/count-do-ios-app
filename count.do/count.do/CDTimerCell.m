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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        comps = [[NSDateComponents alloc] init];
        [comps setYear:2013];
        [comps setMonth:6];
        [comps setDay:6];
        
        [comps setHour:18];
        [comps setMinute:46];
        [comps setSecond:15];
        
        NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        timerTarget = [cal dateFromComponents:comps];
        
        firstLeft = [timerTarget timeIntervalSinceReferenceDate] - [NSDate timeIntervalSinceReferenceDate];
        firstLeft = firstLeft>0 ? firstLeft : 0;
        [self printTimer];
        timer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                 target:self
                                               selector:@selector(printTimer)
                                               userInfo:nil
                                                repeats:YES ];

        
    }
    return self;
}

- (void) printTimer {
    timeLeft = [timerTarget timeIntervalSinceReferenceDate] - [NSDate timeIntervalSinceReferenceDate];
    timeLeft = timeLeft>0 ? timeLeft : 0;
    int tempLeft = timeLeft;
    self.progressView.angle = @(358 - ((timeLeft/(firstLeft+0.001))*360));
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
    if(timeLeft==0) [timer invalidate];
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
