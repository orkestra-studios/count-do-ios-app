//
//  CDViewController.h
//  count.do
//
//  Created by Ali Can Bülbül on 6/6/13.
//  Copyright (c) 2013 Can Bülbül. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import <stdlib.h>
#import <iAd/iAd.h>

@interface CDMainViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate,
    ADBannerViewDelegate>
{
    NSMutableArray *reminders;
    int selected;
    NSIndexPath *selectedIndexPath;
    int selected_n;
    NSIndexPath *selectedIndexPath_n;
    NSTimer *timer;
    dispatch_queue_t bgq;
}
@property (weak, nonatomic) IBOutlet UICollectionView *timers;
@property (weak, nonatomic) IBOutlet ADBannerView *banner;

- (void)setSelected;
- (IBAction)deleteItem:(id)sender;
- (IBAction)toggleAlarm:(id)sender;
- (IBAction)shareFB:(id)sender;
- (IBAction)shareTW:(id)sender;
- (void) deselect;
- (void)endEdit;
- (NSString *)scramble:(NSString *)timestamp with:(NSString *)key;
- (NSString *) timeLeft:(NSDateComponents *)from;

@end
