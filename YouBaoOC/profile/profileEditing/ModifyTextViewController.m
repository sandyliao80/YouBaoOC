//
//  ModifyTextViewController.m
//  YouBaoOC
//
//  Created by eagle on 14/8/20.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "ModifyTextViewController.h"
#import "ModifyTextCell.h"
#import "LCYCommon.h"

@interface ModifyTextViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UITextField *icyTextField;

@property (strong, nonatomic) NSDictionary *myMap;

@end

@implementation ModifyTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSAssert(self.modifyTitle, @"必须提供修改的字段名哦！");
    
    self.myMap = @{@"姓名"            : @"nick_name",
                   @"签名"            : @"tip",
                   @"QQ"            : @"qq",
                   @"微信"    : @"wechat",
                   @"新浪微博"  : @"weibo",
                   @"固定电话"  : @"telephone",
                   @"详细地址"  : @"address"};
    
    self.navigationItem.title = self.modifyTitle;
    
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"navigationBack"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(navigationBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBackItem;
    
    // 确定按钮
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setFrame:CGRectMake(0, 0, 40, 24)];
    [doneButton setTitle:@" 确定 " forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    doneButton.layer.cornerRadius = 4.0f;
    doneButton.layer.masksToBounds = YES;
    [doneButton setBackgroundColor:THEME_DARK_BLUE];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    [doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightItem;
    

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
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(cancleModifyText:)]) {
        [self.delegate cancleModifyText:self.modifyTitle];
    }
}

- (void)doneButtonPressed:(id)sender{
//    [[LCYCommon sharedInstance] showTips:@"修改中" inView:self.view];
    
    NSDictionary *parameters = @{@"user_name":[LCYGlobal sharedInstance].currentUserID,
                                 @"key":self.myMap[self.modifyTitle],
                                 @"value":self.icyTextField.text};
    [[LCYCommon sharedInstance] showTips:@"修改中" inView:self.view];
    [[LCYNetworking sharedInstance] postRequestWithAPI:User_modifySingleProperty parameters:parameters successBlock:^(NSDictionary *object) {
        if ([object[@"result"] boolValue]) {
            [self.navigationController popViewControllerAnimated:YES];
            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
            [defaultCenter postNotificationName:@"reloadProfile" object:nil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:object[@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        [[LCYCommon sharedInstance] hideTipsInView:self.view];
    } failedBlock:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"修改失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [[LCYCommon sharedInstance] hideTipsInView:self.view];
    }];
    
//    if (self.delegate &&
//        [self.delegate respondsToSelector:@selector(didModifyText:textInfo:)]) {
//        [self.delegate didModifyText:self.modifyTitle textInfo:self.icyTextField.text];
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ModifyTextCell *cell = [tableView dequeueReusableCellWithIdentifier:ModifyTextCellIdentifier];
    self.icyTextField = cell.icyTextField;
    if (self.defaultText) {
        self.icyTextField.text = self.defaultText;
    }
    if ([self.modifyTitle isEqualToString:@"QQ"] ||
        [self.modifyTitle isEqualToString:@"固定电话"]) {
        [self.icyTextField setKeyboardType:UIKeyboardTypeNumberPad];
    }
    [self.icyTextField becomeFirstResponder];
    return cell;
}

@end
