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

@interface ProfileSettingViewController ()<UITableViewDelegate, UITableViewDataSource>

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

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"关于我们";
    } else {
        cell.textLabel.text = @"退出账号";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        [[LCYCommon sharedInstance] logout];
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"RegisterAndLogin" bundle:nil];
        UINavigationController *navigationVC = storyBoard.instantiateInitialViewController;
        appDelegate.window.rootViewController = navigationVC;
    }
}

@end
