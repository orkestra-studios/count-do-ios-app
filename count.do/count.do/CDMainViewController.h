//
//  CDViewController.h
//  count.do
//
//  Created by Ali Can Bülbül on 6/6/13.
//  Copyright (c) 2013 Can Bülbül. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDMainViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableArray *reminders;
    int selected;
    int selectedSize;
    int dataIndex,indexpath;
    BOOL selfSelect;
    NSTimer *openTimer,*closeTimer;
}
@property (weak, nonatomic) IBOutlet UICollectionView *timers;

- (void) openMenu;
- (void) closeMenu;

@end
