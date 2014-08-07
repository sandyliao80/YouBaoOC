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
#import "AddPetViewController.h"

@interface ProfileHomeViewController ()<UITableViewDelegate, UITableViewDataSource, AddPetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *icyTableView;

@end

@implementation ProfileHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 0.0f;
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setFrame:CGRectMake(0, 0, 44.0f, 44.0f)];
    [settingButton setImage:[UIImage imageNamed:@"profileSetting"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(settingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    [self.navigationItem setLeftBarButtonItems:@[fixedSpace, leftButtonItem]];
    
    UIBarButtonItem *rightFixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightFixedSpace.width = 0.0f;
    UIButton *editingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editingButton setFrame:CGRectMake(0, 0, 44.0f, 44.0f)];
    [editingButton setImage:[UIImage imageNamed:@"profileEdit"] forState:UIControlStateNormal];
    [editingButton addTarget:self action:@selector(editingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editingButton];
    [self.navigationItem setRightBarButtonItems:@[rightFixedSpace, rightButtonItem]];
    
    [self.icyTableView setBackgroundColor:[UIColor clearColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"addPetIdentifier"]) {
        AddPetViewController *addPetVC = [segue destinationViewController];
        addPetVC.delegate = self;
    }
}


#pragma mark - Actions
- (IBAction)logoutButtonPressed:(UIButton *)sender {
    [[LCYCommon sharedInstance] logout];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"RegisterAndLogin" bundle:nil];
    UINavigationController *navigationVC = storyBoard.instantiateInitialViewController;
    appDelegate.window.rootViewController = navigationVC;
}

- (void)settingButtonPressed:(id)sender{
    
}

- (void)editingButtonPressed:(id)sender{
    
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
        return 80.0f;
    } else if (indexPath.row == 1) {
        // 喜欢
        return 44.0f;
    } else if (indexPath.row == 2 || indexPath.row == 3) {
        // 个人信息
        return 44.0f;
    }
    else if (indexPath.row == 6) {
        // 按钮
        return 60.0f;
    } else {
        // 宠物
        return 70.0f;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - AddPetDelegate
- (void)AddPetDidFinished:(AddPetViewController *)viewController{
    
}

@end
