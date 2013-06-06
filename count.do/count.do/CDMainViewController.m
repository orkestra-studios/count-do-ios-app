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
    return 1;
}


#pragma mark -
#pragma mark Collection View Data Source Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CDTimerCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"timer"
                                                                           forIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"kind %@",kind);
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind: kind withReuseIdentifier:@"addNew" forIndexPath:indexPath];
    }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind: kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
    }
    return reusableView;
}

@end
