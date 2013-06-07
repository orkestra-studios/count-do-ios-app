//
//  CDViewController.m
//  count.do
//
//  Created by Can Bülbül on 6/6/13.
//  Copyright (c) 2013 Can Bülbül. All rights reserved.
//

#import "CDMainViewController.h"
#import "CDTimerCell.h"
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
}

- (void)viewDidAppear:(BOOL)animated {
    reminders = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"reminders"]];
    if (!reminders) {
        reminders = [NSMutableArray arrayWithCapacity:10];
        [[NSUserDefaults standardUserDefaults] setObject:reminders forKey:@"reminders"];
    }
    selected = -2;
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
    if(selected!=-2) return [reminders count]+1;
    else return [reminders count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==selected+1 && selected!=-2) return;
    if (selected != indexPath.row) selected = indexPath.row;
    else selected = -2;
    NSLog(@"selected: %d",selected);
    [collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==selected+1 && selected!=-2)
        return CGSizeMake(320, 30);
    else
        return CGSizeMake(320, 90);
}

#pragma mark -
#pragma mark Collection View Data Source Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row==selected+1 && selected!=-2){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menu" forIndexPath:indexPath];
        return cell;
    }
    
    int dataIndex = (indexPath.row>selected && selected!=-2) ? indexPath.row-1 : indexPath.row;
    
    CDTimerCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"timer" forIndexPath:indexPath];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"dd/MM/yyyy HH:mm:ss"];
    cell.comps = [cal components:NSYearCalendarUnit  |
    NSMonthCalendarUnit |
    NSDayCalendarUnit   |
    NSHourCalendarUnit  |
    NSMinuteCalendarUnit|
    NSSecondCalendarUnit fromDate:[formatter dateFromString:reminders[dataIndex][@"date"]]];
    cell.init = [formatter dateFromString:reminders[dataIndex][@"init"]];
    
    cell.titleLabel.text = reminders[dataIndex][@"title"];
    [cell initialize];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind: kind withReuseIdentifier:@"addNew" forIndexPath:indexPath];
    }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind: kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
    }
    return reusableView;
}

@end
