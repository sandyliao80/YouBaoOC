//
//  ProfileHomeViewController.m
//  YouBaoOC
//
//  Created by Licy on 14-7-28.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ProfileHomeViewController.h"
#import "LCYCommon.h"
#import "AppDelegate.h"
#import "ProfileHomeAvatarCell.h"
#import "ProfileHomeLikeCell.h"
#import "ProfileHomeContentCell.h"
#import "ProfileHomePetCell.h"
#import "ProfileHomeButtonCell.h"

@interface ProfileHomeViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ProfileHomeViewController

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

- (IBAction)logoutButtonPressed:(UIButton *)sender {
    [[LCYCommon sharedInstance] logout];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"RegisterAndLogin" bundle:nil];
    UINavigationController *navigationVC = storyBoard.instantiateInitialViewController;
    appDelegate.window.rootViewController = navigationVC;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2 + 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        // 头像
        ProfileHomeAvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileHomeAvatarCellIdentifier];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 70.0f;
    }
    return 0;
}


@end
