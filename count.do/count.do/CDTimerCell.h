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
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet CDProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *alarmButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) NSDateComponents *comps;
@property (strong, nonatomic) NSDate *initial;
@property (weak, nonatomic) IBOutlet UIView *selectMenu;
@property (weak, nonatomic) IBOutlet UIView *deletePopup;
@property (weak, nonatomic) IBOutlet UIView *priorityImage;
@property (weak, nonatomic) IBOutlet UIButton *priorityButton;

- (void)initialize;
- (void)showMenu;
- (NSDateComponents *)getDate;

@end
