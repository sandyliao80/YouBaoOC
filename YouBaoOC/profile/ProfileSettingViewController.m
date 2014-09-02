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
#import "SettingCell.h"
#import "PasswordForgetViewController.h"

NSInteger const ExitTag = 12;

@interface ProfileSettingViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *icyFooterView;

@property (weak, nonatomic) IBOutlet UITableView *icyTableView;

@property (weak, nonatomic) IBOutlet UIButton *exitButton;

@end

@implementation ProfileSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.exitButton.layer setCornerRadius:3.0f];
    [self.exitButton.layer setBorderWidth:1.0f];
    [self.exitButton.layer setBorderColor:[[UIColor redColor] CGColor]];
    [self.exitButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.icyTableView setTableFooterView:self.icyFooterView];
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
//
//- (IBAction)exitButtonPressed:(id)sender {
//    [[LCYCommon sharedInstance] logout];
//    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"RegisterAndLogin" bundle:nil];
//    UINavigationController *navigationVC = storyBoard.instantiateInitialViewController;
//    appDelegate.window.rootViewController = navigationVC;
//}

- (IBAction)exitButtonPressed:(id)sender {
    UIAlertView *exitAlert = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"再考虑下嘛" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    exitAlert.tag = ExitTag;
    [exitAlert show];
}


#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:SettingCellIdentifier];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 修改密码
            cell.icyLabel.text = @"修改密码";
            cell.icyImageView.image = [UIImage imageNamed:@"settingCode"];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // 意见反馈
            cell.icyLabel.text = @"意见反馈";
            cell.icyImageView.image = [UIImage imageNamed:@"settingSuggestion"];
        } else if (indexPath.row == 1) {
            // 关于我们
            cell.icyLabel.text = @"关于我们";
            cell.icyImageView.image = [UIImage imageNamed:@"settingAboutUs"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 修改密码
            UIStoryboard *passwordSB = [UIStoryboard storyboardWithName:@"RegisterAndLogin" bundle:nil];
            PasswordForgetViewController *passwordVC = [passwordSB instantiateViewControllerWithIdentifier:@"passwordForget"];
            [self.navigationController pushViewController:passwordVC animated:YES];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // 意见反馈
        } else if (indexPath.row == 1) {
            // 关于我们
        }
    }
}

#pragma mark - UIAlert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == ExitTag) {
        if (buttonIndex == 0) {
            // 确定
            [[LCYCommon sharedInstance] logout];
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"RegisterAndLogin" bundle:nil];
            UINavigationController *navigationVC = storyBoard.instantiateInitialViewController;
            appDelegate.window.rootViewController = navigationVC;
        } else {
            // 取消
        }
    }
}

@end
