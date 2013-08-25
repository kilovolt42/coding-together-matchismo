//
//  SettingsViewController.m
//  Matchismo
//
//  Created by Kyle Stevens on 8/25/13.
//  Copyright (c) 2013 kilovolt42. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *dealOnTabSwitch;
@end

@implementation SettingsViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSDictionary *settings = [[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTINGS_KEY];
	self.dealOnTabSwitch.on = [settings[DEAL_ON_TAB_KEY] boolValue];
}

- (IBAction)toggleDealOnTab:(UISwitch *)sender {
	NSMutableDictionary *mutableSettings = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTINGS_KEY] mutableCopy];
	if (!mutableSettings) mutableSettings = [[NSMutableDictionary alloc] init];
	mutableSettings[DEAL_ON_TAB_KEY] = @(sender.on);
	[[NSUserDefaults standardUserDefaults] setObject:mutableSettings forKey:SETTINGS_KEY];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
