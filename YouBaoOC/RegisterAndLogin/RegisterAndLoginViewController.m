//
//  RegisterAndLoginViewController.m
//  YouBaoOC
//
//  Created by Licy on 14-7-24.
//  Copyright (c) 2014年 Duostec. All rights reserved.
//

#import "RegisterAndLoginViewController.h"

typedef NS_ENUM(NSUInteger, RegisterAndLoginStatus) {
    RegisterAndLoginStatusRegister,
    RegisterAndLoginStatusLogin
};

@interface RegisterAndLoginViewController ()

@property (nonatomic) RegisterAndLoginStatus currentStatus;

#pragma mark - 发送验证码
@property (weak, nonatomic) IBOutlet UIButton *sendAuthButton;
@property (strong, nonatomic) IBOutlet UIView *sendAuthView;

#pragma mark - 注册
@property (weak, nonatomic) IBOutlet UIButton *regDoneButton;
@end

@implementation RegisterAndLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentStatus = RegisterAndLoginStatusRegister;
    
    // 导航栏
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"手机号注册", @"手机号登录"]];
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.tintColor = THEME_COLOR;
    [segmentedControl setSelectedSegmentIndex:0];
    [self.navigationItem setTitleView:segmentedControl];
    
    // 按钮圆角
    self.sendAuthButton.layer.cornerRadius = 7.0f;
    self.regDoneButton.layer.cornerRadius = 7.0f;
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

- (void)segmentedControlValueChanged:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
        self.currentStatus = RegisterAndLoginStatusRegister;
        [UIView animateWithDuration:0.35 animations:^{
            [self.view addSubview:self.sendAuthView];
        }];
    } else {
        self.currentStatus = RegisterAndLoginStatusLogin;
        [UIView animateWithDuration:0.35 animations:^{
            [self.sendAuthView removeFromSuperview];
        }];
    }
}

@end
