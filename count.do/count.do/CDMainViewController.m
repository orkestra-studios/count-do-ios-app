//
//  CDViewController.m
//  count.do
//
//  Created by Can Bülbül on 6/6/13.
//  Copyright (c) 2013 Can Bülbül. All rights reserved.
//

#import "CDMainViewController.h"
#import "CDTimerCell.h"
#import "CDAddTimerViewController.h"
#import "CDBaseConversion.h"
#import "CDProgressView.h"

#define bgColor [UIColor colorWithRed:(236/255.0) green:(240/255.0) blue:(241/255.0) alpha:1]

@interface CDMainViewController ()

@end

@implementation CDMainViewController

- (void)viewDidLoad
{
    if ([selectedTheme isEqualToString:@"basic"]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    /* Initial setup */
    bgq = dispatch_queue_create("com.orkestra.count-do.bgq", NULL);
    selected = -1; // None of the timers are selected
    /* A tap to background will also unselect it */
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deselect)];
    UIView *gView = [[UIView alloc] initWithFrame:self.timers.frame];
    [gView addGestureRecognizer:tgr];
    self.timers.backgroundView = gView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setSelected)
                                                 name:@"selected"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(endEdit)
                                                 name:@"editingEnd"
                                               object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = colors[selectedTheme][@"background"];

    reminders = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"reminders"]];
    for (int i=0;i<[reminders count];i++) {
        NSMutableDictionary *reminder = [[NSMutableDictionary alloc] initWithDictionary:reminders[i]];
        if(![reminder objectForKey:@"priority"]){
            reminder[@"priority"] = @0;
        }
        reminders[i] = reminder;
    }
    [[NSUserDefaults standardUserDefaults] setObject:reminders forKey:@"reminders"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (!reminders) {
        reminders = [NSMutableArray arrayWithCapacity:10];
        [[NSUserDefaults standardUserDefaults] setObject:reminders forKey:@"reminders"];
    }
    [self closeDeletePopup:nil];
    [self.timers reloadData];
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
    cell.initial = [formatter dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"init"]];
    cell.selectMenu.tag = dataIndexL;
    cell.doneButton.tag = dataIndexL;
    cell.titleLabel.text = reminders[dataIndexL][@"title"];
    [cell initialize];
    NSLog(@"cell-final:%@",cell);
    if ([reminders[dataIndexL][@"alarm"] isEqualToString:@"0"]) {
        cell.alarmButton.alpha=0.5;
    }
    if([priorityType isEqualToString:@"none"] || !boughtPriority){
        cell.priorityButton.hidden = true;
        cell.priorityImage.alpha = 0;
    }else {
        cell.priorityButton.hidden = false;
        @try {
            if ([reminders[dataIndexL][@"priority"] isEqualToNumber:@1]) {
                cell.priorityButton.alpha = 1;
                cell.priorityImage.alpha = 1;
            }else {
                cell.priorityButton.alpha = 0.3;
                cell.priorityImage.alpha = 0;
            }
        }
        @catch (NSException *exception) {
            cell.priorityButton.alpha = 0.3;
            cell.priorityImage.alpha = 0;
        }
    }
    return cell;
} 

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind: kind withReuseIdentifier:@"addNew" forIndexPath:indexPath];
        [((UIButton *)[reusableView viewWithTag:1]) setImage:[UIImage imageNamed:[NSString stringWithFormat:@"addnewcountdown_%@",selectedTheme]] forState:UIControlStateNormal];
    }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind: kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        //reusableView.backgroundColor = bgColor;
        /*UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deselect)];
        [reusableView addGestureRecognizer:tgr];*/
        [((UIButton *)[reusableView viewWithTag:1]) setTitleColor:colors[selectedTheme][@"secondarycolor"] forState:UIControlStateNormal];
        [((UIButton *)[reusableView viewWithTag:1]) setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"settings_bg_%@",selectedTheme]] forState:UIControlStateNormal];
    }
    return reusableView;
}


#pragma mark -
#pragma mark Item Menu Methods

- (IBAction)deleteItem:(id)sender {
    CDTimerCell *cell = (CDTimerCell *)[self.timers cellForItemAtIndexPath:selectedIndexPath];
    //remove calibration request
    [[NSNotificationCenter defaultCenter] removeObserver:cell];
    //remove alarm
    NSMutableDictionary *reminder = [NSMutableDictionary dictionaryWithDictionary:reminders[selected]];
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSNumber *uid=[userInfoCurrent valueForKey:@"uid"];
        if ([uid isEqual:reminder[@"timestamp"]])
        {
            [app cancelLocalNotification:oneEvent];
            break;
        }
    }
    //remove cell
    [UIView animateWithDuration:0.4 animations:^{
        cell.alpha=0;
    } completion:^(BOOL finished) {
        //remove selected item
        [reminders removeObjectAtIndex:selected];
        //sort the rest as a failsafe
        /*NSSortDescriptor * sorat = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:true];
         NSArray *sorted = [reminders sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];*/
        [[NSUserDefaults standardUserDefaults] setObject:reminders forKey:@"reminders"];
        selectedIndexPath = nil;
        selected = -1;
        [[NSUserDefaults standardUserDefaults] setObject:[reminders lastObject][@"date"] forKey:@"init"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        cell.alpha=1;
        cell.hidden=false;
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
            NSNumber *uid=[userInfoCurrent valueForKey:@"uid"];
            if ([uid isEqual:reminder[@"timestamp"]])
            {
                [app cancelLocalNotification:oneEvent];
                break;
            }
        }
        [UIView animateWithDuration:0.2 animations:^{
            cell.alarmButton.alpha = 0.3;
        } completion:^(BOOL finished) {
            [reminders removeObjectAtIndex:selected];
            reminder[@"alarm"] = @"0";
            [reminders insertObject:reminder atIndex:selected];
            [[NSUserDefaults standardUserDefaults] setObject:reminders forKey:@"reminders"];
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
            localNotif.soundName = @"sound.m4r";
            localNotif.applicationIconBadgeNumber = 1;
            localNotif.userInfo = @{@"uid":reminder[@"timestamp"]};
            // Schedule the notification
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
            [UIView animateWithDuration:0.2 animations:^{
                cell.alarmButton.alpha = 1;
            } completion:^(BOOL finished) {
                [reminders removeObjectAtIndex:selected];
                reminder[@"alarm"] = @"1";
                [reminders insertObject:reminder atIndex:selected];
                [[NSUserDefaults standardUserDefaults] setObject:reminders forKey:@"reminders"];
            }];
        }
    }
}

- (IBAction)togglePriority:(id)sender{
    CDTimerCell *cell = (CDTimerCell *)[self.timers cellForItemAtIndexPath:selectedIndexPath];
    NSMutableDictionary *reminder = [NSMutableDictionary dictionaryWithDictionary:reminders[selected]];
    @try {
        if ([reminder[@"priority"] isEqualToNumber:@1]) {
            [UIView animateWithDuration:0.2 animations:^{
                cell.priorityButton.alpha = 0.3;
                cell.priorityImage.alpha = 0;
            } completion:^(BOOL finished) {
                [reminders removeObjectAtIndex:selected];
                reminder[@"priority"] = @0;
                [reminders insertObject:reminder atIndex:selected];
                NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:true];
                reminders = [[NSMutableArray alloc] initWithArray:[reminders sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]]];
                sort = [[NSSortDescriptor alloc] initWithKey:@"priority" ascending:false];
                reminders = [[NSMutableArray alloc] initWithArray:[reminders sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]]];
                [[NSUserDefaults standardUserDefaults] setObject:reminders forKey:@"reminders"];
                [self.timers reloadData];
            }];
            
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                cell.priorityButton.alpha = 1;
                cell.priorityImage.alpha = 1;
            } completion:^(BOOL finished) {
                [reminders removeObjectAtIndex:selected];
                reminder[@"priority"] = @1;
                [reminders insertObject:reminder atIndex:selected];
                NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:true];
                reminders = [[NSMutableArray alloc] initWithArray:[reminders sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]]];
                sort = [[NSSortDescriptor alloc] initWithKey:@"priority" ascending:false];
                reminders = [[NSMutableArray alloc] initWithArray:[reminders sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]]];
                [[NSUserDefaults standardUserDefaults] setObject:reminders forKey:@"reminders"];
                [self.timers reloadData];
            }];
        }
    }
    @catch (NSException *exception) {
        [UIView animateWithDuration:0.2 animations:^{
            cell.priorityButton.alpha = 1;
            cell.priorityImage.alpha = 1;
        } completion:^(BOOL finished) {
            [reminders removeObjectAtIndex:selected];
            reminder[@"priority"] = @1;
            [reminders insertObject:reminder atIndex:selected];
            NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:true];
            reminders = [[NSMutableArray alloc] initWithArray:[reminders sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]]];
            sort = [[NSSortDescriptor alloc] initWithKey:@"priority" ascending:false];
            reminders = [[NSMutableArray alloc] initWithArray:[reminders sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]]];
            [[NSUserDefaults standardUserDefaults] setObject:reminders forKey:@"reminders"];
            [self.timers reloadData];
        }];
    }
}

- (IBAction)shareTW:(id)sender {
    CDTimerCell *cell = (CDTimerCell *)[self.timers cellForItemAtIndexPath:selectedIndexPath];
    NSMutableDictionary *reminder = [NSMutableDictionary dictionaryWithDictionary:reminders[selected]];
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            [controller dismissViewControllerAnimated:YES completion:nil];
        };
        controller.completionHandler = myBlock;
        
        [controller setInitialText:[NSString stringWithFormat:@"%@ %@. countdo.co/%@ @countdoapp",[self timeLeft:[cell getDate]],reminder[@"title"],[self scramble:reminder[@"timestamp"] with:reminder[@"title"]]]];
        [self presentViewController:controller animated:YES completion:nil];
        dispatch_async(bgq, ^{
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://countdo.co/save/%@/%@/%@",[self scramble:reminder[@"timestamp"] with:reminder[@"title"]],reminder[@"title"],reminder[@"timestamp"]] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
            [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        });
    }
}

- (IBAction)shareFB:(id)sender {
    CDTimerCell *cell = (CDTimerCell *)[self.timers cellForItemAtIndexPath:selectedIndexPath];
    NSMutableDictionary *reminder = [NSMutableDictionary dictionaryWithDictionary:reminders[selected]];
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            [controller dismissViewControllerAnimated:YES completion:nil];
        };
        controller.completionHandler = myBlock;
        [controller setInitialText:[NSString stringWithFormat:@"%@ %@. countdo.co/%@",[self timeLeft:[cell getDate]],reminder[@"title"],[self scramble:reminder[@"timestamp"] with:reminder[@"title"]]]];
        [self presentViewController:controller animated:YES completion:^{
            dispatch_async(bgq, ^{
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://countdo.co/save/%@/%@/%@",[self scramble:reminder[@"timestamp"] with:reminder[@"title"]],reminder[@"title"],reminder[@"timestamp"]] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
                [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            });
        }];
    }
}

- (NSString *)scramble:(NSString *)timestamp with:(NSString *)key{
    NSString *pKey;
    if (key.length<8) {
        pKey = [[key stringByReplacingOccurrencesOfString:@" " withString:@"q"] substringToIndex:4];
    }else pKey = [key substringToIndex:4];
    int multiplier = 457291;//arc4random_uniform(90000)+10000;
    int base       = [timestamp integerValue];
    long long int done = ((long long)base)*multiplier/1000000;
    long long int qKey = [CDBaseConversion decode62:pKey];
    
    
    NSString *converted = [CDBaseConversion formatNumber:(done+qKey) toBase:62];
    return [NSString stringWithFormat:@"%@",converted];
    //,multiplier];
}

- (IBAction) openDeletePopup:(id)sender {
    CDTimerCell *cell = (CDTimerCell *)[self.timers cellForItemAtIndexPath:selectedIndexPath];
    cell.deletePopup.hidden = false;
    cell.deletePopup.alpha  = 0;
    [UIView animateWithDuration:0.4 animations:^{
        cell.deletePopup.alpha = 1;
    } completion:nil];
}

- (IBAction) closeDeletePopup:(id)sender {
    CDTimerCell *cell = (CDTimerCell *)[self.timers cellForItemAtIndexPath:selectedIndexPath];
    [UIView animateWithDuration:0.4 animations:^{
        cell.deletePopup.alpha = 0;
    } completion:^(BOOL finished) {
        cell.deletePopup.hidden = true;
    }];
}

- (void) setSelected {
    NSIndexPath *path = [NSIndexPath indexPathForRow:[[NSUserDefaults standardUserDefaults] integerForKey:@"selected"] inSection:1];
    selected = path.row;
    selectedIndexPath = path;
}

- (void) deselect {
    CDTimerCell *cell = (CDTimerCell *)[self.timers cellForItemAtIndexPath:selectedIndexPath];
    [self closeDeletePopup:nil];
    [UIView animateWithDuration:0.4 animations:^{
        cell.selectMenu.alpha = 0;
    } completion:^(BOOL finished) {
        selectedIndexPath = nil;
        selected = -1;
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"edit"]){
        NSMutableDictionary *reminder = [NSMutableDictionary dictionaryWithDictionary:reminders[selected]];
        [[NSUserDefaults standardUserDefaults] setObject:reminder forKey:@"edit"];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"editing"];
        selected_n = selected;
        selectedIndexPath_n = selectedIndexPath;
    }else {
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"editing"];
    }
    CDTimerCell *cell = (CDTimerCell *)[self.timers cellForItemAtIndexPath:selectedIndexPath];
        cell.selectMenu.alpha=0;
        selected = -1;
        selectedIndexPath = nil;
}

- (void)endEdit {
    selectedIndexPath = selectedIndexPath_n;
    selected = selected_n;
    //remove selected item
    [reminders removeObjectAtIndex:selected];
    [[NSUserDefaults standardUserDefaults] setObject:reminders forKey:@"reminders"];
    selectedIndexPath = nil;
    selected = -1;
    [self.timers reloadData];
}

- (IBAction)itemDone:(id)sender{
    UIButton *d = (UIButton *)sender;
    [[NSUserDefaults standardUserDefaults] setInteger:d.tag forKey:@"selected"];
    [self setSelected];
    [self deleteItem:nil];
}

- (NSString *) timeLeft:(NSDateComponents *)from {
    NSString *yearString, *monthString, *dayString, *hourString, *minString, *secString;
    yearString = monthString = dayString = hourString = minString = secString = @"";
    NSString *plural;
    if (from.year>0) {
        plural = (from.year>1) ? @"s" : @"";
        yearString = [NSString stringWithFormat:@"%d year%@ ",from.year,plural];
    }
    if (from.year>0 || from.month>0) {
        plural = (from.month>1) ? @"s" : @"";
        monthString = [NSString stringWithFormat:@"%d month%@ ",from.month,plural];
    }
    if (from.year>0 || from.month>0 || from.day>0) {
        plural = (from.day>1) ? @"s" : @"";
        dayString = [NSString stringWithFormat:@"%d day%@ ",from.day,plural];
    }
    if (from.year>0 || from.month>0 || from.day>0 || from.hour>0) {
        plural = (from.hour>1) ? @"s" : @"";
        hourString = [NSString stringWithFormat:@"%d hour%@ ",from.hour,plural];
    }
    if (from.year>0 || from.month>0 || from.day>0 || from.hour>0 || from.minute>0) {
        plural = (from.minute>1) ? @"s" : @"";
        minString = [NSString stringWithFormat:@"%d minute%@ and ",from.minute,plural];
    }
    if (from.year>0 || from.month>0 || from.day>0 || from.hour>0 || from.minute>0 || from.second>0) {
        plural = (from.second>1 || from.second==0) ? @"s" : @"";
        secString = [NSString stringWithFormat:@"%d second%@ to",from.second,plural];
    }
    return [NSString stringWithFormat:@"%@%@%@%@%@%@",yearString,monthString,dayString,hourString,minString,secString];
}

@end
