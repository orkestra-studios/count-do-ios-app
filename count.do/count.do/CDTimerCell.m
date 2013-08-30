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
    self.selectMenu.alpha=0;
    firstLeft = [init timeIntervalSinceReferenceDate] - [NSDate timeIntervalSinceReferenceDate];
    firstLeft = firstLeft>0 ? firstLeft : 0;
    timeLeft = [timerTarget timeIntervalSinceReferenceDate] - [NSDate timeIntervalSinceReferenceDate];
    //self.progressView.angle = @0;
    self.progressView.tangle = @(358.9 - ((timeLeft/(firstLeft+0.001))*360)); 
    [self.progressView startAnimation];
    if (firstLeft>0) {
        [self.progressView increment];
    }
    [self printTimer];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(printTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void) printTimer {
    timeLeft = [timerTarget timeIntervalSinceReferenceDate] - [NSDate timeIntervalSinceReferenceDate];
    timeLeft = timeLeft>=0 ? timeLeft : -timeLeft;
    int tempLeft = timeLeft;
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
    if([self.progressView animation] && [timerTarget timeIntervalSinceReferenceDate]<[NSDate timeIntervalSinceReferenceDate])
        [self.progressView stopAnimation];
    if([self.progressView animation]) {
        [self.progressView setNeedsDisplay];
        return;
    }
    self.progressView.angle = @(358.9 - ((timeLeft/(firstLeft+0.001))*360));
    self.progressView.angle = [self.progressView.angle floatValue]>0 ? self.progressView.angle : @0.001;
    [self.progressView setNeedsDisplay];
    if(timeLeft<0.6 || [timerTarget timeIntervalSinceReferenceDate]<[NSDate timeIntervalSinceReferenceDate]){
        self.doneButton.hidden = false;
        self.doneButton.alpha = 1;
    }else{
        self.doneButton.hidden = true;
    }
}

- (void) showMenu {
    [UIView animateWithDuration:0.3 animations:^{
        self.selectMenu.alpha=1;
    }];
    [[NSUserDefaults standardUserDefaults] setInteger:self.selectMenu.tag forKey:@"selected"];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"selected"
     object:self];
}


- (NSDateComponents *)getDate {
    NSDateComponents *left = [[NSDateComponents alloc] init];
    left.year   = [self.yearLabel.text integerValue];
    left.month  = [self.monthLabel.text integerValue];
    left.day    = [self.dayLabel.text integerValue];
    left.hour   = [self.hourLabel.text integerValue];
    left.minute = [self.minuteLabel.text integerValue];
    left.second = [self.secondLabel.text integerValue];
    return left;
}

@end
