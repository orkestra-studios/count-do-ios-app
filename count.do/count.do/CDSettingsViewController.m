//
//  CDSettingsViewController.m
//  count.do
//
//  Created by Can Bülbül on 11/02/14.
//  Copyright (c) 2014 Can Bülbül. All rights reserved.
//

#import "CDSettingsViewController.h"
#import "DEStoreKitManager.h"

@interface CDSettingsViewController ()

@end

@implementation CDSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scroller.frame = self.view.frame;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.scroller setContentSize:CGSizeMake(340, 638)];
    });
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self changeTheme];
    if ([[NSUserDefaults standardUserDefaults] dictionaryForKey:@"settings"]) {
        settings = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"settings"]];
        if(!settings[@"clock"]) {
            settings[@"clock"] = @"24";
        }
    }else{
        settings = [[NSMutableDictionary alloc] initWithDictionary:@{@"theme":@"basic",@"priority":@"none",@"reminder":@"basic",@"clock":@"24"}];
    }
    if (boughtThemes) {
        self.themeShield.hidden = true;
        //themes
        self.basicThemeButton.alpha = 0.3;
        self.redThemeButton.alpha = 0.3;
        self.darkThemeButton.alpha = 0.3;
        self.basicThemeLabel.alpha = 0.3;
        self.redThemeLabel.alpha = 0.3;
        self.darkThemeLabel.alpha = 0.3;
        self.basicThemeButton.userInteractionEnabled = true;
        self.redThemeButton.userInteractionEnabled = true;
        self.darkThemeButton.userInteractionEnabled = true;
        if([settings[@"theme"] isEqualToString:@"basic"]){
            self.basicThemeButton.alpha = 1;
            self.basicThemeLabel.alpha = 1;
            self.basicThemeButton.userInteractionEnabled = false;
        }else if([settings[@"theme"] isEqualToString:@"red"]){
            self.redThemeButton.alpha = 1;
            self.redThemeLabel.alpha = 1;
            self.redThemeButton.userInteractionEnabled = false;
        }else if([settings[@"theme"] isEqualToString:@"dark"]){
            self.darkThemeButton.alpha = 1;
            self.darkThemeLabel.alpha = 1;
            self.darkThemeButton.userInteractionEnabled = false;
        }
    }
    
    if (boughtPriority) {
        self.priorityShield.hidden = true;
        //priority
        self.NoPriorityButton.alpha = 0.3;
        self.noPriorityLabel.alpha = 0.3;
        self.NoPriorityButton.userInteractionEnabled = true;
        self.leveledPriorityButton.alpha = 0.3;
        self.leveledPriorityLabel.alpha = 0.3;
        self.leveledPriorityButton.userInteractionEnabled = true;
        if([settings[@"priority"] isEqualToString:@"none"]){
            self.NoPriorityButton.alpha = 1;
            self.noPriorityLabel.alpha = 1;
            self.NoPriorityButton.userInteractionEnabled = false;
        }else if([settings[@"priority"] isEqualToString:@"2level"]){
            self.leveledPriorityButton.alpha = 1;
            self.leveledPriorityLabel.alpha = 1;
            self.leveledPriorityButton.userInteractionEnabled = false;
        }
    }
    
    if (boughtReminder) {
        self.reminderShield.hidden = true;
        //reminder type
        self.BasicRemainderButton.alpha = 0.3;
        self.basicReminderLabel.alpha = 0.3;
        self.BasicRemainderButton.userInteractionEnabled = true;
        self.detailedRemainderButton.alpha = 0.3;
        self.detailedReminderLabel.alpha = 0.3;
        self.detailedRemainderButton.userInteractionEnabled = true;
        if([settings[@"reminder"] isEqualToString:@"basic"]){
            self.BasicRemainderButton.alpha = 1;
            self.basicReminderLabel.alpha = 1;
            self.BasicRemainderButton.userInteractionEnabled = false;
        }else if([settings[@"reminder"] isEqualToString:@"detailed"]){
            self.detailedRemainderButton.alpha = 1;
            self.detailedReminderLabel.alpha = 1;
            self.detailedRemainderButton.userInteractionEnabled = false;
        }
    }
    
    //clock type
    if([settings[@"clock"] isEqualToString:@"12"]){
        self.twelveButton.alpha = 1;
        self.twelveLabel.alpha = 1;
        self.twelveButton.userInteractionEnabled = false;
        self.twentyFourButton.userInteractionEnabled = true;
    }else if([settings[@"clock"] isEqualToString:@"24"]){
        self.twentyFourButton.alpha = 1;
        self.twentyFourLabel.alpha = 1;
        self.twentyFourButton.userInteractionEnabled = false;
        self.twelveButton.userInteractionEnabled = true;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setObject:settings forKey:@"settings"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) changeThemeOTF {
    if ([settings[@"theme"] isEqualToString:@"basic"]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    NSArray *subviews = self.view.subviews;
    for (UIView *v in subviews) {
        if ([v respondsToSelector:@selector(setImage:)]) {
            ((UIImageView *)v).image = [UIImage imageNamed:[NSString stringWithFormat:@"container_s_%@",settings[@"theme"]]];
        }else if ([v respondsToSelector:@selector(setTextColor:)]) {
            ((UILabel *)v).textColor = colors[settings[@"theme"]][@"textcolor"];
        }
    }
    self.view.backgroundColor = colors[settings[@"theme"]][@"background"];
    [self.goBack setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"settings_bg_%@",settings[@"theme"]]] forState:UIControlStateNormal];
    [self.goBack setTitleColor:colors[settings[@"theme"]][@"secondarycolor"] forState:UIControlStateNormal];
    [self.restoreButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"settings_bg_%@",settings[@"theme"]]] forState:UIControlStateNormal];
    [self.restoreButton setTitleColor:colors[settings[@"theme"]][@"secondarycolor"] forState:UIControlStateNormal];
}

- (void) changeTheme {
    NSArray *subviews = self.view.subviews;
    for (UIView *v in subviews) {
        if ([v respondsToSelector:@selector(setImage:)]) {
            ((UIImageView *)v).image = [UIImage imageNamed:[NSString stringWithFormat:@"container_s_%@",selectedTheme]];
        }else if ([v respondsToSelector:@selector(setTextColor:)]) {
            ((UILabel *)v).textColor = colors[selectedTheme][@"textcolor"];
        }
    }
    self.view.backgroundColor = colors[selectedTheme][@"background"];
    [self.goBack setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"settings_bg_%@",selectedTheme]] forState:UIControlStateNormal];
    [self.goBack setTitleColor:colors[selectedTheme][@"secondarycolor"] forState:UIControlStateNormal];
    [self.restoreButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"settings_bg_%@",selectedTheme]] forState:UIControlStateNormal];
    [self.restoreButton setTitleColor:colors[selectedTheme][@"secondarycolor"] forState:UIControlStateNormal];
}

- (IBAction)BasicTheme:(id)sender {
    self.basicThemeButton.alpha = 1;
    self.redThemeButton.alpha = 0.3;
    self.darkThemeButton.alpha = 0.3;
    self.basicThemeLabel.alpha = 1;
    self.redThemeLabel.alpha = 0.3;
    self.darkThemeLabel.alpha = 0.3;
    self.basicThemeButton.userInteractionEnabled = false;
    self.redThemeButton.userInteractionEnabled = true;
    self.darkThemeButton.userInteractionEnabled = true;
    settings[@"theme"] = @"basic";
    [self changeThemeOTF];
}
- (IBAction)RedTheme:(id)sender {
    self.basicThemeButton.alpha = 0.3;
    self.redThemeButton.alpha = 1;
    self.darkThemeButton.alpha = 0.3;
    self.basicThemeLabel.alpha = 0.3;
    self.redThemeLabel.alpha = 1;
    self.darkThemeLabel.alpha = 0.3;
    self.basicThemeButton.userInteractionEnabled = true;
    self.redThemeButton.userInteractionEnabled = false;
    self.darkThemeButton.userInteractionEnabled = true;
    settings[@"theme"] = @"red";
    [self changeThemeOTF];
}

- (IBAction)DarkTheme:(id)sender {
    self.basicThemeButton.alpha = 0.3;
    self.redThemeButton.alpha = 0.3;
    self.darkThemeButton.alpha = 1;
    self.basicThemeLabel.alpha = 0.3;
    self.redThemeLabel.alpha = 0.3;
    self.darkThemeLabel.alpha = 1;
    self.basicThemeButton.userInteractionEnabled = true;
    self.redThemeButton.userInteractionEnabled = true;
    self.darkThemeButton.userInteractionEnabled = false;
    settings[@"theme"] = @"dark";
    [self changeThemeOTF];
}

- (IBAction)NoPriority:(id)sender {
    self.NoPriorityButton.alpha =1;
    self.noPriorityLabel.alpha = 1;
    self.NoPriorityButton.userInteractionEnabled = false;
    self.leveledPriorityButton.alpha = 0.3;
    self.leveledPriorityLabel.alpha = 0.3;
    self.leveledPriorityButton.userInteractionEnabled = true;
    settings[@"priority"] = @"none";
}

- (IBAction)LevelPriority:(id)sender {
    self.NoPriorityButton.alpha = 0.3;
    self.noPriorityLabel.alpha = 0.3;
    self.NoPriorityButton.userInteractionEnabled = true;
    self.leveledPriorityButton.alpha = 1;
    self.leveledPriorityLabel.alpha = 1;
    self.leveledPriorityButton.userInteractionEnabled = false;
    settings[@"priority"] = @"2level";
}

- (IBAction)BasicReminder:(id)sender {
    self.BasicRemainderButton.alpha = 1;
    self.basicReminderLabel.alpha = 1;
    self.BasicRemainderButton.userInteractionEnabled = false;
    self.detailedRemainderButton.alpha = 0.3;
    self.detailedReminderLabel.alpha = 0.3;
    self.detailedRemainderButton.userInteractionEnabled = true;
    settings[@"reminder"] = @"basic";
}

- (IBAction)DetailedReminder:(id)sender {
    self.BasicRemainderButton.alpha = 0.3;
    self.basicReminderLabel.alpha = 0.3;
    self.BasicRemainderButton.userInteractionEnabled = true;
    self.detailedRemainderButton.alpha = 1;
    self.detailedReminderLabel.alpha = 1;
    self.detailedRemainderButton.userInteractionEnabled = false;
    settings[@"reminder"] = @"detailed";
}

- (IBAction)twentyFourHour:(id)sender {
    NSLog(@"(%.1f,%.1f)\n(%.1f,%.1f)",self.scroller.frame.size.width,self.scroller.frame.size.height,self.scroller.contentSize.width,self.scroller.contentSize.height);
    self.twelveButton.alpha = 0.3;
    self.twelveLabel.alpha  = 0.3;
    self.twelveButton.userInteractionEnabled = true;
    self.twentyFourButton.alpha = 1;
    self.twentyFourLabel.alpha  = 1;
    self.twentyFourButton.userInteractionEnabled = false;
    settings[@"clock"] = @"24";
}

- (IBAction)twelveHour:(id)sender {
    self.twelveButton.alpha = 1;
    self.twelveLabel.alpha = 1;
    self.twelveButton.userInteractionEnabled = false;
    self.twentyFourButton.alpha = 0.3;
    self.twentyFourLabel.alpha = 0.3;
    self.twentyFourButton.userInteractionEnabled = true;
    settings[@"clock"] = @"12";
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults] setObject:settings forKey:@"settings"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)buyThemes:(id)sender {
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    [[DEStoreKitManager sharedManager] purchaseProductWithIdentifier: @"Themes"
        onSuccess: ^(SKPaymentTransaction *transaction) {
            [d setBool:true forKey:@"themesBought"];
            self.themeShield.hidden = true;
            [d synchronize];
        } onRestore: nil
        onFailure: ^(SKPaymentTransaction *transaction) {
            [d setBool:false forKey:@"themesBought"];
            self.themeShield.hidden = false;
            [d synchronize];
            [[[UIAlertView alloc] initWithTitle:@"Unknown Error!" message:@"An error occured during purchase. Please try again later." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        } onCancel: ^(SKPaymentTransaction *transaction) {
            [d setBool:false forKey:@"themesBought"];
            self.themeShield.hidden = false;
            [d synchronize];
        } onVerify: nil];
    
}
- (IBAction)buyPriority:(id)sender {
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    [[DEStoreKitManager sharedManager] purchaseProductWithIdentifier: @"Priority"
        onSuccess: ^(SKPaymentTransaction *transaction) {
           NSLog(@"memeler");
           [d setBool:true forKey:@"priorityBought"];
            self.priorityShield.hidden = true;
            [d synchronize];
        } onRestore: nil
        onFailure: ^(SKPaymentTransaction *transaction) {
           [d setBool:false forKey:@"priorityBought"];
            self.priorityShield.hidden = false;
            [d synchronize];
           [[[UIAlertView alloc] initWithTitle:@"Unknown Error!" message:@"An error occured during purchase. Please try again later." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        } onCancel: ^(SKPaymentTransaction *transaction) {
           [d setBool:false forKey:@"priorityBought"];
            self.priorityShield.hidden = false;
            [d synchronize];
        } onVerify: nil];
}

- (IBAction)buyReminder:(id)sender {
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    [[DEStoreKitManager sharedManager] purchaseProductWithIdentifier: @"Reminder"
        onSuccess: ^(SKPaymentTransaction *transaction) {
            NSLog(@"memeler");
           [d setBool:true forKey:@"reminderBought"];
            self.reminderShield.hidden = true;
            [d synchronize];
        } onRestore: nil
        onFailure: ^(SKPaymentTransaction *transaction) {
           [d setBool:false forKey:@"reminderBought"];
            self.reminderShield.hidden = false;
            [d synchronize];
           [[[UIAlertView alloc] initWithTitle:@"Unknown Error!" message:@"An error occured during purchase. Please try again later." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        } onCancel: ^(SKPaymentTransaction *transaction) {
           [d setBool:false forKey:@"reminderBought"];
            self.reminderShield.hidden = false;
            [d synchronize];
        } onVerify: nil];
}

- (IBAction)restorePurchases:(id)sender {
    
    [[DEStoreKitManager sharedManager] restorePurchasesOnSuccess:^(SKPaymentTransaction *transaction) {
        NSString *t = transaction.payment.productIdentifier;
        NSLog(@"transaction: %@",transaction);
        NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
        if ([t isEqualToString:@"Themes"]) {
            [d setBool:true forKey:@"themesBought"];
            self.themeShield.hidden = true;
            [d synchronize];
        }else if ([t isEqualToString:@"Priority"]) {
            [d setBool:true forKey:@"priorityBought"];
            self.priorityShield.hidden = true;
            [d synchronize];
        }else if ([t isEqualToString:@"Reminder"]) {
            [d setBool:true forKey:@"reminderBought"];
            self.reminderShield.hidden = true;
            [d synchronize];
        }
    } onFailure:^(NSError *error) {
        NSLog(@"failed");
    }];
}


@end
