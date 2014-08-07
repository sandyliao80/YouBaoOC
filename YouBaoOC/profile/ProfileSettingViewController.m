//
//  ProfileSettingViewController.m
//  YouBaoOC
//
//  Created by Licy on 14-8-7.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ProfileSettingViewController.h"
#import "AppDelegate.h"
#import "LCYCommon.h"

@interface ProfileSettingViewController ()

@end

@implementation ProfileSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Actions

- (IBAction)exitButtonPressed:(id)sender {
    [[LCYCommon sharedInstance] logout];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"RegisterAndLogin" bundle:nil];
    UINavigationController *navigationVC = storyBoard.instantiateInitialViewController;
    appDelegate.window.rootViewController = navigationVC;
}

@end
