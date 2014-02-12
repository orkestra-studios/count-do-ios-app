//
//  CDSettingsViewController.m
//  count.do
//
//  Created by Can Bülbül on 11/02/14.
//  Copyright (c) 2014 Can Bülbül. All rights reserved.
//

#import "CDSettingsViewController.h"

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
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] dictionaryForKey:@"settings"]) {
        settings = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"settings"]];
    }else{
        settings = [[NSMutableDictionary alloc] initWithDictionary:@{@"theme":@"basic",@"priority":@"none",@"reminder":@"basic"}];
    }
    
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setObject:settings forKey:@"settings"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)goBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end