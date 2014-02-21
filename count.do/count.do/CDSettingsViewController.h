//
//  CDSettingsViewController.h
//  count.do
//
//  Created by Can Bülbül on 11/02/14.
//  Copyright (c) 2014 Can Bülbül. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDSettingsViewController : UIViewController
{
    NSMutableDictionary *settings;
}
@property (weak, nonatomic) IBOutlet UIButton *basicThemeButton;
@property (weak, nonatomic) IBOutlet UILabel *basicThemeLabel;
@property (weak, nonatomic) IBOutlet UIButton *redThemeButton;
@property (weak, nonatomic) IBOutlet UILabel *redThemeLabel;
@property (weak, nonatomic) IBOutlet UIButton *darkThemeButton;
@property (weak, nonatomic) IBOutlet UILabel *darkThemeLabel;
@property (weak, nonatomic) IBOutlet UIButton *NoPriorityButton;
@property (weak, nonatomic) IBOutlet UILabel *noPriorityLabel;
@property (weak, nonatomic) IBOutlet UIButton *leveledPriorityButton;
@property (weak, nonatomic) IBOutlet UILabel *leveledPriorityLabel;
@property (weak, nonatomic) IBOutlet UIButton *BasicRemainderButton;
@property (weak, nonatomic) IBOutlet UILabel *basicReminderLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailedRemainderButton;
@property (weak, nonatomic) IBOutlet UILabel *detailedReminderLabel;
@property (weak, nonatomic) IBOutlet UIView *themeShield;
@property (weak, nonatomic) IBOutlet UIView *priorityShield;
@property (weak, nonatomic) IBOutlet UIView *reminderShield;
@property (weak, nonatomic) IBOutlet UIButton *goBack;

@end
