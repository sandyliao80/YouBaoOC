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

@end

@implementation ModifyTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSAssert(self.modifyTitle, @"必须提供修改的字段名哦！");
    
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
    [[LCYCommon sharedInstance] showTips:@"修改中" inView:self.view];
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(didModifyText:textInfo:)]) {
        [self.delegate didModifyText:self.modifyTitle textInfo:self.icyTextField.text];
    }
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
    [self.icyTextField becomeFirstResponder];
    return cell;
}

@end
