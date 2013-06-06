//
//  CDAddTimerViewController.m
//  count.do
//
//  Created by Ali Can Bülbül on 6/6/13.
//  Copyright (c) 2013 Can Bülbül. All rights reserved.
//

#import "CDAddTimerViewController.h"

@interface CDAddTimerViewController ()

@end

@implementation CDAddTimerViewController
@synthesize monthLabel;
@synthesize yearLabel;
@synthesize hourLabel;
@synthesize minLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSDate *current = [NSDate date];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    date = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit| NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:current];
    
    [self redrawDateValues];
    
    days = [NSMutableArray arrayWithCapacity:42];
    for(int i=1;i<43;i++){
        days[i-1] = [NSString stringWithFormat:@"%d",(i % 31)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Date Selector Methods
- (void) redrawDateValues {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    monthLabel.text = [[df monthSymbols] objectAtIndex:(date.month-1)];
    yearLabel.text = [NSString stringWithFormat:@"%d",date.year];
    hourLabel.text = [NSString stringWithFormat:@"%d",date.hour];
    minLabel.text = [NSString stringWithFormat:@"%d",date.minute];
}


#pragma mark -
#pragma mark Collection View Delegate Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    return 42;
}


#pragma mark -
#pragma mark Collection View Data Source Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"day"
                                                                  forIndexPath:indexPath];
    ((UILabel *)[cell viewWithTag:1]).text = days[indexPath.row];
    return cell;
}

@end
