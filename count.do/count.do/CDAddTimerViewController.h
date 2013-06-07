//
//  CDAddTimerViewController.h
//  count.do
//
//  Created by Ali Can Bülbül on 6/6/13.
//  Copyright (c) 2013 Can Bülbül. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDAddTimerViewController : UIViewController <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableArray *days;
    NSDateComponents *date;
    int i,j,k;
}
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleInput;
@property (weak, nonatomic) IBOutlet UICollectionView *calendar;
@property (weak, nonatomic) IBOutlet UIView *shield;

- (void) redrawDateValues;

- (IBAction)nextMonth:(id)sender;
- (IBAction)previousMonth:(id)sender;

- (IBAction)nextHour:(id)sender;
- (IBAction)previousHour:(id)sender;

- (IBAction)nextMin:(id)sender;
- (IBAction)previousMin:(id)sender;

- (IBAction)goBack:(id)sender;

- (void)endEdits;

@end
