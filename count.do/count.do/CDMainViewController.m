//
//  CDViewController.m
//  count.do
//
//  Created by Can Bülbül on 6/6/13.
//  Copyright (c) 2013 Can Bülbül. All rights reserved.
//

#import "CDMainViewController.h"
#import "CDTimerCell.h"
#import "CDBaseConversion.h"
#define bgColor [UIColor colorWithRed:(236/255.0) green:(240/255.0) blue:(241/255.0) alpha:1]

@interface CDMainViewController ()

@end

@implementation CDMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = bgColor;
    NSLog(@"started");
	// Do any additional setup after loading the view, typically from a nib.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setSelected)
                                                 name:@"selected"
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    reminders = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"reminders"]];
    if (!reminders) {
        reminders = [NSMutableArray arrayWithCapacity:10];
        [[NSUserDefaults standardUserDefaults] setObject:reminders forKey:@"reminders"];
    }
    selected = -1;
    [self.timers reloadData];
}

- (void)viewDidDisappear:(BOOL)animated{
    CDTimerCell *cell = (CDTimerCell *)[self.timers cellForItemAtIndexPath:selectedIndexPath];
    [UIView animateWithDuration:0.3 animations:^{
        cell.selectMenu.alpha=0;
    } completion:^(BOOL finished) {
        selected = -1;
        selectedIndexPath = nil;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Collection View Delegate Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    return [reminders count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CDTimerCell *cell = (CDTimerCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if(selected!=indexPath.row)
        [UIView animateWithDuration:0.3 animations:^{
            cell.selectMenu.alpha=1;
        }];
    else
        [UIView animateWithDuration:0.3 animations:^{
            cell.selectMenu.alpha=0;
        } completion:^(BOOL finished) {
            selected = -1;
            selectedIndexPath = nil;
        }];
    selected = indexPath.row;
    selectedIndexPath = indexPath;
    NSLog(@"alarm: %@",reminders[selected][@"alarm"]);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    CDTimerCell *cell = (CDTimerCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.3 animations:^{
        cell.selectMenu.alpha=0;
    }];
}

#pragma mark -
#pragma mark Collection View Data Source Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    int dataIndexL = indexPath.row;
    
    CDTimerCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"timer" forIndexPath:indexPath];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"dd/MM/yyyy HH:mm:ss"];
    cell.comps = [cal components:NSYearCalendarUnit  |
    NSMonthCalendarUnit |
    NSDayCalendarUnit   |
    NSHourCalendarUnit  |
    NSMinuteCalendarUnit|
    NSSecondCalendarUnit fromDate:[formatter dateFromString:reminders[dataIndexL][@"date"]]];
    cell.init = [formatter dateFromString:reminders[dataIndexL][@"init"]];
    cell.selectMenu.tag = dataIndexL;
    cell.titleLabel.text = reminders[dataIndexL][@"title"];
    [cell initialize];
    if ([reminders[dataIndexL][@"alarm"] isEqualToString:@"0"]) {
        cell.alarmButton.alpha=0.5;
    }
    
    return cell;
} 

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind: kind withReuseIdentifier:@"addNew" forIndexPath:indexPath];
    }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind: kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        reusableView.backgroundColor = bgColor;
    }
    return reusableView;
}


#pragma mark -
#pragma mark Item Menu Methods
- (IBAction)deleteItem:(id)sender {
    CDTimerCell *cell = (CDTimerCell *)[self.timers cellForItemAtIndexPath:selectedIndexPath];
    [UIView animateWithDuration:0.3 animations:^{
        cell.alpha=0;
    } completion:^(BOOL finished) {
        //remove selected item
        [reminders removeObjectAtIndex:selected];
        //sort the rest as a failsafe
        /*NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:true];
        NSArray *sorted = [reminders sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];*/
        [[NSUserDefaults standardUserDefaults] setObject:reminders forKey:@"reminders"];
        selectedIndexPath = nil;
        selected = -1;
        [self.timers reloadData];
    }];
}

- (IBAction)toggleAlarm:(id)sender{
    CDTimerCell *cell = (CDTimerCell *)[self.timers cellForItemAtIndexPath:selectedIndexPath];
    NSMutableDictionary *reminder = [NSMutableDictionary dictionaryWithDictionary:reminders[selected]];
    
    if ([reminder[@"alarm"] isEqualToString:@"1"]) {
        UIApplication *app = [UIApplication sharedApplication];
        NSArray *eventArray = [app scheduledLocalNotifications];
        for (int i=0; i<[eventArray count]; i++)
        {
            UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
            NSDictionary *userInfoCurrent = oneEvent.userInfo;
            NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"uid"]];
            if ([uid isEqualToString:reminder[@"timestamp"]])
            {
                NSLog(@"cancelled");
                [app cancelLocalNotification:oneEvent];
                break;
            }
        }
        [UIView animateWithDuration:0.3 animations:^{
            cell.alarmButton.alpha = 0.5;
        } completion:^(BOOL finished) {
            [reminders removeObjectAtIndex:selected];
            reminder[@"alarm"] = @"0";
            [reminders insertObject:reminder atIndex:selected];
            [[NSUserDefaults standardUserDefaults] setObject:reminders forKey:@"reminders"];
            NSLog(@"%@",reminders);
        }];
        
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: @"dd/MM/yyyy HH:mm:ss"];
        NSDate *date = [formatter dateFromString:reminder[@"date"]];
                     
        //Set an alarm
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        if (localNotif != nil){
            localNotif.fireDate = date;
            localNotif.timeZone = [NSTimeZone defaultTimeZone];
            // Notification details
            localNotif.alertBody = [NSString stringWithFormat:@"Countdown finished: %@",reminder[@"title"]];
            localNotif.alertAction = @"Dismiss";
            localNotif.soundName = UILocalNotificationDefaultSoundName;
            localNotif.applicationIconBadgeNumber = 1;
            localNotif.userInfo = @{@"uid":reminder[@"timestamp"]};
            // Schedule the notification
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
            [UIView animateWithDuration:0.3 animations:^{
                cell.alarmButton.alpha = 1;
            } completion:^(BOOL finished) {
                [reminders removeObjectAtIndex:selected];
                reminder[@"alarm"] = @"1";
                [reminders insertObject:reminder atIndex:selected];
                [[NSUserDefaults standardUserDefaults] setObject:reminders forKey:@"reminders"];
                NSLog(@"%@",reminders);
            }];
        }
    }
}

- (IBAction)shareTW:(id)sender {
    NSMutableDictionary *reminder = [NSMutableDictionary dictionaryWithDictionary:reminders[selected]];
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            [controller dismissViewControllerAnimated:YES completion:nil];
        };
        controller.completionHandler = myBlock;
        
        [controller setInitialText:[NSString stringWithFormat:@"countdo.co/%@ @countdoapp",[self scramble:reminder[@"timestamp"]]]];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (IBAction)shareFB:(id)sender {
    NSMutableDictionary *reminder = [NSMutableDictionary dictionaryWithDictionary:reminders[selected]];
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            [controller dismissViewControllerAnimated:YES completion:nil];
        };
        controller.completionHandler = myBlock;
        [controller setInitialText:[NSString stringWithFormat:@"countdo.co/%@",[self scramble:reminder[@"timestamp"]]]];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (NSString *)scramble:(NSString *)timestamp{
    int multiplier = 457291;//arc4random_uniform(90000)+10000;
    int base       = [timestamp integerValue];
    long done       = (base*multiplier);
    
    NSString *converted = [CDBaseConversion formatNumber:done toBase:62];
    
    return [NSString stringWithFormat:@"%@",converted];
    //,multiplier];
}

- (void) setSelected {
    NSLog(@"select gesture");
    NSIndexPath *path = [NSIndexPath indexPathForRow:[[NSUserDefaults standardUserDefaults] integerForKey:@"selected"] inSection:1];
    selected = path.row;
    selectedIndexPath = path;
}

@end
