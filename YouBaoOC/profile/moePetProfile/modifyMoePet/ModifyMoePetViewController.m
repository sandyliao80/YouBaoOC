//
//  ModifyMoePetViewController.m
//  YouBaoOC
//
//  Created by eagle on 14/8/19.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ModifyMoePetViewController.h"
#import "LCYCommon.h"

@interface ModifyMoePetViewController ()

@end

@implementation ModifyMoePetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"navigationBack"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(navigationBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setFrame:CGRectMake(0, 0, 40, 28)];
    [doneButton setTitle:@" 确定 " forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    doneButton.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    doneButton.layer.masksToBounds = YES;
    [doneButton setBackgroundColor:THEME_LIGHT_COLOR];
    [doneButton setTitleColor:THEME_DARK_BLUE forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    [doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    if (!self.petDetailBase) {
        // 需要加载宠物信息
        [[LCYCommon sharedInstance] showTips:@"加载宠物信息" inView:self.view];
        [self reloadPetData];
    } else {
        // 无需加载宠物信息
        [self makeScene];
    }
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
- (void)navigationBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneButtonPressed:(id)sender{
    
}

- (void)reloadPetData{
    NSDictionary *parameters = @{@"pet_id"  : self.userPetInfo.petId};
    [[LCYNetworking sharedInstance] postRequestWithAPI:Pet_GetPetDetailByID parameters:parameters successBlock:^(NSDictionary *object) {
        [[LCYCommon sharedInstance] hideTipsInView:self.view];
        self.petDetailBase = [GetPetDetailBase modelObjectWithDictionary:object];
        // 下载成功，加载界面
        [self makeScene];
    } failedBlock:^{
        [[LCYCommon sharedInstance] hideTipsInView:self.view];
    }];
}

- (void)makeScene{
    // 加载场景内容
}

@end
