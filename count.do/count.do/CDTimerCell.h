//
//  CDTimerCell.h
//  count.do
//
//  Created by Ali Can Bülbül on 6/6/13.
//  Copyright (c) 2013 Can Bülbül. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CDProgressView;

@interface CDTimerCell : UICollectionViewCell

{
    int timeLeft, firstLeft;
    NSDate *timerTarget;
    NSTimer *timer;
    
}
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet CDProgressView *progressView;

@property (strong, nonatomic) NSDateComponents *comps;



@end