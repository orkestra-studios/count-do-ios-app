//
//  CDAddTimerViewController.m
//  count.do
//
//  Created by Ali Can Bülbül on 6/6/13.
//  Copyright (c) 2013 Can Bülbül. All rights reserved.
//

#import "CDAddTimerViewController.h"
#import "NSDate+Reporting.h"
#define dayNums @{@"Sunday":@0,@"Monday":@1,@"Tuesday":@2,@"Wednesday":@3,@"Thursday":@4,@"Friday":@5,@"Saturday":@6}

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
    UITapGestureRecognizer *shieldToggle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdits)];
    [self.shield addGestureRecognizer:shieldToggle];
    [self redrawDateValues];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveReminder:(id)sender {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"dd/MM/yyyy HH:mm:ss"];
    NSDate *selected = [cal dateFromComponents:date];
    NSMutableArray *reminders = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"reminders"]];
    [reminders addObject:@{@"title":self.titleInput.text,@"date":[formatter stringFromDate:selected], @"init":[formatter stringFromDate:[NSDate date]], @"timestamp":@([selected timeIntervalSince1970])}];
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:true];
    NSArray *sorted = [reminders sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
                               
    
    [[NSUserDefaults standardUserDefaults] setObject:sorted forKey:@"reminders"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Date Selector Methods

- (void) redrawDateValues {
    yearLabel.text = [NSString stringWithFormat:@"%d",date.year];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    monthLabel.text = [[[df monthSymbols] objectAtIndex:(date.month-1)] uppercaseString];
    NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
    [weekday setDateFormat: @"EEEE"];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *selected = [cal dateFromComponents:date];
    
    days = [NSMutableArray arrayWithCapacity:42];
    for (int t=0; t<42; t++) days[t] = @"*";
    
    NSDate *first = [NSDate firstDayOfMonthFromDate:selected];
    NSDate *last  = [NSDate lastDayOfMonthFromDate:[NSDate firstDayOfPreviousMonthFromDate:selected]];
    
    int day = [cal rangeOfUnit:NSDayCalendarUnit
                       inUnit:NSMonthCalendarUnit
                      forDate:selected].length;
    
    int dayLast = [cal rangeOfUnit:NSDayCalendarUnit
                        inUnit:NSMonthCalendarUnit
                       forDate:last].length;

    for (i=0; i<[dayNums[[weekday stringFromDate:first]] intValue]; i++) {
        days[i] = [NSString stringWithFormat:@"%d",dayLast + (i+1) - [dayNums[[weekday stringFromDate:first]] intValue]];
    }
    for (j=0; j<day; j++) {
        days[j+i] = [NSString stringWithFormat:@"%d",j+1];
    }
    for (k=0; k<(7-(i+j)%7); k++) {
        days[i+j+k] = [NSString stringWithFormat:@"%d",k+1];
    }
    [self.calendar reloadData];
    hourLabel.text = [NSString stringWithFormat:@"%02d",date.hour];
    minLabel.text = [NSString stringWithFormat:@"%02d",(date.minute-date.minute%5)];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.monthLabel.alpha = 1;
        self.calendar.alpha   = 1;
        self.hourLabel.alpha  = 1;
        self.minLabel.alpha   = 1;
    }];
    [UIView animateWithDuration:0.4 animations:^{
        self.yearLabel.alpha=1;
    }];
    
}

- (IBAction)nextMonth:(id)sender {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.monthLabel.alpha=0.2;
        self.calendar.alpha = 0.5;
    }];
    if(date.month<11) date.month++;
    else {
        date.month=1;
        date.year++;
        [UIView animateWithDuration:0.4 animations:^{
            self.yearLabel.alpha=0.2;
        }];
    }
    [self redrawDateValues];
}
- (IBAction)previousMonth:(id)sender;
    {[UIView animateWithDuration:0.2 animations:^{
        self.monthLabel.alpha=0.2;
        self.calendar.alpha=0.5;
    }];
    if(date.month>1) date.month--;
    else {
        date.month=12;
        date.year--;
        [UIView animateWithDuration:0.4 animations:^{
            self.yearLabel.alpha=0.2;
        }];
    }
    [self redrawDateValues];
}

- (IBAction)nextHour:(id)sender{
    [UIView animateWithDuration:0.2 animations:^{
        self.hourLabel.alpha=0.1;
    }];
    if(date.hour<23) date.hour++;
    else {
        date.hour=0;
        //TODO: increment day
    }
    [self redrawDateValues];
}
- (IBAction)previousHour:(id)sender{
    [UIView animateWithDuration:0.2 animations:^{
        self.hourLabel.alpha=0.1;
    }];
    if(date.hour>1) date.hour--;
    else {
        date.hour = 23;
        //TODO: decrement day
    }
    [self redrawDateValues];
}

- (IBAction)nextMin:(id)sender{
    [UIView animateWithDuration:0.2 animations:^{
        self.minLabel.alpha=0.1;
    }];
    if(date.minute<59) date.minute+=5;
    else {
        date.minute=0;
        [self nextHour:nil];
    }
    [self redrawDateValues];
}
- (IBAction)previousMin:(id)sender{
    [UIView animateWithDuration:0.2 animations:^{
        self.minLabel.alpha=0.1;
    }];
    if(date.minute>0) date.minute-=5;
    else {
        date.minute=59;
        [self previousHour:nil];
    }
    [self redrawDateValues];
}

#pragma mark -
#pragma mark Collection View Delegate Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    if(i+j<29) return 28;
    if(i+j>35) return 42;
    else return 35;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row>=i && indexPath.row<i+j) {
        date.day = indexPath.row-i+1;
        [self redrawDateValues];
        [self.calendar reloadData];
    }
}


#pragma mark -
#pragma mark Collection View Data Source Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"day"
                                                                  forIndexPath:indexPath];
    ((UILabel *)[cell viewWithTag:1]).text = days[indexPath.row];
    if (indexPath.row<i) {
        ((UILabel *)[cell viewWithTag:1]).textColor = [UIColor lightGrayColor];
    } else if (indexPath.row>=i+j) {
        ((UILabel *)[cell viewWithTag:1]).textColor = [UIColor lightGrayColor];
    } else {
        ((UILabel *)[cell viewWithTag:1]).textColor = [UIColor blackColor];
    }
    if (indexPath.row-i+1==date.day) {
        cell.backgroundColor = [UIColor colorWithRed:230/255.0 green:97/255.0 blue:97/255.0 alpha:1];
        ((UILabel *)[cell viewWithTag:1]).font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        ((UILabel *)[cell viewWithTag:1]).textColor = [UIColor whiteColor];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
        ((UILabel *)[cell viewWithTag:1]).font = [UIFont fontWithName:@"Helvetica-Light" size:15];
    }
    return cell;
}

#pragma mark -
#pragma mark Text Field Delegate Methods

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    self.shield.alpha=0;
    [self.view bringSubviewToFront:self.shield];
    [UIView animateWithDuration:0.3 animations:^{
        self.shield.alpha=0.7;
    }];
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.3 animations:^{
        self.shield.alpha=0;
    } completion:^(BOOL finished) {
        [self.view sendSubviewToBack:self.shield];
    }];
}

- (IBAction) textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (void)endEdits {
    [self.titleInput resignFirstResponder];
}

@end
