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
@property (weak, nonatomic) IBOutlet UITableView *icyTableView;

@end

@implementation ProfileHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.icyTableView setBackgroundColor:[UIColor clearColor]];
//    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
//    [backgroundView setBackgroundColor:[UIColor clearColor]];
//    [self.icyTableView setBackgroundView:backgroundView];
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
    return 2 + 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        // 头像
        ProfileHomeAvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileHomeAvatarCellIdentifier];
        return cell;
    } else if (indexPath.row == 1) {
        // 喜欢
        ProfileHomeLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileHomeLikeCellIdentifier];
        return cell;
    } else if (indexPath.row == 2 || indexPath.row == 3) {
        // 个人信息
        ProfileHomeContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileHomeContentCellIdentifier];
        return cell;
    }
    else if (indexPath.row == 6) {
        // 按钮
        ProfileHomeButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileHomeButtonCellIdentifier];
        return cell;
    } else {
        // 宠物
        ProfileHomePetCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileHomePetCellIdentifier];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        // 头像
        return 70.0f;
    } else if (indexPath.row == 1) {
        // 喜欢
        return 44.0f;
    } else if (indexPath.row == 2 || indexPath.row == 3) {
        // 个人信息
        return 44.0f;
    }
    else if (indexPath.row == 6) {
        // 按钮
        return 44.0f;
    } else {
        // 宠物
        return 44.0f;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
